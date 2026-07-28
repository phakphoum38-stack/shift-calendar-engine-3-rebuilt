import 'package:flutter_test/flutter_test.dart';
import 'package:shift_calendar_engine/core/result/result.dart';
import 'package:shift_calendar_engine/core/storage/atomic_string_store.dart';
import 'package:shift_calendar_engine/domain/entities/exchange_request.dart';
import 'package:shift_calendar_engine/features/exchange/infrastructure/shared_preferences_exchange_repository.dart';

import 'support/fixtures.dart';

void main() {
  test('exchange requests survive atomic repository round-trip', () async {
    final schedule = canonicalScheduleFixture();
    final owner = schedule.assignments.first.employee;
    final store = _MemoryStringStore();
    final repository = SharedPreferencesExchangeRepository(
      store: AtomicStringStore(namespace: 'exchange-test', store: store),
    );
    final request = ExchangeRequest(
      id: 'request-1',
      type: ExchangeType.cover,
      sourceAssignmentId: schedule.assignments.first.id,
      sourceDate: schedule.days.first.date,
      requester: owner,
      recipient: owner.copyWith(
        id: 'employee-2',
        employeeCode: 'E002',
        firstName: 'สมหญิง',
      ),
      reason: 'Appointment',
      status: ExchangeStatus.submitted,
      createdAt: DateTime(2027, 4, 1, 9),
    );

    expect((await repository.save(request)).isSuccess, isTrue);
    final loaded = await repository.findAll();

    expect(loaded.isSuccess, isTrue);
    final values = (loaded as Success<List<ExchangeRequest>>).value;
    expect(values.single.id, request.id);
    expect(values.single.recipient.employeeCode, 'E002');
    expect(values.single.status, ExchangeStatus.submitted);
  });
}

class _MemoryStringStore implements StringStore {
  final values = <String, String>{};

  @override
  Future<String?> getString(String key) async => values[key];

  @override
  Future<void> setString(String key, String value) async {
    values[key] = value;
  }
}
