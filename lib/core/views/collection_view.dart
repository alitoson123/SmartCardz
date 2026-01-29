import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_states.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/generated/l10n.dart';

class CollectionView extends StatefulWidget {
  const CollectionView({super.key});

  @override
  State<CollectionView> createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  final TextEditingController searchController = TextEditingController();
  List<CollectionEntity> _allCollections = [];
  List<CollectionEntity> _filteredCollections = [];

  @override
  void initState() {
    super.initState();
    context.read<GetCollectionsCubit>().getCollections();
  }

  void _filterCollections(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCollections = _allCollections;
      } else {
        _filteredCollections = _allCollections.where((collection) {
          final name = collection.collectionName.toLowerCase();
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
        title: Text(S.of(context).searchCollectionTitle),
      ),
      body: BlocConsumer<GetCollectionsCubit, GetCollectionsStates>(
        listener: (context, state) {
          if (state is GetCollectionsSuccess) {
            setState(() {
              _allCollections = state.collections;
              _filteredCollections = state.collections;
            });
          }
        },
        builder: (context, state) {
          if (state is GetCollectionsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetCollectionsFailure) {
            return Center(child: Text(state.errMessage));
          }

          return Column(
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
                    onChanged: _filterCollections,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  itemCount: _filteredCollections.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final collection = _filteredCollections[index];
                    final name = collection.collectionName;

                    return InkWell(
                      onTap: () {
                        Navigator.pop(context, {
                          'id': collection.collection_id,
                          'name': name,
                        });
                      },
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isDark
                                ? Colors.white10
                                : Colors.grey.shade200,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                name,
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
          );
        },
      ),
    );
  }
}
