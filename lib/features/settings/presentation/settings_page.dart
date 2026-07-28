import 'package:flutter/material.dart';

import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/roster_policy.dart';
import '../../../l10n/l10n.dart';

/// Functional language, theme, and demo-mode settings.
class SettingsPage extends StatelessWidget {
  const SettingsPage({
    required this.settings,
    required this.onChanged,
    required this.openShiftTemplates,
    super.key,
  });

  final AppSettings settings;
  final ValueChanged<AppSettings> onChanged;
  final VoidCallback openShiftTemplates;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      Text(
        context.l10n.workspaceSettings,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 16),
      _GoogleOAuthSettingsCard(settings: settings, onChanged: onChanged),
      const SizedBox(height: 16),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.language,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              SegmentedButton<LocalePreference>(
                segments: [
                  ButtonSegment(
                    value: LocalePreference.system,
                    label: Text(context.l10n.followSystem),
                  ),
                  ButtonSegment(
                    value: LocalePreference.thai,
                    label: Text(context.l10n.thai),
                  ),
                  ButtonSegment(
                    value: LocalePreference.english,
                    label: Text(context.l10n.english),
                  ),
                ],
                selected: {settings.locale},
                onSelectionChanged: (value) =>
                    onChanged(settings.copyWith(locale: value.single)),
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.theme,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              SegmentedButton<ThemePreference>(
                segments: [
                  ButtonSegment(
                    value: ThemePreference.system,
                    label: Text(context.l10n.systemTheme),
                  ),
                  ButtonSegment(
                    value: ThemePreference.light,
                    label: Text(context.l10n.lightTheme),
                  ),
                  ButtonSegment(
                    value: ThemePreference.dark,
                    label: Text(context.l10n.darkTheme),
                  ),
                ],
                selected: {settings.theme},
                onSelectionChanged: (value) =>
                    onChanged(settings.copyWith(theme: value.single)),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      _PolicySettingsCard(settings: settings, onChanged: onChanged),
      const SizedBox(height: 16),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.logicMode,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(context.l10n.logicModeDescription),
              const SizedBox(height: 12),
              SegmentedButton<LogicPreference>(
                segments: [
                  ButtonSegment(
                    value: LogicPreference.standard,
                    icon: const Icon(Icons.rule_outlined),
                    label: Text(context.l10n.standardLogic),
                  ),
                  ButtonSegment(
                    value: LogicPreference.freestyle,
                    icon: const Icon(Icons.tune),
                    label: Text(context.l10n.freestyleLogic),
                  ),
                ],
                selected: {settings.logic},
                onSelectionChanged: (value) =>
                    onChanged(settings.copyWith(logic: value.single)),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      Card(
        child: ListTile(
          leading: const Icon(Icons.view_timeline_outlined),
          title: Text(context.l10n.shiftTemplates),
          subtitle: Text(context.l10n.shiftTemplatesDescription),
          trailing: const Icon(Icons.chevron_right),
          onTap: openShiftTemplates,
        ),
      ),
      const SizedBox(height: 16),
      Card(
        child: SwitchListTile(
          title: Text(context.l10n.demoMode),
          subtitle: Text(context.l10n.demoModeDescription),
          value: settings.demoMode,
          onChanged: (value) => onChanged(settings.copyWith(demoMode: value)),
        ),
      ),
      const SizedBox(height: 16),
      Card(
        child: ListTile(
          leading: const Icon(Icons.architecture_outlined),
          title: Text(context.l10n.phaseStatus),
          subtitle: Text(context.l10n.phaseStatusDescription),
        ),
      ),
    ],
  );
}

class _PolicySettingsCard extends StatelessWidget {
  const _PolicySettingsCard({required this.settings, required this.onChanged});

  final AppSettings settings;
  final ValueChanged<AppSettings> onChanged;

  @override
  Widget build(BuildContext context) {
    final policy = settings.rosterPolicy;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.rosterRules,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(context.l10n.rosterRulesDescription),
            const SizedBox(height: 12),
            _RuleSlider(
              label: context.l10n.minimumRestHours,
              value: policy.minimumRestHours,
              min: 0,
              max: 24,
              onChanged: (value) =>
                  _save(policy.copyWith(minimumRestHours: value)),
            ),
            _RuleSlider(
              label: context.l10n.maximumContinuousHours,
              value: policy.maximumContinuousHours,
              min: 1,
              max: 24,
              onChanged: (value) =>
                  _save(policy.copyWith(maximumContinuousHours: value)),
            ),
            _RuleSlider(
              label: context.l10n.maximumShiftsPerDay,
              value: policy.maximumShiftsPerDay,
              min: 1,
              max: 6,
              onChanged: (value) =>
                  _save(policy.copyWith(maximumShiftsPerDay: value)),
            ),
            _RuleSlider(
              label: context.l10n.maximumShiftsPerWeek,
              value: policy.maximumShiftsPerWeek,
              min: 1,
              max: 21,
              onChanged: (value) =>
                  _save(policy.copyWith(maximumShiftsPerWeek: value)),
            ),
            _RuleSlider(
              label: context.l10n.maximumShiftsPerMonth,
              value: policy.maximumShiftsPerMonth,
              min: 1,
              max: 62,
              onChanged: (value) =>
                  _save(policy.copyWith(maximumShiftsPerMonth: value)),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.blockOverlappingShifts),
              value: policy.blockOverlappingShifts,
              onChanged: (value) =>
                  _save(policy.copyWith(blockOverlappingShifts: value)),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.requireExchangeApproval),
              value: policy.requireExchangeApproval,
              onChanged: (value) =>
                  _save(policy.copyWith(requireExchangeApproval: value)),
            ),
          ],
        ),
      ),
    );
  }

  void _save(RosterPolicy policy) {
    onChanged(settings.copyWith(rosterPolicy: policy));
  }
}

class _RuleSlider extends StatelessWidget {
  const _RuleSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('$label: $value'),
      Slider(
        value: value.clamp(min, max).toDouble(),
        min: min.toDouble(),
        max: max.toDouble(),
        divisions: max - min,
        label: '$value',
        onChanged: (value) => onChanged(value.round()),
      ),
    ],
  );
}

class _GoogleOAuthSettingsCard extends StatefulWidget {
  const _GoogleOAuthSettingsCard({
    required this.settings,
    required this.onChanged,
  });

  final AppSettings settings;
  final ValueChanged<AppSettings> onChanged;

  @override
  State<_GoogleOAuthSettingsCard> createState() =>
      _GoogleOAuthSettingsCardState();
}

class _GoogleOAuthSettingsCardState extends State<_GoogleOAuthSettingsCard> {
  late final TextEditingController controller = TextEditingController(
    text: widget.settings.googleWebClientId,
  );
  String? error;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.googleOAuthSettings,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(context.l10n.googleOAuthSettingsDescription),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: context.l10n.googleWebClientId,
              hintText: '123456789-abc.apps.googleusercontent.com',
              errorText: error,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
              label: Text(context.l10n.save),
            ),
          ),
        ],
      ),
    ),
  );

  void _save() {
    final value = controller.text.trim();
    if (value.isNotEmpty &&
        !RegExp(
          r'^[0-9]+-[a-zA-Z0-9_-]+\.apps\.googleusercontent\.com$',
        ).hasMatch(value)) {
      setState(() => error = context.l10n.invalidGoogleWebClientId);
      return;
    }
    setState(() => error = null);
    widget.onChanged(widget.settings.copyWith(googleWebClientId: value));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.googleOAuthSaved)));
  }
}
