import '../../core/result/result.dart';
import '../entities/exchange_request.dart';

abstract interface class ExchangeRepository {
  Future<Result<List<ExchangeRequest>>> findAll();

  Future<Result<ExchangeRequest>> save(ExchangeRequest request);
}
