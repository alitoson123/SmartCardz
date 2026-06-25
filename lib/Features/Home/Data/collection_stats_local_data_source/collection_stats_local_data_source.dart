import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_cards/Features/Home/Data/Models/collection_stats_model.dart';
import 'package:smart_cards/constant.dart';

abstract class CollectionStatsLocalDataSource {
  Future<void> cacheStats({
    required String collectionId,
    required CollectionStatsModel stats,
  });

  Future<CollectionStatsModel?> getCachedStats({required String collectionId});

  Future<void> cacheMultipleStats({
    required Map<String, CollectionStatsModel> mapOfStats,
  });
}

class CollectionStatsLocalDataSourceImpl
    implements CollectionStatsLocalDataSource {
  const CollectionStatsLocalDataSourceImpl();
  // cache stats
  @override
  Future<void> cacheStats({
    required String collectionId,
    required CollectionStatsModel stats,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(stats.toJson());
    await prefs.setString('${AppConstants.K_Stats_Prefix}$collectionId', jsonString);
    // Object → toJson() → Map → jsonEncode → String → SharedPreferences
  }

  // get cached stats
  @override
  Future<CollectionStatsModel?> getCachedStats({
    required String collectionId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('${AppConstants.K_Stats_Prefix}$collectionId');

    // If no data is cached yet, return null. The Repo will handle this.
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return CollectionStatsModel.fromJson(jsonMap);
    // String → jsonDecode → Map → fromJson() → Object
  }

  // cache multiple stats
  @override
  Future<void> cacheMultipleStats({
    required Map<String, CollectionStatsModel> mapOfStats,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Loop through the map and save each one.
    for (final entry in mapOfStats.entries) {
      final collectionId = entry.key;
      final statsModel = entry.value;

      final jsonString = jsonEncode(statsModel.toJson());
      await prefs.setString('${AppConstants.K_Stats_Prefix}$collectionId', jsonString);
    }
  }
}
