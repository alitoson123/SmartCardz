import 'package:smart_cards/Features/Home/Domain/Entities/collection_stats_entity.dart';

abstract class CollectionsStatsState {}

class CollectionsStatsInitial extends CollectionsStatsState {}

class CollectionsStatsLoading extends CollectionsStatsState {}

class CollectionsStatsSuccess extends CollectionsStatsState {
  /// A Map where the key is the `collectionId` and the value
  /// is the underlying `CollectionStatsEntity` (total and due count).
  final Map<String, CollectionStatsEntity> statsMap;

  CollectionsStatsSuccess({required this.statsMap});
}

class CollectionsStatsFailure extends CollectionsStatsState {
  final String errorMessage;

  CollectionsStatsFailure({required this.errorMessage});
}
