import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:smart_cards/core/services/purchase_service/purchase_service_logic.dart';
import 'package:smart_cards/core/view_model/app_purchase_cubit/app_purchase_states.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(SubscriptionInitial()) {
    _listenToUpdates();
    checkStatus();
  }

  final _service = PurchaseServiceLigic.instance;

  // Register the RevenueCat listener once
  void _listenToUpdates() {
    Purchases.addCustomerInfoUpdateListener((CustomerInfo info) {
      final isPro = _service.isProUserFromInfo(info);
      emit(SubscriptionSuccess(isPro: isPro, customerInfo: info));
    });
  }

  Future<void> checkStatus() async {
    emit(SubscriptionLoading());
    final info = await _service.getCustomerInfo();
    if (info == null) {
      emit(SubscriptionError('Could not load subscription status.'));
      return;
    }
    final isPro = _service.isProUserFromInfo(info);
    emit(SubscriptionSuccess(isPro: isPro, customerInfo: info));
  }
}
