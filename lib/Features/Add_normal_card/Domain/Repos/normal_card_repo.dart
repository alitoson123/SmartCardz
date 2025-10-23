import 'package:dartz/dartz.dart';
import 'package:smart_cards/core/errors/failure.dart';

abstract class NormalCardRepo {
  Future<Either<Failure, void>> addNormalCard({
    required String frontSide,
    required String backSide,
    required String collectionName
  });
}
