import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class HealthDataPdfRequest {
  final DateTime start;
  final DateTime end;
  final String? name;
  final bool includeDailyLog;
  final bool includeJournalEntries;
  final DateTime generatedAt;

  HealthDataPdfRequest({
    required this.start,
    required this.end,
    this.name,
    this.includeDailyLog = true,
    this.includeJournalEntries = false,
    DateTime? generatedAt,
  }) : generatedAt = generatedAt ?? DateTime.now();
}

class HealthDataPdfSummary {
  final int cycleCount;
  final double? averageCycleLength;
  final double? averagePeriodLength;
  final Map<String, int> symptomFrequency;
  final int dailyLogCount;
  final int journalEntryCount;

  const HealthDataPdfSummary({
    required this.cycleCount,
    required this.averageCycleLength,
    required this.averagePeriodLength,
    required this.symptomFrequency,
    required this.dailyLogCount,
    required this.journalEntryCount,
  });
}

class HealthDataPdfRenderer {
  static final _forest = PdfColor.fromHex('#1F5C4A');
  static final _forestLight = PdfColor.fromHex('#E7F0EC');
  static final _ivory = PdfColor.fromHex('#FBF7EF');
  static final _charcoal = PdfColor.fromHex('#27312E');
  static final _slate = PdfColor.fromHex('#64716D');
  static final _border = PdfColor.fromHex('#D9E1DE');

  HealthDataPdfSummary summarize(List<Map<String, dynamic>> records) {
    final cycles = _recordsFor(records, 'cycles');
    final cycleDays = _recordsFor(records, 'cycle_days');
    final symptomLogs = _recordsFor(records, 'symptom_logs');
    final journals = _recordsFor(records, 'journal_entries');

    final cycleLengths = cycles
        .map((record) => _asInt(record['cycleLength']))
        .whereType<int>()
        .toList();
    final periodLengths = cycles
        .map((record) => _asInt(record['periodLength']))
        .whereType<int>()
        .toList();
    final frequency = <String, int>{};
    for (final log in symptomLogs) {
      final name = (log['symptomName'] ?? log['name'] ?? 'Other').toString();
      frequency[name] = (frequency[name] ?? 0) + 1;
    }

    return HealthDataPdfSummary(
      cycleCount: cycles.length,
      averageCycleLength: _average(cycleLengths),
      averagePeriodLength: _average(periodLengths),
      symptomFrequency: frequency,
      dailyLogCount: cycleDays.length,
      journalEntryCount: journals.length,
    );
  }

  Future<Uint8List> render(
    List<Map<String, dynamic>> records,
    HealthDataPdfRequest request,
  ) async {
    final summary = summarize(records);
    final cycles = _recordsFor(records, 'cycles')
      ..sort((a, b) => _date(a['startDate']).compareTo(_date(b['startDate'])));
    final cycleDays = _recordsFor(records, 'cycle_days')
      ..sort((a, b) => _date(a['date']).compareTo(_date(b['date'])));
    final symptomLogs = _recordsFor(records, 'symptom_logs')
      ..sort((a, b) => _date(a['date']).compareTo(_date(b['date'])));
    final journals = _recordsFor(records, 'journal_entries')
      ..sort((a, b) => _date(a['date']).compareTo(_date(b['date'])));
    final pdf = pw.Document(
      title: 'Cyra cycle and symptom summary',
      author: 'Cyra',
      subject: 'Clinician-readable health data export',
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(42, 48, 42, 44),
        header: _header,
        footer: _footer,
        build: (context) => [
          _cover(request),
          pw.SizedBox(height: 24),
          _statCards(summary),
          pw.SizedBox(height: 26),
          _sectionTitle('Cycle history'),
          if (cycles.isEmpty)
            _emptyState('No cycle data was logged in this date range.')
          else
            _cycleTable(cycles, cycleDays),
          pw.SizedBox(height: 24),
          _sectionTitle('Symptoms seen most often'),
          if (summary.symptomFrequency.isEmpty)
            _emptyState('No symptoms were logged in this date range.')
          else
            _symptomTable(summary.symptomFrequency),
          pw.SizedBox(height: 18),
          _disclaimer(),
          if (request.includeDailyLog) ...[
            pw.NewPage(),
            _sectionTitle('Detailed daily log'),
            pw.SizedBox(height: 6),
            if (cycleDays.isEmpty && symptomLogs.isEmpty)
              _emptyState('No daily details were logged in this date range.')
            else
              _dailyTable(cycleDays, symptomLogs, cycles),
          ],
          if (request.includeJournalEntries) ...[
            pw.NewPage(),
            _sectionTitle('Personal journal entries'),
            pw.Text(
              "Included at the user's request.",
              style: pw.TextStyle(fontSize: 9, color: _slate),
            ),
            pw.SizedBox(height: 12),
            if (journals.isEmpty)
              _emptyState('No journal entries were logged in this date range.')
            else
              ...journals.map(_journalEntry),
          ],
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _header(pw.Context context) => pw.Container(
    padding: const pw.EdgeInsets.only(bottom: 8),
    decoration: pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: _border)),
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'CYRA',
          style: pw.TextStyle(
            color: _forest,
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 1.4,
          ),
        ),
        pw.Text(
          'CYCLE HEALTH',
          style: pw.TextStyle(color: _slate, fontSize: 8, letterSpacing: 1.1),
        ),
      ],
    ),
  );

  pw.Widget _footer(pw.Context context) => pw.Container(
    padding: const pw.EdgeInsets.only(top: 8),
    decoration: pw.BoxDecoration(
      border: pw.Border(top: pw.BorderSide(color: _border)),
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'Generated privately on this device',
          style: pw.TextStyle(fontSize: 8, color: _slate),
        ),
        pw.Text(
          'Page ${context.pageNumber} of ${context.pagesCount}',
          style: pw.TextStyle(fontSize: 8, color: _slate),
        ),
      ],
    ),
  );

  pw.Widget _cover(HealthDataPdfRequest request) => pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.all(20),
    decoration: pw.BoxDecoration(
      color: _ivory,
      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Cycle & symptom summary',
          style: pw.TextStyle(
            color: _charcoal,
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 12),
        if (request.name?.trim().isNotEmpty == true)
          _coverLine('Prepared for', request.name!.trim()),
        _coverLine(
          'Date range',
          '${_formatDate(request.start)} - ${_formatDate(request.end)}',
        ),
        _coverLine('Generated', _formatDate(request.generatedAt)),
      ],
    ),
  );

  pw.Widget _coverLine(String label, String value) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 3),
    child: pw.RichText(
      text: pw.TextSpan(
        style: pw.TextStyle(fontSize: 10, color: _slate),
        children: [
          pw.TextSpan(
            text: '$label: ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.TextSpan(text: value),
        ],
      ),
    ),
  );

  pw.Widget _statCards(HealthDataPdfSummary summary) => pw.Row(
    children: [
      _statCard('${summary.cycleCount}', 'cycles tracked'),
      pw.SizedBox(width: 10),
      _statCard(_days(summary.averageCycleLength), 'average cycle'),
      pw.SizedBox(width: 10),
      _statCard(_days(summary.averagePeriodLength), 'average period'),
    ],
  );

  pw.Widget _statCard(String value, String label) => pw.Expanded(
    child: pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: _forestLight,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(
              color: _forest,
              fontSize: 17,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(label, style: pw.TextStyle(color: _slate, fontSize: 8)),
        ],
      ),
    ),
  );

  pw.Widget _sectionTitle(String title) => pw.Text(
    title,
    style: pw.TextStyle(
      color: _forest,
      fontSize: 15,
      fontWeight: pw.FontWeight.bold,
    ),
  );

  pw.Widget _cycleTable(
    List<Map<String, dynamic>> cycles,
    List<Map<String, dynamic>> cycleDays,
  ) {
    final flowByCycle = <String, int>{};
    for (final day in cycleDays) {
      final cycleId = day['cycleId']?.toString();
      final flow = _asInt(day['flowIntensity']) ?? 0;
      if (cycleId != null && flow > (flowByCycle[cycleId] ?? 0)) {
        flowByCycle[cycleId] = flow;
      }
    }
    return _table(
      headers: const ['Start', 'End', 'Cycle', 'Period', 'Peak flow'],
      rows: cycles
          .map(
            (cycle) => [
              _formatDate(_date(cycle['startDate'])),
              cycle['endDate'] == null
                  ? 'Ongoing'
                  : _formatDate(_date(cycle['endDate'])),
              _dayValue(cycle['cycleLength']),
              _dayValue(cycle['periodLength']),
              _flowLabel(flowByCycle[cycle['id']?.toString()] ?? 0),
            ],
          )
          .toList(),
    );
  }

  pw.Widget _symptomTable(Map<String, int> frequency) {
    final sorted = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return _table(
      headers: const ['Symptom', 'Logged'],
      rows: sorted
          .map(
            (entry) => [
              entry.key,
              '${entry.value} day${entry.value == 1 ? '' : 's'}',
            ],
          )
          .toList(),
      widths: const {0: pw.FlexColumnWidth(3), 1: pw.FlexColumnWidth(1)},
    );
  }

  pw.Widget _dailyTable(
    List<Map<String, dynamic>> cycleDays,
    List<Map<String, dynamic>> symptomLogs,
    List<Map<String, dynamic>> cycles,
  ) {
    final symptomsByDay = <String, List<String>>{};
    for (final log in symptomLogs) {
      final key = _dayKey(_date(log['date']));
      final name = (log['symptomName'] ?? log['name'] ?? 'Other').toString();
      final severity = _asInt(log['severity']);
      symptomsByDay
          .putIfAbsent(key, () => [])
          .add(severity == null ? name : '$name ($severity/5)');
    }
    final dayByDate = <String, Map<String, dynamic>>{
      for (final day in cycleDays) _dayKey(_date(day['date'])): day,
    };
    final dates = {...dayByDate.keys, ...symptomsByDay.keys}.toList()..sort();
    return _table(
      headers: const ['Date', 'Cycle day', 'Flow', 'Symptoms'],
      rows: dates.map((key) {
        final date = DateTime.parse(key);
        final day = dayByDate[key];
        final cycle = _cycleForDate(cycles, date);
        final cycleDay = cycle == null
            ? '-'
            : 'Day ${date.difference(_date(cycle['startDate'])).inDays + 1}';
        return [
          _formatDate(date),
          cycleDay,
          _flowLabel(_asInt(day?['flowIntensity']) ?? 0),
          symptomsByDay[key]?.join(', ') ?? '-',
        ];
      }).toList(),
      widths: const {
        0: pw.FlexColumnWidth(1.3),
        1: pw.FlexColumnWidth(1.1),
        2: pw.FlexColumnWidth(1),
        3: pw.FlexColumnWidth(3),
      },
    );
  }

  pw.Widget _table({
    required List<String> headers,
    required List<List<String>> rows,
    Map<int, pw.TableColumnWidth>? widths,
  }) => pw.TableHelper.fromTextArray(
    headers: headers,
    data: rows,
    columnWidths: widths,
    headerDecoration: pw.BoxDecoration(color: _forest),
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontSize: 8,
      fontWeight: pw.FontWeight.bold,
    ),
    cellStyle: pw.TextStyle(color: _charcoal, fontSize: 8.5),
    cellPadding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 6),
    border: pw.TableBorder(
      horizontalInside: pw.BorderSide(color: _border, width: 0.5),
      bottom: pw.BorderSide(color: _border, width: 0.5),
    ),
    oddRowDecoration: pw.BoxDecoration(color: _ivory),
  );

  pw.Widget _journalEntry(Map<String, dynamic> entry) => pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 12),
    padding: const pw.EdgeInsets.all(12),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: _border),
      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          _formatDate(_date(entry['date'])),
          style: pw.TextStyle(
            color: _forest,
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        if (entry['title']?.toString().trim().isNotEmpty == true) ...[
          pw.SizedBox(height: 4),
          pw.Text(
            entry['title'].toString(),
            style: pw.TextStyle(
              color: _charcoal,
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
        if (entry['content']?.toString().trim().isNotEmpty == true) ...[
          pw.SizedBox(height: 5),
          pw.Text(
            entry['content'].toString(),
            style: pw.TextStyle(color: _charcoal, fontSize: 9.5),
          ),
        ],
      ],
    ),
  );

  pw.Widget _emptyState(String text) => pw.Container(
    width: double.infinity,
    margin: const pw.EdgeInsets.only(top: 8),
    padding: const pw.EdgeInsets.all(14),
    decoration: pw.BoxDecoration(
      color: _ivory,
      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
    ),
    child: pw.Text(text, style: pw.TextStyle(color: _slate, fontSize: 9.5)),
  );

  pw.Widget _disclaimer() => pw.Text(
    'This summary reflects only the information logged in Cyra. It can help a conversation with a care professional, but it is not a diagnosis or medical advice.',
    style: pw.TextStyle(color: _slate, fontSize: 8.5, lineSpacing: 2),
  );

  List<Map<String, dynamic>> _recordsFor(
    List<Map<String, dynamic>> records,
    String table,
  ) => records
      .where((record) => record['table'] == table)
      .map((record) => Map<String, dynamic>.from(record))
      .toList();

  Map<String, dynamic>? _cycleForDate(
    List<Map<String, dynamic>> cycles,
    DateTime date,
  ) {
    for (final cycle in cycles.reversed) {
      final start = _date(cycle['startDate']);
      final end = cycle['endDate'] == null
          ? start.add(Duration(days: _asInt(cycle['cycleLength']) ?? 35))
          : _date(cycle['endDate']);
      if (!date.isBefore(start) && !date.isAfter(end)) return cycle;
    }
    return null;
  }

  double? _average(List<int> values) => values.isEmpty
      ? null
      : values.reduce((value, element) => value + element) / values.length;

  int? _asInt(dynamic value) => switch (value) {
    int number => number,
    num number => number.round(),
    String text => int.tryParse(text),
    _ => null,
  };

  DateTime _date(dynamic value) => switch (value) {
    DateTime date => date,
    int milliseconds => DateTime.fromMillisecondsSinceEpoch(milliseconds),
    String text =>
      DateTime.tryParse(text) ?? DateTime.fromMillisecondsSinceEpoch(0),
    _ => DateTime.fromMillisecondsSinceEpoch(0),
  };

  String _formatDate(DateTime date) => DateFormat('d MMM yyyy').format(date);
  String _dayKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
  String _days(double? value) =>
      value == null ? '-' : '${value.toStringAsFixed(1)} days';
  String _dayValue(dynamic value) =>
      _asInt(value) == null ? '-' : '${_asInt(value)} d';
  String _flowLabel(int flow) => switch (flow) {
    <= 0 => 'None',
    1 => 'Light',
    2 => 'Medium',
    3 => 'Heavy',
    _ => 'Very heavy',
  };
}
