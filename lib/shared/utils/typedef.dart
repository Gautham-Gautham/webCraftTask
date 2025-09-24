import 'package:app/shared/utils/failure.dart';
import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef Futurevoid = FutureEither<void>;
