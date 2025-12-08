import 'package:flutter/material.dart';
import 'package:smart_cards/generated/l10n.dart';

class TypeOfCollections extends StatelessWidget {
  const TypeOfCollections({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).searchCollectionTitle),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
       
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Basic'),
                  onTap: () {
                    Navigator.pop(context, {'id': '1', 'name': 'Basic'});
                  },
                ),
                ListTile(
                  title: Text('front'),
                  onTap: () {
                    Navigator.pop(context, {'id': '2', 'name': 'front'});
                  },
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).cancel),
          ),
        ],
      ),
    );
  }
}
