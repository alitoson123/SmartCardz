import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/add_and_show_card_view_body.dart';
import 'package:smart_cards/generated/l10n.dart';

class AddAndShowCardView extends StatelessWidget {
  const AddAndShowCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).addNewCardWithAITitle)),
      body: AddAndShowCardViewBody(),
    );
  }
}
