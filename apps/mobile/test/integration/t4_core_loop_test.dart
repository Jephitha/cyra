import 'dart:io';

import 'package:cyra/core/database/app_database.dart';
import 'package:cyra/features/cycle/repositories/cycle_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/in_memory_database.dart';

void main() {
  test('T4 core loop survives a database restart', () async {
    final directory = await Directory.systemTemp.createTemp('cyra-t4-smoke');
    final file = File('${directory.path}/cyra.db');
    final encryption = await createTestEncryptionService();
    final periodStart = DateTime(2026, 6, 10);

    var database = AppDatabase(executor: NativeDatabase(file));
    var repository = CycleRepository(database, encryption);

    // Log Period writes through the same repository path exercised by its
    // widget test. Dashboard and Calendar consume these two queries.
    await repository.logPeriodStart(periodStart, flowIntensity: 2);
    final activeBeforeRestart = await repository.getActiveCycle();
    expect(activeBeforeRestart, isNotNull);
    expect(
      await repository.getCycleDayForCycle(
        activeBeforeRestart!.id,
        periodStart,
      ),
      isNotNull,
    );

    await database.close();

    database = AppDatabase(executor: NativeDatabase(file));
    repository = CycleRepository(database, encryption);
    final activeAfterRestart = await repository.getActiveCycle();
    final calendarDays = await repository.getCycleDays(activeAfterRestart!.id);

    expect(activeAfterRestart.startDate, periodStart);
    expect(calendarDays, hasLength(1));
    expect(calendarDays.single.flowIntensity, 2);

    await database.close();
    await directory.delete(recursive: true);
  });
}
