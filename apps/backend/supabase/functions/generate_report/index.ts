import { serve } from 'https://deno.land/std@0.224.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.45.0'
import { PDFDocument, rgb, StandardFonts } from 'https://esm.sh/pdf-lib@1.17.1'

interface ReportRequest {
  userId: string
  dateRangeStart: string
  dateRangeEnd: string
  reportType: 'cycle_summary' | 'fertility_report' | 'symptoms_report' | 'full_health_report'
}

interface CycleSummary {
  totalCycles: number
  averageCycleLength: number
  averagePeriodLength: number
  averageLutealPhase: number
  cycleVariability: number
}

interface FertilityMetrics {
  totalOvulationTests: number
  positiveTests: number
  peakTests: number
  predictedOvulationAccuracy: number | null
  bbtCoverline: number | null
  bbtPatterns: string[]
}

interface SymptomSummary {
  mostCommonSymptoms: { name: string; count: number }[]
  averageMoodScore: number
  symptomFreeDays: number
  categoryBreakdown: Record<string, number>
}

function calculateCycleSummary(cycles: any[]): CycleSummary {
  const completed = cycles.filter((c: any) => c.end_date != null && c.cycle_length != null)
  if (completed.length === 0) {
    return { totalCycles: 0, averageCycleLength: 0, averagePeriodLength: 0, averageLutealPhase: 0, cycleVariability: 0 }
  }
  const lengths = completed.map((c: any) => c.cycle_length)
  const avgLength = Math.round(lengths.reduce((a: number, b: number) => a + b, 0) / lengths.length)
  const variability = Math.round(Math.max(...lengths) - Math.min(...lengths))
  const periodLengths = completed.filter((c: any) => c.period_length != null).map((c: any) => c.period_length)
  const avgPeriod = periodLengths.length > 0 ? Math.round(periodLengths.reduce((a: number, b: number) => a + b, 0) / periodLengths.length) : 0
  const luteal = completed.filter((c: any) => c.luteal_phase_length != null).map((c: any) => c.luteal_phase_length)
  const avgLuteal = luteal.length > 0 ? Math.round(luteal.reduce((a: number, b: number) => a + b, 0) / luteal.length) : 0
  return { totalCycles: completed.length, averageCycleLength: avgLength, averagePeriodLength: avgPeriod, averageLutealPhase: avgLuteal, cycleVariability: variability }
}

function calculateFertilityMetrics(ovulationTests: any[], bbtRecords: any[]): FertilityMetrics {
  const total = ovulationTests.length
  const positive = ovulationTests.filter((t: any) => t.result === 'positive' || t.result === 'peak').length
  const peak = ovulationTests.filter((t: any) => t.result === 'peak').length
  const bbtTemps = bbtRecords.map((r: any) => r.temperature)
  const coverline = bbtTemps.length > 0 ? Math.round(bbtTemps.reduce((a: number, b: number) => a + b, 0) / bbtTemps.length * 100) / 100 : null
  const patterns: string[] = []
  if (total > 0) patterns.push(`${positive} positive out of ${total} tests`)
  if (peak > 0) patterns.push(`${peak} peak readings detected`)
  if (bbtRecords.length > 5) patterns.push('Sufficient BBT data for thermal shift analysis')
  return { totalOvulationTests: total, positiveTests: positive, peakTests: peak, predictedOvulationAccuracy: null, bbtCoverline: coverline, bbtPatterns: patterns }
}

function calculateSymptomSummary(symptomLogs: any[], journalEntries: any[]): SymptomSummary {
  const symptomCounts: Record<string, number> = {}
  for (const log of symptomLogs) {
    const name = log.symptom_name || 'Unknown'
    symptomCounts[name] = (symptomCounts[name] || 0) + 1
  }
  const sorted = Object.entries(symptomCounts)
    .map(([name, count]) => ({ name, count }))
    .sort((a, b) => b.count - a.count)
    .slice(0, 10)
  const moods = journalEntries.filter((j: any) => j.mood_score != null).map((j: any) => j.mood_score)
  const avgMood = moods.length > 0 ? Math.round(moods.reduce((a: number, b: number) => a + b, 0) / moods.length * 10) / 10 : 0
  return { mostCommonSymptoms: sorted, averageMoodScore: avgMood, symptomFreeDays: 0, categoryBreakdown: {} }
}

function generateReportHtml(summary: CycleSummary, fertility: FertilityMetrics, symptom: SymptomSummary, start: string, end: string): string {
  let symptomRows = ''
  for (const s of symptom.mostCommonSymptoms) {
    symptomRows += `<tr><td>${s.name}</td><td>${s.count}</td></tr>\n`
  }
  let fertilityRows = ''
  for (const p of fertility.bbtPatterns) {
    fertilityRows += `<li>${p}</li>\n`
  }
  return `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <style>
    body { font-family: 'Helvetica', 'Arial', sans-serif; color: #1a1a2e; padding: 40px; line-height: 1.6; }
    h1 { color: #e75480; font-size: 28px; border-bottom: 2px solid #e75480; padding-bottom: 10px; }
    h2 { color: #1a1a2e; font-size: 20px; margin-top: 30px; }
    .header { text-align: center; margin-bottom: 30px; }
    .header p { color: #666; }
    table { width: 100%; border-collapse: collapse; margin: 15px 0; }
    th, td { padding: 10px 12px; text-align: left; border-bottom: 1px solid #eee; }
    th { background: #fce4ec; font-weight: 600; }
    ul { padding-left: 20px; }
    li { margin: 6px 0; }
    .footer { margin-top: 40px; padding-top: 20px; border-top: 1px solid #ddd; font-size: 12px; color: #999; text-align: center; }
    .disclaimer { background: #fff3f6; padding: 15px; border-radius: 8px; font-size: 13px; color: #666; margin: 20px 0; }
  </style>
</head>
<body>
  <div class="header">
    <h1>Cyra Health Report</h1>
    <p>${start} - ${end}</p>
  </div>

  <h2>Cycle Summary</h2>
  <table>
    <tr><th>Metric</th><th>Value</th></tr>
    <tr><td>Total Cycles Tracked</td><td>${summary.totalCycles}</td></tr>
    <tr><td>Average Cycle Length</td><td>${summary.averageCycleLength} days</td></tr>
    <tr><td>Average Period Length</td><td>${summary.averagePeriodLength} days</td></tr>
    <tr><td>Average Luteal Phase</td><td>${summary.averageLutealPhase} days</td></tr>
    <tr><td>Cycle Length Variability</td><td>${summary.cycleVariability} days</td></tr>
  </table>

  <h2>Fertility Insights</h2>
  <table>
    <tr><th>Metric</th><th>Value</th></tr>
    <tr><td>Ovulation Tests Logged</td><td>${fertility.totalOvulationTests}</td></tr>
    <tr><td>Positive / Peak Results</td><td>${fertility.positiveTests} / ${fertility.peakTests}</td></tr>
    <tr><td>BBT Coverline</td><td>${fertility.bbtCoverline != null ? fertility.bbtCoverline + '°C' : 'Insufficient data'}</td></tr>
  </table>
  ${fertility.bbtPatterns.length > 0 ? `<ul>${fertilityRows}</ul>` : ''}

  <h2>Symptom Overview</h2>
  ${symptom.mostCommonSymptoms.length > 0
    ? `<table><tr><th>Symptom</th><th>Occurrences</th></tr>${symptomRows}</table>`
    : '<p>No symptoms logged in this period.</p>'
  }
  <p><strong>Average Mood Score:</strong> ${symptom.averageMoodScore > 0 ? symptom.averageMoodScore + ' / 5' : 'Not recorded'}</p>

  <div class="disclaimer">
    This report is generated from your logged data and is for informational purposes only. It does not constitute medical advice. Always consult with a healthcare provider regarding your health.
  </div>

  <div class="footer">
    <p>Generated by Cyra — ${new Date().toLocaleDateString()}</p>
    <p>Your data is encrypted and stored securely. This report contains your personal health information.</p>
  </div>
</body>
</html>`
}

serve(async (req) => {
  try {
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Missing authorization header' }), { status: 401, headers: { 'Content-Type': 'application/json' } })
    }

    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      { global: { headers: { Authorization: authHeader } } }
    )

    const { data: { user }, error: authError } = await supabaseClient.auth.getUser()
    if (authError || !user) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), { status: 401, headers: { 'Content-Type': 'application/json' } })
    }

    const body: ReportRequest = await req.json()
    if (!body.dateRangeStart || !body.dateRangeEnd) {
      return new Response(JSON.stringify({ error: 'dateRangeStart and dateRangeEnd are required' }), { status: 400, headers: { 'Content-Type': 'application/json' } })
    }

    const start = body.dateRangeStart
    const end = body.dateRangeEnd
    const userId = user.id

    const [cyclesResult, ovulationResult, bbtResult, symptomsResult, journalResult] = await Promise.all([
      supabaseClient.from('cycles').select('*').eq('user_id', userId).gte('start_date', start).lte('start_date', end).order('start_date', { ascending: true }),
      supabaseClient.from('ovulation_tests').select('*').eq('user_id', userId).gte('date', start).lte('date', end).order('date', { ascending: true }),
      supabaseClient.from('bbt_records').select('*').eq('user_id', userId).gte('date', start).lte('date', end).order('date', { ascending: true }),
      supabaseClient.from('symptom_logs').select('*, symptoms(name)').eq('user_id', userId).gte('date', start).lte('date', end).order('date', { ascending: true }),
      supabaseClient.from('journal_entries').select('*').eq('user_id', userId).gte('date', start).lte('date', end).order('date', { ascending: true }),
    ])

    const cycles = cyclesResult.data ?? []
    const ovulationTests = ovulationResult.data ?? []
    const bbtRecords = bbtResult.data ?? []
    const symptomLogs = symptomsResult.data ?? []
    const journalEntries = journalResult.data ?? []

    const summary = calculateCycleSummary(cycles)
    const fertility = calculateFertilityMetrics(ovulationTests, bbtRecords)
    const symptom = calculateSymptomSummary(symptomLogs, journalEntries)

    const html = generateReportHtml(summary, fertility, symptom, start, end)

    const pdfDoc = await PDFDocument.create()
    const font = await pdfDoc.embedFont(StandardFonts.Helvetica)
    const boldFont = await pdfDoc.embedFont(StandardFonts.HelveticaBold)
    let page = pdfDoc.addPage([612, 792])
    const { width, height } = page.getSize()
    const fontSize = 10
    const margin = 50
    let y = height - margin

    page.drawText('CYRA HEALTH REPORT', { x: margin, y, size: 24, font: boldFont, color: rgb(0.9, 0.33, 0.5) })
    y -= 30
    page.drawText(`Period: ${start} to ${end}`, { x: margin, y, size: 12, font: font, color: rgb(0.4, 0.4, 0.4) })
    y -= 30
    page.drawText(`Generated: ${new Date().toLocaleDateString()}`, { x: margin, y, size: 10, font: font, color: rgb(0.6, 0.6, 0.6) })
    y -= 40

    // Cycle Summary Section
    page.drawText('CYCLE SUMMARY', { x: margin, y, size: 16, font: boldFont, color: rgb(0.1, 0.1, 0.18) })
    y -= 25
    const cycleLines = [
      `Total Cycles Tracked: ${summary.totalCycles}`,
      `Average Cycle Length: ${summary.averageCycleLength} days`,
      `Average Period Length: ${summary.averagePeriodLength} days`,
      `Average Luteal Phase: ${summary.averageLutealPhase} days`,
      `Cycle Variability: ${summary.cycleVariability} days`,
    ]
    for (const line of cycleLines) {
      page.drawText(line, { x: margin + 10, y, size: fontSize, font: font, color: rgb(0.2, 0.2, 0.2) })
      y -= 18
    }
    y -= 22

    // Fertility Section
    page.drawText('FERTILITY INSIGHTS', { x: margin, y, size: 16, font: boldFont, color: rgb(0.1, 0.1, 0.18) })
    y -= 25
    const fertLines = [
      `Ovulation Tests Logged: ${fertility.totalOvulationTests}`,
      `Positive / Peak Results: ${fertility.positiveTests} / ${fertility.peakTests}`,
      `BBT Coverline: ${fertility.bbtCoverline != null ? fertility.bbtCoverline + ' C' : 'Insufficient data'}`,
      ...fertility.bbtPatterns.map((p: string) => `- ${p}`),
    ]
    for (const line of fertLines) {
      page.drawText(line, { x: margin + 10, y, size: fontSize, font: font, color: rgb(0.2, 0.2, 0.2) })
      y -= 18
    }
    y -= 22

    // Symptom Section
    page.drawText('SYMPTOM OVERVIEW', { x: margin, y, size: 16, font: boldFont, color: rgb(0.1, 0.1, 0.18) })
    y -= 25
    if (symptom.mostCommonSymptoms.length > 0) {
      page.drawText('Most Common Symptoms:', { x: margin + 10, y, size: fontSize, font: boldFont, color: rgb(0.2, 0.2, 0.2) })
      y -= 18
      for (const s of symptom.mostCommonSymptoms.slice(0, 5)) {
        page.drawText(`${s.name}: ${s.count} occurrences`, { x: margin + 20, y, size: fontSize, font: font, color: rgb(0.2, 0.2, 0.2) })
        y -= 18
      }
    } else {
      page.drawText('No symptoms logged in this period.', { x: margin + 10, y, size: fontSize, font: font, color: rgb(0.6, 0.6, 0.6) })
      y -= 18
    }
    y -= 10
    page.drawText(`Average Mood Score: ${symptom.averageMoodScore > 0 ? symptom.averageMoodScore + ' / 5' : 'Not recorded'}`, { x: margin + 10, y, size: fontSize, font: font, color: rgb(0.2, 0.2, 0.2) })
    y -= 40

    // Disclaimer
    page.drawText('DISCLAIMER', { x: margin, y, size: 12, font: boldFont, color: rgb(0.6, 0.6, 0.6) })
    y -= 18
    page.drawText('This report is for informational purposes only and does not constitute medical advice.', { x: margin, y, size: 9, font: font, color: rgb(0.6, 0.6, 0.6) })
    y -= 14
    page.drawText('Always consult with a healthcare provider regarding your health.', { x: margin, y, size: 9, font: font, color: rgb(0.6, 0.6, 0.6) })

    const pdfBytes = await pdfDoc.save()

    // Log audit entry (privacy-preserving — no personal data in metadata)
    await supabaseClient.from('audit_logs').insert({
      user_id: userId,
      action: 'report_generated',
      resource_type: 'health_report',
      resource_id: null,
      metadata: { report_type: body.reportType, date_range: { start, end } },
    })

    return new Response(pdfBytes, {
      status: 200,
      headers: {
        'Content-Type': 'application/pdf',
        'Content-Disposition': `attachment; filename="cyra-health-report-${start}-${end}.pdf"`,
      },
    })
  } catch (error) {
    console.error('Error generating report:', error)
    return new Response(JSON.stringify({ error: 'Internal server error' }), { status: 500, headers: { 'Content-Type': 'application/json' } })
  }
})
