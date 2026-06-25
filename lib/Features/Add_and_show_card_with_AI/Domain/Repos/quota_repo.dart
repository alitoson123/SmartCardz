import 'package:dartz/dartz.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/Models/quota_model.dart';
import 'package:smart_cards/core/errors/failure.dart';

abstract class QuotaRepo {
  /// Initialize or fetch the current quota status for the user.
  /// Also handles daily resets and premium period resets internally.
  Future<Either<Failure, QuotaModel>> getQuota(String userId);

  /// Check if the user can generate the requested number of cards.
  /// Returns the actual number of cards that can be generated.
  /// If it returns a number less than [requestedCount], the caller should 
  /// display a warning and offer to upgrade.
  Future<Either<Failure, int>> canGenerateCards({
    required String userId,
    required int requestedCount,
    required bool withImage,
  });

  /// Deduct the generated cards from the user's quota.
  Future<Either<Failure, void>> deductQuota({
    required String userId,
    required int generatedCount,
    required bool withImage,
  });
}
