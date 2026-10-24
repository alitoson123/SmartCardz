import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Home/Data/Repo_impl/collection_repo_impl.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/actions_collection_cubit/actions_collection_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/folder_cubit/get_folders_cubit/get_folders_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/folder_cubit/actions_folder_cubit/actions_folder_cubit.dart';
import 'package:smart_cards/Features/Home/Data/Repo_impl/folder_repo_impl.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/services/locator_service/service_locator.dart';
import 'package:smart_cards/core/services/Bloc_observes_service/my_Bloc_observe.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collections_stats_cubit/collections_stats_cubit.dart';
import 'package:smart_cards/Features/Home/Domain/Repos/collection_stats_repo/collection_stats_repo.dart';
import 'package:smart_cards/core/utils/app_theme/dark_theme.dart';
import 'package:smart_cards/core/utils/app_theme/light_theme.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_cards/core/view_model/app_init_cubit/app_init_cubit.dart';
import 'package:smart_cards/core/view_model/app_language_cubit/app_language_cubit.dart';
import 'package:smart_cards/core/view_model/app_language_cubit/app_language_states.dart';
import 'package:smart_cards/core/view_model/app_purchase_cubit/app_purchase_cubit.dart';
import 'package:smart_cards/core/view_model/app_theme_cubit/app_theme_cubit.dart';
import 'package:smart_cards/core/view_model/app_theme_cubit/app_theme_states.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:io' show Platform;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, // مش يمسح الـ cache تلقائي
  );

  Bloc.observer = MyBlocObserver(); // bloc observer

  // for google ads
  // Initialize AdMob SDK
  //await MobileAds.instance.initialize();

  await _configureRevenueCat();

  runApp(const SmartCards());
}

Future<void> _configureRevenueCat() async {
  // Enable verbose logging in debug mode only
  await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.error);

  final PurchasesConfiguration configuration;

  if (Platform.isAndroid) {
    configuration = PurchasesConfiguration(AppConstants.revenueCatGoogleApiKey);
  } else {
    // iOS / macOS
    configuration = PurchasesConfiguration(AppConstants.revenueCatAppleApiKey);
  }

  // If you have a logged-in Firebase user, pass their UID as appUserID.
  // If anonymous, omit it — RevenueCat will generate one automatically.
  // Example (do this AFTER Firebase auth):
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) configuration.appUserID = user.uid;

  await Purchases.configure(configuration);
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
              create: (context) => ActionsCollectionCubit(
                collectionRepo: getIt<CollectionRepoImpl>(),
              ),
            ),
            BlocProvider(
              create: (context) => ActionsFolderCubit(
                folderRepo: getIt<FolderRepoImpl>(),
              ),
            ),

            BlocProvider(
              create: (context) => GetCollectionsCubit(
                collectionRepoImpl: getIt<CollectionRepoImpl>(),
              ),
            ),
            BlocProvider(
              create: (context) => GetFoldersCubit(
                folderRepoImpl: getIt<FolderRepoImpl>(),
              ),
            ),
            BlocProvider(
              create: (context) => CollectionsStatsCubit(
                repository: getIt<CollectionStatsRepo>(),
              ),
            ),
            BlocProvider(create: (context) => SubscriptionCubit()),
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
