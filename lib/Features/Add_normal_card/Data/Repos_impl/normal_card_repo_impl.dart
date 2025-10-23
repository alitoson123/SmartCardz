import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_cards/Features/Add_normal_card/Data/normal_card_remote_data_source/normal_card_remote_data_source_impl.dart';
import 'package:smart_cards/Features/Add_normal_card/Domain/Repos/normal_card_repo.dart';
import 'package:smart_cards/core/errors/failure.dart';

class NormalCardRepoImpl extends NormalCardRepo {
  final NormalCardRemoteDataSourceImpl normalCardRemoteDataSourceImpl;

  NormalCardRepoImpl({required this.normalCardRemoteDataSourceImpl});
  @override
  Future<Either<Failure, void>> addNormalCard({
    required String frontSide,
    required String backSide,
    required String collectionName
  }) async {
    try {
      await normalCardRemoteDataSourceImpl.addNormalCard(
        frontSide: frontSide,
        backSide: backSide,
        collectionName: collectionName
      );
      return right(null);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }
}
