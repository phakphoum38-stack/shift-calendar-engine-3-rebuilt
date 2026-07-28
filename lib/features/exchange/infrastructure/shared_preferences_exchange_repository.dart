import 'dart:convert';

import '../../../core/result/result.dart';
import '../../../core/storage/atomic_string_store.dart';
import '../../../domain/entities/exchange_request.dart';
import '../../../domain/repositories/exchange_repository.dart';
import '../../foundation/infrastructure/canonical_json_codec.dart';

class SharedPreferencesExchangeRepository implements ExchangeRepository {
  SharedPreferencesExchangeRepository({
    AtomicStringStore? store,
    this.codec = const CanonicalJsonCodec(),
  }) : store =
           store ?? AtomicStringStore(namespace: 'sce3.exchange_requests.v1');

  final AtomicStringStore store;
  final CanonicalJsonCodec codec;

  @override
  Future<Result<List<ExchangeRequest>>> findAll() async {
    try {
      final payload = await store.read();
      if (payload == null) return const Success([]);
      final root = jsonDecode(payload);
      if (root is! Map<String, dynamic> || root['requests'] is! List) {
        return const ValidationFailure('Invalid exchange request payload.');
      }
      final values = <ExchangeRequest>[];
      for (final (index, raw) in (root['requests'] as List).indexed) {
        if (raw is! Map) {
          return ValidationFailure('Invalid exchange request at $index.');
        }
        values.add(_decode(Map<String, Object?>.from(raw)));
      }
      values.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Success(List.unmodifiable(values));
    } on Object catch (error, stackTrace) {
      return PersistenceFailure(
        'Could not load exchange requests.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<Result<ExchangeRequest>> save(ExchangeRequest request) async {
    final loaded = await findAll();
    if (loaded case Failure<List<ExchangeRequest>>()) {
      return PersistenceFailure(loaded.message, cause: loaded);
    }
    final values = List<ExchangeRequest>.of(
      (loaded as Success<List<ExchangeRequest>>).value,
    );
    final index = values.indexWhere((value) => value.id == request.id);
    if (index == -1) {
      values.add(request);
    } else {
      values[index] = request;
    }
    try {
      values.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      await store.write(
        jsonEncode({
          'formatVersion': 1,
          'requests': [for (final value in values) _encode(value)],
        }),
      );
      return Success(request);
    } on Object catch (error, stackTrace) {
      return PersistenceFailure(
        'Could not save exchange request.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  Map<String, Object?> _encode(ExchangeRequest value) => {
    'id': value.id,
    'type': value.type.name,
    'sourceAssignmentId': value.sourceAssignmentId,
    'sourceDate': value.sourceDate.toIso8601String(),
    'requester': codec.encodeEmployee(value.requester),
    'recipient': codec.encodeEmployee(value.recipient),
    'reason': value.reason,
    'status': value.status.name,
    'createdAt': value.createdAt.toIso8601String(),
    'offeredAssignmentId': value.offeredAssignmentId,
    'offeredDate': value.offeredDate?.toIso8601String(),
    'respondedAt': value.respondedAt?.toIso8601String(),
    'approvedAt': value.approvedAt?.toIso8601String(),
    'approverName': value.approverName,
    'rejectionReason': value.rejectionReason,
  };

  ExchangeRequest _decode(Map<String, Object?> value) {
    final type = ExchangeType.values.byName(value['type']! as String);
    final status = ExchangeStatus.values.byName(value['status']! as String);
    return ExchangeRequest(
      id: value['id']! as String,
      type: type,
      sourceAssignmentId: value['sourceAssignmentId']! as String,
      sourceDate: DateTime.parse(value['sourceDate']! as String),
      requester: codec.decodeEmployee(
        Map<String, Object?>.from(value['requester']! as Map),
        'request.requester',
      ),
      recipient: codec.decodeEmployee(
        Map<String, Object?>.from(value['recipient']! as Map),
        'request.recipient',
      ),
      reason: value['reason']! as String,
      status: status,
      createdAt: DateTime.parse(value['createdAt']! as String),
      offeredAssignmentId: value['offeredAssignmentId'] as String?,
      offeredDate: _optionalDate(value['offeredDate']),
      respondedAt: _optionalDate(value['respondedAt']),
      approvedAt: _optionalDate(value['approvedAt']),
      approverName: value['approverName'] as String?,
      rejectionReason: value['rejectionReason'] as String?,
    );
  }

  DateTime? _optionalDate(Object? value) =>
      value is String ? DateTime.parse(value) : null;
}
