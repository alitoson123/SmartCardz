import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_cards/core/utils/app_dimensions.dart';

abstract class AppConstant {
  static const kFontFamily = 'Poppins';
  static const kDurationSplash = 2;

  static void precacheAppImages(BuildContext context) {
    final List<AssetImage> imagesToPrecache = [];

    for (final image in imagesToPrecache) {
      precacheImage(image, context);
    }
  }

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

  // static int calculateAge(String dateOfBirth) {
  //   try {
  //     final dob = DateFormat('dd/MM/yyyy').parse(dateOfBirth);
  //     final today = DateTime.now();
  //     int age = today.year - dob.year;
  //     if (today.month < dob.month ||
  //         (today.month == dob.month && today.day < dob.day)) {
  //       age--;
  //     }
  //     return age;
  //   } catch (e) {
  //     return 0;
  //   }
  // }
}
