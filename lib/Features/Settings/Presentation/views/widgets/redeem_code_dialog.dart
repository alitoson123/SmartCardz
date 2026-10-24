import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/services/promo_code_service/promo_code_service.dart';
import 'package:smart_cards/core/view_model/app_purchase_cubit/app_purchase_cubit.dart';
import 'package:smart_cards/generated/l10n.dart';

class RedeemCodeDialog extends StatefulWidget {
  const RedeemCodeDialog({super.key});

  @override
  State<RedeemCodeDialog> createState() => _RedeemCodeDialogState();
}

class _RedeemCodeDialogState extends State<RedeemCodeDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRedeem() async {
    final code = _controller.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await PromoCodeService.instance.redeemCode(code);

    if (!mounted) return;

    if (result.success) {
      context.read<SubscriptionCubit>().checkStatus();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).codeRedeemedSuccessfully),
          backgroundColor: Colors.green.shade700,
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = _resolveErrorMessage(result.errorMessageKey);
      });
    }
  }

  String _resolveErrorMessage(String? key) {
    final s = S.of(context);
    switch (key) {
      case 'codeAlreadyUsed':
        return s.codeAlreadyUsed;
      case 'codeExpired':
        return s.codeExpired;
      case 'mustBeLoggedInToRedeem':
        return s.mustBeLoggedInToRedeem;
      default:
        return s.invalidCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      actionsPadding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      title: Text(
        s.haveAnActivationCode,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.enterActivationCode,
            style: TextStyle(fontSize: 13.sp, color: Colors.grey),
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.characters,
            autofocus: true,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: s.codeHint,
              filled: true,
              fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          if (_errorMessage != null) ...[
            SizedBox(height: 8.h),
            Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red.shade400, fontSize: 12.sp),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(s.cancel, style: const TextStyle(color: Colors.grey)),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _handleRedeem,
          style: FilledButton.styleFrom(
            backgroundColor: AppConstants.K_PRIMARY_COLOR,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: _isLoading
              ? SizedBox(
                  width: 16.w,
                  height: 16.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(s.save),
        ),
      ],
    );
  }
}
