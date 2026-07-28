/// Supported runtime locale selection.
enum LocalePreference { system, english, thai }

/// Supported runtime theme selection.
enum ThemePreference { system, light, dark }

/// Selects between built-in business rules and user-defined behavior.
enum LogicPreference { standard, freestyle }

/// User-owned non-schedule application preferences.
class AppSettings {
  const AppSettings({
    this.locale = LocalePreference.system,
    this.theme = ThemePreference.system,
    this.logic = LogicPreference.standard,
    this.googleWebClientId = '',
    this.demoMode = false,
  });

  final LocalePreference locale;
  final ThemePreference theme;
  final LogicPreference logic;
  final String googleWebClientId;
  final bool demoMode;

  AppSettings copyWith({
    LocalePreference? locale,
    ThemePreference? theme,
    LogicPreference? logic,
    String? googleWebClientId,
    bool? demoMode,
  }) {
    return AppSettings(
      locale: locale ?? this.locale,
      theme: theme ?? this.theme,
      logic: logic ?? this.logic,
      googleWebClientId: googleWebClientId ?? this.googleWebClientId,
      demoMode: demoMode ?? this.demoMode,
    );
  }
}
