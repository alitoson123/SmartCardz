import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/create_collection.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:smart_cards/core/services/notifications_service/back_ground_service.dart';
import 'package:smart_cards/generated/l10n.dart';

class AddOptions extends StatelessWidget {
  const AddOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      spacing: 10,
      spaceBetweenChildren: 8,
      elevation: 6,

      //   direction: SpeedDialDirection.up,
      children: [
        SpeedDialChild(
          backgroundColor: theme.colorScheme.primaryContainer,
          foregroundColor: theme.colorScheme.onPrimaryContainer,
          child: const Icon(Icons.auto_awesome),
          label: S.of(context).addCardWithAI,
          labelStyle: theme.textTheme.bodyMedium,
          onTap: () async {
            final svc = BackGroundService();
            await svc.initLocalNotifications();
            await svc.backgroundWork();
            print("TEST DONE");
            context.push(AppRoutes.addAndShowCardScreen);
          },
        ),
        SpeedDialChild(
          backgroundColor: theme.colorScheme.primaryContainer,
          foregroundColor: theme.colorScheme.onPrimaryContainer,
          child: const Icon(Icons.add_box),
          label: S.of(context).addCard,
          labelStyle: theme.textTheme.bodyMedium,
          onTap: () async {
            /*   final sender = FcmSender(
              'assets/smart-cards-c1327-firebase-adminsdk-fbsvc-6057146e98.json',
              'smart-cards-c1327',
            );
            await sender.init();

            bool success = await sender.sendNotification(
              deviceToken:
                  'fUA-Q3M0ReSMPv4wC7zWmL:APA91bGHXF3SaNNv0T2gID4e-g3VQeKxHpwfkWHgzz0Uz-zEnLljDB59eunqNM7B9i7SOkOum6gzKhqtdzKbOtUgGJJY7P2AdeBjntdqruKbfIKIsZ4cKEE', // جهاز المستخدم
              title: 'مرحبا!',
              body: 'ده إشعار تجريبي',
              data: {'type': 'home'},
            );

            sender.close();*/
          /*  try {
              await AppServices.syncAllCollectionCardCounts();

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ All card counts synced successfully!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );
            } catch (e) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('❌ Sync failed: $e'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            }
*/
            context.push(AppRoutes.addNormalCardScreen);
          },
        ),
        SpeedDialChild(
          backgroundColor: theme.colorScheme.secondaryContainer,
          foregroundColor: theme.colorScheme.onSecondaryContainer,
          child: const Icon(Icons.folder_copy),
          label: S.of(context).createNewCollection,
          labelStyle: theme.textTheme.bodyMedium,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const CreateCollectionDialog(),
            );
          },
        ),
      ],
    );
  }
}
