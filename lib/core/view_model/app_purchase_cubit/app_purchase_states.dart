import 'package:purchases_flutter/purchases_flutter.dart';

abstract class SubscriptionState {}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionSuccess extends SubscriptionState {
  final bool isPro;
  final CustomerInfo? customerInfo;
  SubscriptionSuccess({required this.isPro, this.customerInfo});
}

class SubscriptionError extends SubscriptionState {
  final String message;
  SubscriptionError(this.message);
}
