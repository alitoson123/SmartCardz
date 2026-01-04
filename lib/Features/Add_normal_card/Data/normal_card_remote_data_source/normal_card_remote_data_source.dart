abstract class NormalCardRemoteDataSource {
  Future<void> addNormalCard({
    required String cardId,
    required String frontSide,
    required String backSide,
    required String frontImageUrl,
    required String backImageUrl,
    required String frontImagePath,
    required String backImagePath,  
    required String collectionId,
  });
}
