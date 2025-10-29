abstract class NormalCardRemoteDataSource {
  Future<void> addNormalCard({
    required String frontSide,
    required String backSide,
    required String collectionId
  });
}
