import 'dart:convert';

import '../../../core/result/result.dart';
import '../../../core/storage/atomic_string_store.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/roster_policy.dart';
import '../../../domain/repositories/settings_repository.dart';

/// Atomic production repository for locale, theme, and demo preferences.
class SharedPreferencesSettingsRepository implements SettingsRepository {
  SharedPreferencesSettingsRepository({AtomicStringStore? store})
    : store =
          store ?? AtomicStringStore(namespace: 'sce3.application_settings.v1');

  final AtomicStringStore store;

  @override
  Future<Result<AppSettings>> load() async {
    try {
      final payload = await store.read();
      if (payload == null) return const Success(AppSettings());
      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, Object?> || decoded['formatVersion'] != 1) {
        return const ValidationFailure('Unsupported settings format.');
      }
      return Success(
        AppSettings(
          locale: _locale(decoded['locale']),
          theme: _theme(decoded['theme']),
          logic: _logic(decoded['logic']),
          googleWebClientId: _googleWebClientId(decoded['googleWebClientId']),
          demoMode: decoded['demoMode'] == true,
          rosterPolicy: _policy(decoded['rosterPolicy']),
        ),
      );
    } on Object catch (error, stackTrace) {
      return PersistenceFailure(
        'Could not load application settings.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<Result<AppSettings>> save(AppSettings settings) async {
    try {
      await store.write(
        jsonEncode({
          'formatVersion': 1,
          'locale': settings.locale.name,
          'theme': settings.theme.name,
          'logic': settings.logic.name,
          'googleWebClientId': settings.googleWebClientId.trim(),
          'demoMode': settings.demoMode,
          'rosterPolicy': {
            'minimumRestHours': settings.rosterPolicy.minimumRestHours,
            'maximumContinuousHours':
                settings.rosterPolicy.maximumContinuousHours,
            'maximumShiftsPerDay': settings.rosterPolicy.maximumShiftsPerDay,
            'maximumShiftsPerWeek': settings.rosterPolicy.maximumShiftsPerWeek,
            'maximumShiftsPerMonth':
                settings.rosterPolicy.maximumShiftsPerMonth,
            'blockOverlappingShifts':
                settings.rosterPolicy.blockOverlappingShifts,
            'requireExchangeApproval':
                settings.rosterPolicy.requireExchangeApproval,
            'overtimeThresholdHours':
                settings.rosterPolicy.overtimeThresholdHours,
            'overtimeMultiplier': settings.rosterPolicy.overtimeMultiplier,
            'holidayRateMultiplier':
                settings.rosterPolicy.holidayRateMultiplier,
          },
        }),
      );
      return Success(settings);
    } on Object catch (error, stackTrace) {
      return PersistenceFailure(
        'Could not save application settings.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  LocalePreference _locale(Object? value) {
    return LocalePreference.values
            .where((item) => item.name == value)
            .firstOrNull ??
        LocalePreference.system;
  }

  String _googleWebClientId(Object? value) {
    final clientId = value is String ? value.trim() : '';
    return clientId.isEmpty ? AppSettings.defaultGoogleWebClientId : clientId;
  }

  ThemePreference _theme(Object? value) {
    return ThemePreference.values
            .where((item) => item.name == value)
            .firstOrNull ??
        ThemePreference.system;
  }

  LogicPreference _logic(Object? value) {
    return LogicPreference.values
            .where((item) => item.name == value)
            .firstOrNull ??
        LogicPreference.standard;
  }

  RosterPolicy _policy(Object? value) {
    if (value is! Map) return const RosterPolicy();
    int integer(String key, int fallback) =>
        value[key] is num ? (value[key] as num).round() : fallback;
    double number(String key, double fallback) =>
        value[key] is num ? (value[key] as num).toDouble() : fallback;
    return RosterPolicy(
      minimumRestHours: integer('minimumRestHours', 8).clamp(0, 48),
      maximumContinuousHours: integer(
        'maximumContinuousHours',
        16,
      ).clamp(1, 48),
      maximumShiftsPerDay: integer('maximumShiftsPerDay', 2).clamp(1, 10),
      maximumShiftsPerWeek: integer('maximumShiftsPerWeek', 7).clamp(1, 70),
      maximumShiftsPerMonth: integer('maximumShiftsPerMonth', 31).clamp(1, 100),
      blockOverlappingShifts: value['blockOverlappingShifts'] != false,
      requireExchangeApproval: value['requireExchangeApproval'] != false,
      overtimeThresholdHours: number('overtimeThresholdHours', 8).clamp(0, 24),
      overtimeMultiplier: number('overtimeMultiplier', 1.5).clamp(1, 10),
      holidayRateMultiplier: number('holidayRateMultiplier', 1.5).clamp(1, 10),
    );
  }
}
