import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Repos/quota_repo.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/quota_cubit/quota_states.dart';
import 'package:smart_cards/core/services/purchase_service/purchase_service_logic.dart';

class QuotaCubit extends Cubit<QuotaStates> {
  final QuotaRepo quotaRepo;
  final PurchaseServiceLigic purchaseService;
  StreamSubscription? _customerInfoSubscription;
  String? _lastUserId;

  QuotaCubit({required this.quotaRepo, required this.purchaseService})
    : super(QuotaInitial()) {
    _customerInfoSubscription = purchaseService.customerInfoStream.listen((_) {
      if (_lastUserId != null) {
        fetchQuota(_lastUserId!);
      }
    });
  }

  Future<void> fetchQuota(String userId) async {
    _lastUserId = userId;
    emit(QuotaLoading());
    final result = await quotaRepo.getQuota(userId);
    result.fold(
      (failure) => emit(QuotaFailure(message: failure.errorMessage)),
      (quota) async {
        final isPro = await purchaseService.isProUser();
        emit(QuotaLoadedSuccessfully(quota: quota, isPro: isPro));
      },
    );
  }

  @override
  Future<void> close() {
    _customerInfoSubscription?.cancel();
    return super.close();
  }
}
