import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/Models/quota_model.dart';

abstract class QuotaStates {}

class QuotaInitial extends QuotaStates {}

class QuotaLoading extends QuotaStates {}

class QuotaLoadedSuccessfully extends QuotaStates {
  final QuotaModel quota;
  final bool isPro;

  QuotaLoadedSuccessfully({required this.quota, required this.isPro});
}

class QuotaFailure extends QuotaStates {
  final String message;
  QuotaFailure({required this.message});
}
