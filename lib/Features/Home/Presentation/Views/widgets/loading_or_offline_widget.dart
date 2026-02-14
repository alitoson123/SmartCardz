import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/core/utils/helpers/network_utils.dart';
import 'package:smart_cards/generated/l10n.dart';

class LoadingOrOfflineWidget extends StatelessWidget {
  const LoadingOrOfflineWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: NetworkUtils.isOnline(),
      builder: (context, onlineSnapshot) {
        if (onlineSnapshot.connectionState == ConnectionState.done &&
            onlineSnapshot.data == false) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, size: 64.sp, color: Colors.grey),
                SizedBox(height: 16.h),
                Text(
                  S.of(context).NoInternetConnection,
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
