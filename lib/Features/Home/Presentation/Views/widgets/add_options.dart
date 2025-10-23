import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:smart_cards/core/Functions/scaff_message.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';
import 'package:smart_cards/core/utils/routes.dart';

class AddOptions extends StatelessWidget {
  const AddOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Colors.blueAccent,
      spacing: 10,
      spaceBetweenChildren: 8,
      elevation: 6,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.auto_awesome, color: Colors.white),
          backgroundColor: Colors.blueAccent,
          label: 'Add Card with AI',
          labelStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          labelBackgroundColor: Colors.blueAccent.withOpacity(0.9),
          onTap: () {
            context.push(AppRoutes.addAndShowCardScreen);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.add_box, color: Colors.white),
          backgroundColor: Colors.blueAccent,
          label: 'Add Card',
          labelStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          labelBackgroundColor: Colors.blueAccent.withOpacity(0.9),
          onTap: () {
            context.push(AppRoutes.addNormalCardScreen);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.folder_copy, color: Colors.white),
          backgroundColor: Colors.blueAccent,
          label: 'Create New Collection',
          labelStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          labelBackgroundColor: Colors.blueAccent.withOpacity(0.9),
          onTap: () async {
            final appServices = AppServices(dio: Dio());
            try {
              await appServices.createNewCollection(collectionName: 'German');
              showScaffMessage(context, 'Collection created successfully');
            } catch (e) {
              showScaffMessage(context, e.toString(), color: Colors.redAccent);
            }
          },
        ),
      ],
    );
  }
}
