import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_cards/core/utils/widgets/app_dimensions.dart';

abstract class AppShowDialog {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
  buildShowSnackBar(
    BuildContext context,
    String message, [
    ContentType type = ContentType.failure,
    String title = 'Oops',
  ]) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          //  messageTextStyle: Styling.textStyle10.copyWith(fontSize: 15),
          contentType: type,
        ),
      ),
    );
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: AppDimensions.r140),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.r15),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.r12),
            child: SizedBox(
              width: AppDimensions.r60,
              height: AppDimensions.r60,
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? const Center(child: CupertinoActivityIndicator())
                  : const Center(
                      child: CircularProgressIndicator(
                        //   color: AppColor.kPrimaryPink,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
