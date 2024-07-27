import 'package:dartz/dartz.dart';
import 'package:interval/core/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
