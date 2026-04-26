import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/add_option_item.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/create_collection.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:smart_cards/generated/l10n.dart';

class AddOptions extends StatefulWidget {
  const AddOptions({super.key});

  @override
  State<AddOptions> createState() => _AddOptionsState();
}

class _AddOptionsState extends State<AddOptions> {
  bool isExpanded = false;

  void reverseIsExpanded() {
    // reverse the isExpanded value
    setState(() {
      isExpanded = !isExpanded;
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
        // all of the in a column
        if (isExpanded) ...[
          // if isExpanded is true, show the options in the same position
          AddOptionItem(
            label: S.of(context).createNewCollection,
            heroTag: 'collection',
            icon: Icons.folder_copy,
            backgroundColor: theme.colorScheme.secondaryContainer,
            foregroundColor: theme.colorScheme.onSecondaryContainer,
            isRTL: isRTL,
            theme: theme,
            onPressed: () {
              reverseIsExpanded();
              showDialog(
                context: context,
                builder: (context) => const CreateCollectionDialog(),
              );
            },
          ),

          // Option 2: Add Card
          AddOptionItem(
            label: S.of(context).addCardWithAI,
            heroTag: 'ai_card',
            icon: Icons.auto_awesome,
            backgroundColor: theme.colorScheme.primaryContainer,
            foregroundColor: theme.colorScheme.onPrimaryContainer,
            isRTL: isRTL,
            theme: theme,
            onPressed: () {
              reverseIsExpanded();
              context.push(AppRoutes.addAndShowCardScreen);
            },
          ),
          AddOptionItem(
            label: S.of(context).addCard,
            heroTag: 'normal_card',
            icon: Icons.add_box,
            backgroundColor: theme.colorScheme.primaryContainer,
            foregroundColor: theme.colorScheme.onPrimaryContainer,
            isRTL: isRTL,
            theme: theme,
            onPressed: () {
              reverseIsExpanded();
              context.push(AppRoutes.addNormalCardScreen);
            },
          ),
        ],

        FloatingActionButton(
          // the main floating action button
          shape: const CircleBorder(),
          heroTag: 'main_fab',
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          onPressed: reverseIsExpanded,
          child: Icon(isExpanded ? Icons.close : Icons.add),
        ),
      ],
    );
  }
}
