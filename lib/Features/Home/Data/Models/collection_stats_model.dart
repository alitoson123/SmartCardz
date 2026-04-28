import 'package:smart_cards/Features/Home/Domain/Entities/collection_stats_entity.dart';

class CollectionStatsModel extends CollectionStatsEntity {
  const CollectionStatsModel({
    required super.totalCards,
    required super.dueCards,
  });

  /// Factory constructor to create a [CollectionStatsModel] from a JSON map.
  /// Useful when retrieving cached data from local storage.
  factory CollectionStatsModel.fromJson(Map<String, dynamic> json) {
    return CollectionStatsModel(
      totalCards: json['total'] ?? 0,
      dueCards: json['due'] ?? 0,
    );
  }

  /// Converts the model back into a JSON map.
  /// Useful when saving the data into local storage (like SharedPreferences).
  Map<String, dynamic> toJson() {
    return {'total': totalCards, 'due': dueCards};
  }
}
