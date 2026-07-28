import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/employee.dart';
import '../../../domain/entities/exchange_request.dart';
import '../../../domain/entities/schedule.dart';
import '../../../domain/entities/shift_assignment.dart';
import '../../../l10n/l10n.dart';
import '../application/exchange_controller.dart';
import '../domain/exchange_conflict.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({
    required this.schedule,
    required this.controllerFactory,
    required this.onScheduleSaved,
    super.key,
  });

  final Schedule schedule;
  final ExchangeController Function(Schedule schedule) controllerFactory;
  final ValueChanged<Schedule> onScheduleSaved;

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  late final ExchangeController controller = widget.controllerFactory(
    widget.schedule,
  );

  @override
  void initState() {
    super.initState();
    unawaited(controller.load());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.exchangeRequests,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(context.l10n.exchangeDescription),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: controller.loading ? null : _create,
                    icon: const Icon(Icons.add),
                    label: Text(context.l10n.newExchangeRequest),
                  ),
                ],
              ),
              if (controller.loading) ...[
                const SizedBox(height: 16),
                const LinearProgressIndicator(),
              ],
              if (controller.error != null) ...[
                const SizedBox(height: 16),
                MaterialBanner(
                  content: Text(controller.error!),
                  actions: [
                    TextButton(
                      onPressed: controller.load,
                      child: Text(context.l10n.retry),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              if (controller.requests.isEmpty && !controller.loading)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        const Icon(Icons.swap_horiz_outlined, size: 52),
                        const SizedBox(height: 12),
                        Text(context.l10n.noRequests),
                      ],
                    ),
                  ),
                )
              else
                for (final request in controller.requests) ...[
                  _RequestCard(
                    request: request,
                    onAccept: () => _run(() => controller.accept(request.id)),
                    onApprove: () => _previewAndApprove(request),
                    onReject: () => _reject(request),
                    onCancel: () => _run(() => controller.cancel(request.id)),
                  ),
                  const SizedBox(height: 12),
                ],
            ],
          ),
        ),
      ),
    ),
  );

  Future<void> _create() async {
    final draft = await showDialog<_ExchangeDraft>(
      context: context,
      builder: (context) => _ExchangeDialog(
        schedule: controller.schedule,
        employees: controller.employees,
      ),
    );
    if (draft == null) return;
    await _run(
      () => controller.create(
        type: draft.type,
        sourceDate: draft.source.date,
        source: draft.source.assignment,
        recipient: draft.recipient,
        reason: draft.reason,
        offeredDate: draft.offered?.date,
        offered: draft.offered?.assignment,
      ),
    );
  }

  Future<void> _previewAndApprove(ExchangeRequest request) async {
    final conflicts = controller.preview(request);
    final blocked = conflicts.any((value) => value.blocksApproval);
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.exchangePreview),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${request.requester.displayName} → '
                '${request.recipient.displayName}',
              ),
              const SizedBox(height: 12),
              if (conflicts.isEmpty)
                Text(context.l10n.noExchangeConflicts)
              else
                for (final conflict in conflicts)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      conflict.severity == ExchangeConflictSeverity.error
                          ? Icons.error_outline
                          : Icons.warning_amber_outlined,
                      color: conflict.severity == ExchangeConflictSeverity.error
                          ? Theme.of(context).colorScheme.error
                          : Colors.orange,
                    ),
                    title: Text(conflict.message),
                  ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: blocked ? null : () => Navigator.pop(context, true),
            child: Text(context.l10n.approveExchange),
          ),
        ],
      ),
    );
    if (approved == true) {
      await _run(() => controller.approve(request.id, 'Administrator'));
    }
  }

  Future<void> _reject(ExchangeRequest request) async {
    final reason = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.rejectExchange),
        content: TextField(
          controller: reason,
          decoration: InputDecoration(labelText: context.l10n.reason),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.rejectExchange),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _run(() => controller.reject(request.id, reason.text));
    }
    reason.dispose();
  }

  Future<void> _run(Future<bool> Function() action) async {
    final success = await action();
    if (!mounted) return;
    if (success) {
      widget.onScheduleSaved(controller.schedule);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.exchangeSaved)));
    }
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.onAccept,
    required this.onApprove,
    required this.onReject,
    required this.onCancel,
  });

  final ExchangeRequest request;
  final VoidCallback onAccept;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final canRespond = request.status == ExchangeStatus.submitted;
    final canApprove = request.status == ExchangeStatus.accepted;
    final canCancel = canRespond || canApprove;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Chip(
                  label: Text(
                    request.type == ExchangeType.swap
                        ? context.l10n.swapShift
                        : context.l10n.coverShift,
                  ),
                ),
                Chip(label: Text(_status(context, request.status))),
                Text(DateFormat.yMMMd().format(request.sourceDate)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${request.requester.displayName} → '
              '${request.recipient.displayName}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text('${context.l10n.reason}: ${request.reason}'),
            if (request.rejectionReason?.isNotEmpty == true)
              Text(
                '${context.l10n.rejectionReason}: '
                '${request.rejectionReason}',
              ),
            if (canRespond || canApprove || canCancel) ...[
              const Divider(height: 24),
              Wrap(
                spacing: 8,
                children: [
                  if (canRespond)
                    FilledButton.tonal(
                      onPressed: onAccept,
                      child: Text(context.l10n.acceptExchange),
                    ),
                  if (canApprove)
                    FilledButton(
                      onPressed: onApprove,
                      child: Text(context.l10n.previewAndApprove),
                    ),
                  if (canRespond || canApprove)
                    OutlinedButton(
                      onPressed: onReject,
                      child: Text(context.l10n.rejectExchange),
                    ),
                  if (canCancel)
                    TextButton(
                      onPressed: onCancel,
                      child: Text(context.l10n.cancelRequest),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _status(BuildContext context, ExchangeStatus status) =>
      switch (status) {
        ExchangeStatus.submitted => context.l10n.waitingForAcceptance,
        ExchangeStatus.accepted => context.l10n.waitingForApproval,
        ExchangeStatus.approved => context.l10n.approvedExchange,
        ExchangeStatus.rejected => context.l10n.rejectedExchange,
        ExchangeStatus.cancelled => context.l10n.cancelledExchange,
      };
}

class _ExchangeDialog extends StatefulWidget {
  const _ExchangeDialog({required this.schedule, required this.employees});

  final Schedule schedule;
  final List<Employee> employees;

  @override
  State<_ExchangeDialog> createState() => _ExchangeDialogState();
}

class _ExchangeDialogState extends State<_ExchangeDialog> {
  late final List<_DatedAssignment> assignments = [
    for (final day in widget.schedule.days)
      for (final assignment in day.assignments)
        _DatedAssignment(day.date, assignment),
  ];
  ExchangeType type = ExchangeType.cover;
  _DatedAssignment? source;
  Employee? recipient;
  _DatedAssignment? offered;
  final reason = TextEditingController();

  @override
  void dispose() {
    reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipients = widget.employees
        .where((value) => value.id != source?.assignment.employee.id)
        .toList();
    final offeredValues = assignments
        .where((value) => value.assignment.employee.id == recipient?.id)
        .toList();
    return AlertDialog(
      title: Text(context.l10n.newExchangeRequest),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<ExchangeType>(
                segments: [
                  ButtonSegment(
                    value: ExchangeType.cover,
                    label: Text(context.l10n.coverShift),
                  ),
                  ButtonSegment(
                    value: ExchangeType.swap,
                    label: Text(context.l10n.swapShift),
                  ),
                ],
                selected: {type},
                onSelectionChanged: (value) =>
                    setState(() => type = value.single),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<_DatedAssignment>(
                initialValue: source,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: context.l10n.originalShift,
                ),
                items: [
                  for (final value in assignments)
                    DropdownMenuItem(value: value, child: Text(value.label)),
                ],
                onChanged: (value) => setState(() {
                  source = value;
                  recipient = null;
                  offered = null;
                }),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Employee>(
                initialValue: recipient,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: context.l10n.receivingEmployee,
                ),
                items: [
                  for (final value in recipients)
                    DropdownMenuItem(
                      value: value,
                      child: Text(value.displayName),
                    ),
                ],
                onChanged: (value) => setState(() {
                  recipient = value;
                  offered = null;
                }),
              ),
              if (type == ExchangeType.swap) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<_DatedAssignment>(
                  initialValue: offered,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.offeredShift,
                  ),
                  items: [
                    for (final value in offeredValues)
                      DropdownMenuItem(value: value, child: Text(value.label)),
                  ],
                  onChanged: (value) => setState(() => offered = value),
                ),
              ],
              const SizedBox(height: 12),
              TextField(
                controller: reason,
                decoration: InputDecoration(labelText: context.l10n.reason),
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed:
              source == null ||
                  recipient == null ||
                  reason.text.trim().isEmpty ||
                  (type == ExchangeType.swap && offered == null)
              ? null
              : () => Navigator.pop(
                  context,
                  _ExchangeDraft(
                    type: type,
                    source: source!,
                    recipient: recipient!,
                    reason: reason.text.trim(),
                    offered: offered,
                  ),
                ),
          child: Text(context.l10n.submitRequest),
        ),
      ],
    );
  }
}

class _ExchangeDraft {
  const _ExchangeDraft({
    required this.type,
    required this.source,
    required this.recipient,
    required this.reason,
    this.offered,
  });

  final ExchangeType type;
  final _DatedAssignment source;
  final Employee recipient;
  final String reason;
  final _DatedAssignment? offered;
}

class _DatedAssignment {
  const _DatedAssignment(this.date, this.assignment);

  final DateTime date;
  final ShiftAssignment assignment;

  String get label =>
      '${DateFormat.yMd().format(date)} • '
      '${assignment.employee.displayName} • ${assignment.shift.code}';
}
