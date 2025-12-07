import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/create_collection.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:smart_cards/core/services/notifications_service/back_ground_service.dart';
import 'package:smart_cards/generated/l10n.dart';

class AddOptions extends StatefulWidget {
  const AddOptions({super.key});

  @override
  State<AddOptions> createState() => _AddOptionsState();
}

class _AddOptionsState extends State<AddOptions> {
  bool _isExpanded = false;

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Option 1: Add Card with AI
        if (_isExpanded) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Label on right for RTL
                if (isRTL)
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      S.of(context).addCardWithAI,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                // Button
                FloatingActionButton(
                  heroTag: 'ai_card',
                  mini: true,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                  onPressed: () async {
                    _toggle();
                    final svc = BackGroundService();
                    await svc.initLocalNotifications();
                    await svc.backgroundWork();
                    print("TEST DONE");
                    context.push(AppRoutes.addAndShowCardScreen);
                  },
                  child: const Icon(Icons.auto_awesome),
                ),
                // Label on left for LTR
                if (!isRTL)
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      S.of(context).addCardWithAI,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
              ],
            ),
          ),

          // Option 2: Add Card
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isRTL)
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      S.of(context).addCard,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                FloatingActionButton(
                  heroTag: 'normal_card',
                  mini: true,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                  onPressed: () async {
                    _toggle();
                    context.push(AppRoutes.addNormalCardScreen);
                  },
                  child: const Icon(Icons.add_box),
                ),
                if (!isRTL)
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      S.of(context).addCard,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
              ],
            ),
          ),

          // Option 3: Create New Collection
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isRTL)
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      S.of(context).createNewCollection,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                FloatingActionButton(
                  heroTag: 'collection',
                  mini: true,
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  foregroundColor: theme.colorScheme.onSecondaryContainer,
                  onPressed: () {
                    _toggle();
                    showDialog(
                      context: context,
                      builder: (context) => const CreateCollectionDialog(),
                    );
                  },
                  child: const Icon(Icons.folder_copy),
                ),
                if (!isRTL)
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      S.of(context).createNewCollection,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
              ],
            ),
          ),
        ],

        // Main FAB
        FloatingActionButton(
          heroTag: 'main_fab',
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          onPressed: _toggle,
          child: Icon(_isExpanded ? Icons.close : Icons.add),
        ),
      ],
    );
  }
}
