import { serve } from 'https://deno.land/std@0.224.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.45.0'

interface CycleInput {
  id: string
  start_date: string
  end_date: string | null
  cycle_length: number | null
  period_length: number | null
  ovulation_day: number | null
}

interface SymptomInput {
  date: string
  symptom_name: string
  severity: number
  category: string
}

interface AnalysisRequest {
  userId: string
}

interface CyclePatternInsights {
  cycleLength: {
    average: number
    minimum: number
    maximum: number
    variability: number
    regularity: 'very_regular' | 'regular' | 'irregular' | 'very_irregular'
  }
  periodLength: {
    average: number
    minimum: number
    maximum: number
  }
  ovulationTiming: {
    averageOvulationDay: number | null
    consistency: 'consistent' | 'variable' | 'insufficient_data'
    fertileWindowPredicted: { start: number; end: number } | null
  }
  symptomPatterns: {
    preMenstrual: { name: string; frequency: number }[]
    duringPeriod: { name: string; frequency: number }[]
    postPeriod: { name: string; frequency: number }[]
    overall: { name: string; frequency: number }[]
  }
  lutealPhase: {
    average: number | null
    isAdequate: boolean | null
  }
}

function categorizeRegularity(variability: number): 'very_regular' | 'regular' | 'irregular' | 'very_irregular' {
  if (variability <= 2) return 'very_regular'
  if (variability <= 7) return 'regular'
  if (variability <= 14) return 'irregular'
  return 'very_irregular'
}

function getCyclePhase(date: string, cycleStart: string, periodLength: number, cycleLength: number): 'pre_menstrual' | 'during_period' | 'post_period' {
  const dayDiff = Math.round((new Date(date).getTime() - new Date(cycleStart).getTime()) / (1000 * 60 * 60 * 24)) + 1
  if (dayDiff <= periodLength) return 'during_period'
  if (dayDiff >= cycleLength - 5) return 'pre_menstrual'
  return 'post_period'
}

function analyzeCyclePatterns(
  cycles: CycleInput[],
  symptoms: SymptomInput[],
): CyclePatternInsights {
  const completedCycles = cycles.filter((c) => c.end_date != null && c.cycle_length != null) as (CycleInput & { cycle_length: number })[]
  const lengths = completedCycles.map((c) => c.cycle_length)
  const periodLengths = completedCycles.filter((c) => c.period_length != null).map((c) => c.period_length as number)
  const ovulationDays = completedCycles.filter((c) => c.ovulation_day != null).map((c) => c.ovulation_day as number)

  const avgLength = lengths.length > 0 ? Math.round(lengths.reduce((a, b) => a + b, 0) / lengths.length) : 0
  const minLength = lengths.length > 0 ? Math.min(...lengths) : 0
  const maxLength = lengths.length > 0 ? Math.max(...lengths) : 0
  const variability = maxLength - minLength
  const regularity = lengths.length >= 3 ? categorizeRegularity(variability) : 'insufficient_data' as any

  const avgPeriod = periodLengths.length > 0 ? Math.round(periodLengths.reduce((a, b) => a + b, 0) / periodLengths.length) : 0
  const minPeriod = periodLengths.length > 0 ? Math.min(...periodLengths) : 0
  const maxPeriod = periodLengths.length > 0 ? Math.max(...periodLengths) : 0

  const avgOvulation = ovulationDays.length > 0
    ? Math.round(ovulationDays.reduce((a, b) => a + b, 0) / ovulationDays.length)
    : null

  const ovulationConsistency = ovulationDays.length >= 3
    ? (Math.max(...ovulationDays) - Math.min(...ovulationDays) <= 3 ? 'consistent' : 'variable')
    : 'insufficient_data' as any

  const fertileWindow = avgOvulation != null
    ? { start: Math.max(1, avgOvulation - 5), end: avgOvulation + 1 }
    : null

  // Symptom phase analysis
  const preMenstrual: Record<string, number> = {}
  const duringPeriod: Record<string, number> = {}
  const postPeriod: Record<string, number> = {}
  const overall: Record<string, number> = {}

  for (const cycle of completedCycles) {
    const cycleSymptoms = symptoms.filter((s) => {
      return s.date >= cycle.start_date && s.date <= cycle.end_date
    })
    const pLen = cycle.period_length ?? avgPeriod
    const cLen = cycle.cycle_length
    for (const symptom of cycleSymptoms) {
      overall[symptom.symptom_name] = (overall[symptom.symptom_name] || 0) + 1
      const phase = getCyclePhase(symptom.date, cycle.start_date, pLen, cLen)
      if (phase === 'pre_menstrual') preMenstrual[symptom.symptom_name] = (preMenstrual[symptom.symptom_name] || 0) + 1
      else if (phase === 'during_period') duringPeriod[symptom.symptom_name] = (duringPeriod[symptom.symptom_name] || 0) + 1
      else postPeriod[symptom.symptom_name] = (postPeriod[symptom.symptom_name] || 0) + 1
    }
  }

  const toSortedArray = (map: Record<string, number>) =>
    Object.entries(map)
      .map(([name, frequency]) => ({ name, frequency }))
      .sort((a, b) => b.frequency - a.frequency)
      .slice(0, 5)

  const symptomPatterns = {
    preMenstrual: toSortedArray(preMenstrual),
    duringPeriod: toSortedArray(duringPeriod),
    postPeriod: toSortedArray(postPeriod),
    overall: toSortedArray(overall),
  }

  const lutealLengths = completedCycles
    .filter((c) => c.luteal_phase_length != null)
    .map((c) => c.luteal_phase_length as number)
  const avgLuteal = lutealLengths.length > 0
    ? Math.round(lutealLengths.reduce((a, b) => a + b, 0) / lutealLengths.length)
    : null

  return {
    cycleLength: { average: avgLength, minimum: minLength, maximum: maxLength, variability, regularity: regularity as any },
    periodLength: { average: avgPeriod, minimum: minPeriod, maximum: maxPeriod },
    ovulationTiming: { averageOvulationDay: avgOvulation, consistency: ovulationConsistency, fertileWindowPredicted: fertileWindow },
    symptomPatterns,
    lutealPhase: { average: avgLuteal, isAdequate: avgLuteal != null ? avgLuteal >= 12 : null },
  }
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

    const body: AnalysisRequest = await req.json()
    const userId = body.userId || user.id

    if (userId !== user.id) {
      return new Response(JSON.stringify({ error: 'Forbidden: can only analyze your own data' }), { status: 403, headers: { 'Content-Type': 'application/json' } })
    }

    const [cyclesResult, symptomsResult] = await Promise.all([
      supabaseClient.from('cycles').select('*').eq('user_id', userId).order('start_date', { ascending: true }),
      supabaseClient.from('symptom_logs').select('date, symptoms!inner(name, category), severity').eq('user_id', userId).order('date', { ascending: true }),
    ])

    const cycles = (cyclesResult.data ?? []) as CycleInput[]
    const rawSymptoms = (symptomsResult.data ?? []) as any[]
    const mappedSymptoms: SymptomInput[] = rawSymptoms.map((s) => ({
      date: s.date,
      symptom_name: s.symptoms?.name ?? 'Unknown',
      severity: s.severity,
      category: s.symptoms?.category ?? 'other',
    }))

    if (cycles.length < 2) {
      return new Response(JSON.stringify({
        insights: null,
        message: 'At least 2 completed cycles are needed for pattern analysis.',
        cyclesTracked: cycles.length,
      }), { status: 200, headers: { 'Content-Type': 'application/json' } })
    }

    const insights = analyzeCyclePatterns(cycles, mappedSymptoms)

    return new Response(JSON.stringify({
      insights,
      cyclesAnalyzed: cycles.length,
      symptomsAnalyzed: mappedSymptoms.length,
      message: 'Analysis complete. No results have been stored.',
      privacyNote: 'All analysis is performed in-memory. No personal health data is persisted by this function.',
    }), { status: 200, headers: { 'Content-Type': 'application/json' } })
  } catch (error) {
    console.error('Error analyzing cycle patterns:', error)
    return new Response(JSON.stringify({ error: 'Internal server error' }), { status: 500, headers: { 'Content-Type': 'application/json' } })
  }
})
