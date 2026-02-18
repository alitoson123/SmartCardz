import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Home/Data/Repo_impl/collection_repo_impl.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/add_collection_cubit1.dart/add_collection_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/core/services/locator_service/service_locator.dart';
import 'package:smart_cards/core/services/Bloc_observes_service/my_Bloc_observe.dart';
import 'package:smart_cards/core/utils/app_theme/dark_theme.dart';
import 'package:smart_cards/core/utils/app_theme/light_theme.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_cards/core/view_model/app_init_cubit/app_init_cubit.dart';
import 'package:smart_cards/core/view_model/app_language_cubit/app_language_cubit.dart';
import 'package:smart_cards/core/view_model/app_language_cubit/app_language_states.dart';
import 'package:smart_cards/core/view_model/app_theme_cubit/app_theme_cubit.dart';
import 'package:smart_cards/core/view_model/app_theme_cubit/app_theme_states.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Bloc.observer = MyBlocObserver(); // bloc observer
 // await _runMigration();

  runApp(const SmartCards());
}

Future<void> _runMigration() async {
  final migration = CardMigration();
  
  // ✅ تشغيل التحويل لكل الكروت
  await migration.migrateAllCards();
  
  // ✅ لو عايز تحول collection معين بس:
  // await migration.migrateCollection('your_collection_id');
}

class SmartCards extends StatelessWidget {
  const SmartCards({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 800),
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AppInitCubit()),
            BlocProvider(create: (context) => ThemeCubit()),
            BlocProvider(create: (context) => AppLanguageCubit()),
            BlocProvider(
              create: (context) => AddCollectionCubit(
                addCollectionRepo: getIt<CollectionRepoImpl>(),
              ),
            ),
            BlocProvider(
              create: (context) => GetCollectionsCubit(
                collectionRepoImpl: getIt<CollectionRepoImpl>(),
              ),
            ),
          ],
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return BlocBuilder<AppLanguageCubit, AppLanguageState>(
                builder: (context, languageState) {
                  return MaterialApp.router(
                    locale: Locale(languageState.appLanguage),
                    localizationsDelegates: [
                      S.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: S.delegate.supportedLocales,
                    routerConfig: AppRoutes.route,
                    debugShowCheckedModeBanner: false,
                    themeMode: themeState.themeMode,
                    theme: lightTheme,
                    darkTheme: darkTheme,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

// 📁 lib/migration/migrate_old_cards.dart


class CardMigration {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// تشغل المرة الواحدة لتحديث كل الكروت القديمة
  Future<void> migrateAllCards() async {
    print('🚀 بدء تحويل الكروت...');

    try {
      // جيب كل الكروت
      final snapshot = await _firestore.collection('cards').get();
      
      int aiCardsMigrated = 0;
      int normalCardsMigrated = 0;
      int alreadyMigrated = 0;
      int failed = 0;

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          
          // ✅ تحقق لو الكارت محول قبل كده
          if (_isAlreadyMigrated(data)) {
            alreadyMigrated++;
            print('⏭️  تخطي ${doc.id} - محول قبل كده');
            continue;
          }

          // ✅ حدد نوع الكارت
          final isAICard = data['card_type'] == 'ai' || 
                           data.containsKey('word');

          Map<String, dynamic> updates;

          if (isAICard) {
            updates = _migrateAICard(data);
            aiCardsMigrated++;
          } else {
            updates = _migrateNormalCard(data);
            normalCardsMigrated++;
          }

          // ✅ حدّث الكارت
          await _firestore.collection('cards').doc(doc.id).update(updates);
          print('✅ تم تحديث ${doc.id}');

        } catch (e) {
          failed++;
          print('❌ فشل تحديث ${doc.id}: $e');
        }
      }

      print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📊 النتائج:');
      print('   AI Cards: $aiCardsMigrated');
      print('   Normal Cards: $normalCardsMigrated');
      print('   Already Migrated: $alreadyMigrated');
      print('   Failed: $failed');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    } catch (e) {
      print('❌ خطأ في التحويل: $e');
      rethrow;
    }
  }

  /// ══════════════════════════════════════════════════
  ///   تحويل AI Card
  /// ══════════════════════════════════════════════════
  Map<String, dynamic> _migrateAICard(Map<String, dynamic> oldData) {
    // البيانات اللي محتاج يضيفها أو يغيرها
    final updates = <String, dynamic>{};

    // ✅ تحويل الأسماء القديمة للجديدة
    if (oldData.containsKey('easiness')) {
      updates['ease'] = oldData['easiness'];
      // مش محتاج تحذف easiness - هتبقى موجودة بس مش هنستخدمها
    }

    if (oldData.containsKey('next_review')) {
      updates['due_date'] = oldData['next_review'];
    }

    // ✅ إضافة الحقول الناقصة
    updates['current_step'] = oldData['current_step'] ?? 0;
    updates['lapses'] = oldData['lapses'] ?? 0;
    updates['is_ai_card'] = true;
    updates['is_valid'] = oldData['is_valid'] ?? false;

    // ✅ تحديد الـ state بناءً على البيانات القديمة
    updates['state'] = _determineState(oldData);

    return updates;
  }

  /// ══════════════════════════════════════════════════
  ///   تحويل Normal Card
  /// ══════════════════════════════════════════════════
  Map<String, dynamic> _migrateNormalCard(Map<String, dynamic> oldData) {
    final updates = <String, dynamic>{};

    // ✅ تحويل الأسماء
    if (oldData.containsKey('easiness')) {
      updates['ease'] = oldData['easiness'];
    }

    if (oldData.containsKey('next_review')) {
      updates['due_date'] = oldData['next_review'];
    }

    // ✅ إضافة الحقول الناقصة
    updates['current_step'] = oldData['current_step'] ?? 0;
    updates['lapses'] = oldData['lapses'] ?? 0;
    updates['is_ai_card'] = false;

    // ✅ تأكد من وجود front/back fields
    updates['front_side'] = oldData['front_side'] ?? '';
    updates['back_side'] = oldData['back_side'] ?? '';
    updates['front_image_url'] = oldData['front_image_url'] ?? '';
    updates['back_image_url'] = oldData['back_image_url'] ?? '';
    updates['front_image_path'] = oldData['front_image_path'] ?? '';
    updates['back_image_path'] = oldData['back_image_path'] ?? '';

    // ✅ تحديد الـ state
    updates['state'] = _determineState(oldData);

    return updates;
  }

  /// ══════════════════════════════════════════════════
  ///   تحديد الـ State من البيانات القديمة
  /// ══════════════════════════════════════════════════
  String _determineState(Map<String, dynamic> data) {
    final repetition = data['repetition'] ?? 0;
    final interval = data['interval'] ?? 0;

    // لو repetition = 0 و interval = 0 ──► newCard
    if (repetition == 0 && interval == 0) {
      return 'newCard';
    }

    // لو repetition = 0 بس interval > 0 ──► learning (في مرحلة التعلم)
    if (repetition == 0 && interval > 0) {
      return 'learning';
    }

    // لو repetition > 0 ──► review
    if (repetition > 0) {
      return 'review';
    }

    // Default
    return 'newCard';
  }

  /// ══════════════════════════════════════════════════
  ///   فحص لو الكارت محول قبل كده
  /// ══════════════════════════════════════════════════
  bool _isAlreadyMigrated(Map<String, dynamic> data) {
    // لو موجود ease (مش easiness) و state ──► محول
    return data.containsKey('ease') && 
           data.containsKey('state') &&
           data.containsKey('due_date');
  }

  /// ══════════════════════════════════════════════════
  ///   تحويل كروت collection معين بس
  /// ══════════════════════════════════════════════════
  Future<void> migrateCollection(String collectionId) async {
    print('🚀 بدء تحويل كروت الـ collection: $collectionId');

    try {
      final snapshot = await _firestore
          .collection('cards')
          .where('collectionId', isEqualTo: collectionId)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        
        if (_isAlreadyMigrated(data)) {
          continue;
        }

        final isAICard = data['card_type'] == 'ai' || 
                         data.containsKey('word');

        final updates = isAICard 
            ? _migrateAICard(data) 
            : _migrateNormalCard(data);

        await _firestore.collection('cards').doc(doc.id).update(updates);
        print('✅ تم تحديث ${doc.id}');
      }

      print('✅ تم تحويل كروت الـ collection بنجاح');

    } catch (e) {
      print('❌ خطأ: $e');
      rethrow;
    }
  }
}