import 'package:crypto_flow/core/error/failures.dart';
import 'package:crypto_flow/core/result/result.dart';

abstract class UseCase<T, Params> {
  Future<Result<T, AppFailure>> call(Params params);
}

class NoParams {
  const NoParams();
}
