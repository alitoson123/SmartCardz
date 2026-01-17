import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/generated/l10n.dart';

class TypeOfCollections extends StatefulWidget {
  const TypeOfCollections({super.key});

  @override
  State<TypeOfCollections> createState() => _TypeOfCollectionsState();
}

class _TypeOfCollectionsState extends State<TypeOfCollections> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> _allTypes = [
    {'id': '1', 'name': 'Basic'},
    {'id': '2', 'name': 'front'},
  ];

  List<Map<String, String>> _filteredTypes = [];

  @override
  void initState() {
    super.initState();
    _filteredTypes = _allTypes;
  }

  void _filterTypes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTypes = _allTypes;
      } else {
        _filteredTypes = _allTypes.where((type) {
          final name = type['name']!.toLowerCase();
          final search = query.toLowerCase();
          return name.contains(search);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Determine colors based on theme
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black87;
    final hintColor = theme.hintColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          // Using a more appropriate title if available, or defaulting to something generic
          // The original used S.of(context).searchCollectionTitle which might be "Search Collection"
          // I will stick to S.of(context).searchCollectionTitle to be safe as per original
          S.of(context).searchCollectionTitle,
          style:
              theme.appBarTheme.titleTextStyle ??
              TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
        ),
        leading: BackButton(color: textColor),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: isDark
                    ? [] // No shadow in dark mode for cleaner look
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(.5),
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                border: isDark ? Border.all(color: Colors.white10) : null,
              ),
              child: TextField(
                controller: searchController,
                onChanged: _filterTypes,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: hintColor),
                  hintText: S.of(context).searchCollectionHint,
                  hintStyle: TextStyle(color: hintColor, fontSize: 14.sp),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: _filteredTypes.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final type = _filteredTypes[index];
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, {
                      'id': type['id'],
                      'name': type['name'],
                    });
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Row(
                      children: [
                        // Avatar removed as per user preference in previous task
                        Expanded(
                          child: Text(
                            type['name']!,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16.sp,
                          color: hintColor,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.h, top: 8.h),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                S.of(context).cancel,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
