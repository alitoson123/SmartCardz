import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/widgets/type_of_collection_item.dart';
import 'package:smart_cards/core/views/widgets/cancel_widget.dart';
import 'package:smart_cards/core/views/widgets/selection_search_field.dart';
import 'package:smart_cards/generated/l10n.dart';

class TypeOfCollections extends StatefulWidget {
  const TypeOfCollections({super.key});

  @override
  State<TypeOfCollections> createState() => _TypeOfCollectionsState();
}

class _TypeOfCollectionsState extends State<TypeOfCollections> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> allTypes = [
    // all of the types of collections
    {'id': '1', 'name': S.current.basic},
    {'id': '2', 'name': S.current.frontOnly},
  ];

  List<Map<String, String>> filteredTypes = []; // filtered types of collections

  @override
  void initState() {
    super.initState();
    filteredTypes = allTypes;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(S.of(context).typeOfCollection),
      ),
      body: Column(
        children: [
          // search section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: SelectionSearchField(
              searchController: searchController,
              onChanged: filterTypes,
            ),
          ),
          // types of collections  list section
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: filteredTypes.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final type = filteredTypes[index];
                return TypeOfCollectionItem(type: type);
              },
            ),
          ),
          // cancel button
          const CancelWidget(),
        ],
      ),
    );
  }

  // filter types of collections (Search Function)
  void filterTypes(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTypes = allTypes;
      } else {
        filteredTypes = allTypes.where((type) {
          final name = type['name']!.toLowerCase();
          final search = query.toLowerCase();
          return name.contains(search);
        }).toList();
      }
    });
  }
}
