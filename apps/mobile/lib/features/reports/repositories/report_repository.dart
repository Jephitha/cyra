import 'dart:io';
import 'dart:math';

import 'package:cyra/core/database/app_database.dart' as db;
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/reports/models/report_models.dart';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportRepository {
  final db.AppDatabase _db;
  final EncryptionService _encryption;

  ReportRepository(this._db, this._encryption);

  // ── PDF Generation ────────────────────────────────────────────

  Future<File> generateCycleSummaryReport(
      DateTime start, DateTime end) async {
    final cycleData = await _getCyclesInRange(start, end);
    final reportData = await _buildReportData(start, end, cycleData);

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(context, 'Cycle Summary Report'),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildIntro(context, start, end),
          _buildSectionTitle(context, 'Cycle Overview'),
          _buildStatRow(context, 'Total Cycles', '${reportData.totalCycles}'),
          _buildStatRow(context, 'Average Cycle Length',
              '${reportData.averageCycleLength.toStringAsFixed(1)} days'),
          _buildStatRow(context, 'Average Period Length',
              '${reportData.averagePeriodLength.toStringAsFixed(1)} days'),
          _buildStatRow(context, 'Variability Score',
              '${reportData.variabilityScore.toStringAsFixed(2)}'),
          pw.SizedBox(height: 20),
          _buildSectionTitle(context, 'Cycle Details'),
          if (cycleData.isEmpty)
            _buildEmptyText(context, 'No cycle data available for this period.')
          else
            ...cycleData.map((c) => _buildCycleRow(context, c)),
          pw.SizedBox(height: 20),
          _buildSectionTitle(context, 'Notes'),
          _buildParagraph(context,
              reportData.notes ?? 'No additional notes.'),
        ],
      ),
    );

    return _saveReport(pdf, 'cycle_summary', start, end);
  }

  Future<File> generateFertilityReport(
      DateTime start, DateTime end) async {
    final cycleData = await _getCyclesInRange(start, end);
    final reportData = await _buildReportData(start, end, cycleData);

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(context, 'Fertility Report'),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildIntro(context, start, end),
          _buildSectionTitle(context, 'Fertility Summary'),
          if (reportData.fertilitySummary != null)
            _buildParagraph(context, reportData.fertilitySummary!)
          else
            _buildParagraph(context,
                'Track your BBT and OPK results to get a fertility summary.'),
          pw.SizedBox(height: 20),
          _buildSectionTitle(context, 'Cycle Patterns'),
          _buildStatRow(context, 'Average Cycle Length',
              '${reportData.averageCycleLength.toStringAsFixed(1)} days'),
          _buildStatRow(context, 'Average Period Length',
              '${reportData.averagePeriodLength.toStringAsFixed(1)} days'),
          _buildStatRow(context, 'Variability Score',
              '${reportData.variabilityScore.toStringAsFixed(2)}'),
          pw.SizedBox(height: 20),
          _buildSectionTitle(context, 'Fertile Window Estimates'),
          if (cycleData.isEmpty)
            _buildEmptyText(context, 'No cycle data available.')
          else
            ...cycleData.map((c) {
              final ovulationDay = max(1, (c.cycleLength - 14));
              final fertileStart = max(1, ovulationDay - 5);
              final fertileEnd = ovulationDay + 1;
              return _buildParagraph(context,
                  'Cycle starting ${DateFormat('MMM d, yyyy').format(c.startDate)}: '
                  'Estimated ovulation day $ovulationDay, '
                  'fertile window days $fertileStart-$fertileEnd.');
            }),
        ],
      ),
    );

    return _saveReport(pdf, 'fertility_report', start, end);
  }

  Future<File> generateSymptomReport(
      DateTime start, DateTime end) async {
    final symptomData = await _getSymptomLogsInRange(start, end);
    final cycleData = await _getCyclesInRange(start, end);
    final reportData = await _buildReportData(start, end, cycleData);

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(context, 'Symptom Report'),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildIntro(context, start, end),
          _buildSectionTitle(context, 'Symptom Summary'),
          _buildStatRow(context, 'Total Symptom Entries',
              '${symptomData.length}'),
          _buildStatRow(context, 'Unique Symptoms',
              '${symptomData.map((s) => s.name).toSet().length}'),
          pw.SizedBox(height: 20),
          _buildSectionTitle(context, 'Symptom Frequency'),
          if (symptomData.isEmpty)
            _buildEmptyText(context, 'No symptoms logged in this period.')
          else
            ..._aggregateSymptoms(symptomData).entries.map((e) =>
                _buildStatRow(context, e.key, '${e.value} entries')),
          pw.SizedBox(height: 20),
          _buildSectionTitle(context, 'Severity Distribution'),
          if (symptomData.isNotEmpty)
            _buildParagraph(context,
                'Average severity: ${(symptomData.fold<int>(0, (a, b) => a + b.severity) / symptomData.length).toStringAsFixed(1)} / 5')
          else
            _buildEmptyText(context, 'No severity data.'),
          pw.SizedBox(height: 20),
          _buildSectionTitle(context, 'Notes'),
          _buildParagraph(context,
              reportData.notes ?? 'No additional notes.'),
        ],
      ),
    );

    return _saveReport(pdf, 'symptom_report', start, end);
  }

  Future<File> generateFullHistoryReport() async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 365 * 2));
    return generateCycleSummaryReport(start, now);
  }

  // ── Report Persistence ────────────────────────────────────────

  Future<HealthReport> saveReportMetadata(HealthReport report) async {
    final now = DateTime.now();

    await _db.into(_db.healthReports).insert(db.HealthReportsCompanion.insert(
      id: report.id,
      userId: '',
      reportType: report.reportType,
      dateRangeStart: report.dateRangeStart,
      dateRangeEnd: report.dateRangeEnd,
      filePath: report.filePath != null ? Value(report.filePath!) : Value.absent(),
      fileSize: report.fileSize != null ? Value(report.fileSize!) : Value.absent(),
      createdAt: now,
    ));

    return report.copyWith(isGenerated: true, createdAt: now);
  }

  Future<HealthReport?> getReport(String id) async {
    final result = await (_db.select(_db.healthReports)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (result == null) return null;
    return _toDomainReport(result);
  }

  Future<List<HealthReport>> getAllReports() async {
    final results = await (_db.select(_db.healthReports)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return results.map(_toDomainReport).toList();
  }

  Future<void> deleteReport(String id) async {
    final report = await getReport(id);
    if (report?.filePath != null) {
      try {
        final file = File(report!.filePath!);
        if (await file.exists()) await file.delete();
      } catch (_) {}
    }
    await (_db.delete(_db.healthReports)
          ..where((t) => t.id.equals(id))).go();
  }

  Future<File> decryptReportFile(String encryptedPath) async {
    final tempDir = await getApplicationDocumentsDirectory();
    final tempFile = File(
        '${tempDir.path}/temp_reports/${DateTime.now().millisecondsSinceEpoch}.pdf');
    final parent = tempFile.parent;
    if (!await parent.exists()) await parent.create(recursive: true);

    await _encryption.decryptFile(File(encryptedPath), tempFile);
    return tempFile;
  }

  // ── Private Helpers ───────────────────────────────────────────

  Future<List<Cycle>> _getCyclesInRange(DateTime start, DateTime end) async {
    final results = await (_db.select(_db.cycles)
          ..where((t) => t.startDate.isBetween(Variable(start), Variable(end)))
          ..orderBy([(t) => OrderingTerm.asc(t.startDate)]))
        .get();

    return results.map((r) => Cycle(
      id: r.id,
      startDate: r.startDate,
      endDate: r.endDate,
      cycleLength: r.cycleLength ?? 28,
      periodLength: r.periodLength ?? 5,
      notes: r.notes != null ? _encryption.decryptString(r.notes!) : null,
      createdAt: r.createdAt,
      updatedAt: r.updatedAt,
    )).toList();
  }

  Future<List<SymptomEntry>> _getSymptomLogsInRange(
      DateTime start, DateTime end) async {
    final logs = await (_db.select(_db.symptomLogs)
          ..where((t) => t.date.isBetween(Variable(start), Variable(end)))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();

    final symptoms = await _db.select(_db.symptoms).get();
    final symptomMap = {for (final s in symptoms) s.id: s};

    return logs.map((log) {
      final symptom = symptomMap[log.symptomId];
      return SymptomEntry(
        id: '${log.id}',
        name: symptom?.name ?? log.symptomId,
        category: symptom?.category ?? 'general',
        loggedAt: log.date,
        severity: log.severity,
        notes: log.notes,
      );
    }).toList();
  }

  Future<ReportData> _buildReportData(
      DateTime start, DateTime end, List<Cycle> cycles) async {
    final symptomLogs = await _getSymptomLogsInRange(start, end);

    final lengths = cycles.map((c) => c.cycleLength).toList();
    final periodLengths = cycles.map((c) => c.periodLength).toList();

    final avgCycle =
        lengths.isEmpty ? 0.0 : lengths.fold<int>(0, (a, b) => a + b) / lengths.length;
    final avgPeriod = periodLengths.isEmpty
        ? 0.0
        : periodLengths.fold<int>(0, (a, b) => a + b) / periodLengths.length;

    final variance = lengths.isEmpty
        ? 0.0
        : lengths.fold<double>(0, (a, b) => a + pow(b - avgCycle, 2)) / lengths.length;
    final variability = lengths.length > 1 ? sqrt(variance) / avgCycle : 0.0;

    return ReportData(
      generatedAt: DateTime.now(),
      dateRangeStart: start,
      dateRangeEnd: end,
      totalCycles: cycles.length,
      averageCycleLength: avgCycle,
      averagePeriodLength: avgPeriod,
      variabilityScore: variability,
      cycles: cycles,
      symptoms: symptomLogs,
      fertilitySummary: _buildFertilitySummary(cycles),
      notes: null,
    );
  }

  String? _buildFertilitySummary(List<Cycle> cycles) {
    if (cycles.isEmpty) return null;
    final avg = cycles.fold<int>(0, (a, b) => a + b.cycleLength) ~/ cycles.length;
    final ovulationDay = max(1, avg - 14);
    return 'Based on $avg-day average cycles, ovulation typically occurs '
        'around day $ovulationDay. Fertile window is approximately '
        'days ${max(1, ovulationDay - 5)} to ${ovulationDay + 1}.';
  }

  Map<String, int> _aggregateSymptoms(List<SymptomEntry> entries) {
    final map = <String, int>{};
    for (final e in entries) {
      map[e.name] = (map[e.name] ?? 0) + 1;
    }
    return map;
  }

  // ── PDF Layout Helpers ───────────────────────────────────────

  pw.Widget _buildHeader(pw.Context context, String title) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Cyra',
                style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColors.green700,
                  fontWeight: pw.FontWeight.bold,
                )),
            pw.Text(title,
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey,
                )),
          ],
        ),
        pw.Divider(color: PdfColors.green700),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey300),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Generated by Cyra',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
            pw.Text(
                'Page ${context.pageNumber}',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildIntro(
      pw.Context context, DateTime start, DateTime end) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Cyra Health Report',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green800,
            )),
        pw.SizedBox(height: 8),
        pw.Text(
          'Date Range: ${DateFormat('MMM d, yyyy').format(start)} - '
          '${DateFormat('MMM d, yyyy').format(end)}',
          style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey),
        ),
        pw.Text(
          'Generated: ${DateFormat('MMMM d, yyyy – h:mm a').format(DateTime.now())}',
          style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey),
        ),
        pw.SizedBox(height: 16),
        pw.Divider(color: PdfColors.grey300),
        pw.SizedBox(height: 16),
      ],
    );
  }

  pw.Widget _buildSectionTitle(pw.Context context, String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green800,
            )),
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget _buildStatRow(pw.Context context, String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey)),
          pw.Text(value,
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green700,
              )),
        ],
      ),
    );
  }

  pw.Widget _buildCycleRow(pw.Context context, Cycle cycle) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 4),
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Cycle: ${DateFormat('MMM d, yyyy').format(cycle.startDate)}',
                  style: pw.TextStyle(
                      fontSize: 11, fontWeight: pw.FontWeight.bold)),
              pw.Text('${cycle.cycleLength} days',
                  style: const pw.TextStyle(fontSize: 11)),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text('Period: ${cycle.periodLength} days',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
          if (cycle.endDate != null)
            pw.Text('Ended: ${DateFormat('MMM d, yyyy').format(cycle.endDate!)}',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
        ],
      ),
    );
  }

  pw.Widget _buildParagraph(pw.Context context, String text) {
    return pw.Paragraph(
      text: text,
      style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.5),
    );
  }

  pw.Widget _buildEmptyText(pw.Context context, String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 12),
      child: pw.Text(text,
          style:
              pw.TextStyle(fontSize: 11, color: PdfColors.grey, fontStyle: pw.FontStyle.italic)),
    );
  }

  Future<File> _saveReport(pw.Document pdf, String type,
      DateTime start, DateTime end) async {
    final dir = await getApplicationDocumentsDirectory();
    final reportDir = Directory('${dir.path}/reports');
    if (!await reportDir.exists()) await reportDir.create(recursive: true);

    final fileName =
        '${type}_${start.toIso8601String().split('T').first}_${end.toIso8601String().split('T').first}.pdf';
    final unencryptedPath = '${reportDir.path}/$fileName';
    final encryptedPath = '${reportDir.path}/$fileName.encrypted';

    final unencryptedFile = File(unencryptedPath);
    await unencryptedFile.writeAsBytes(await pdf.save());

    await _encryption.encryptFile(unencryptedFile, File(encryptedPath));

    if (await unencryptedFile.exists()) await unencryptedFile.delete();

    final fileSize = await File(encryptedPath).length();

    final report = HealthReport(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      reportType: type,
      dateRangeStart: start,
      dateRangeEnd: end,
      filePath: encryptedPath,
      fileSize: fileSize,
      isGenerated: true,
      createdAt: DateTime.now(),
    );

    await saveReportMetadata(report);

    return File(encryptedPath);
  }

  HealthReport _toDomainReport(db.HealthReport entity) {
    return HealthReport(
      id: entity.id,
      reportType: entity.reportType,
      dateRangeStart: entity.dateRangeStart,
      dateRangeEnd: entity.dateRangeEnd,
      filePath: entity.filePath,
      fileSize: entity.fileSize,
      isGenerated: true,
      createdAt: entity.createdAt,
    );
  }
}
