import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Home/Data/Repo_impl/collection_repo_impl.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/add_collection_cubit1.dart/add_collection_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/core/services/locator_service/service_locator.dart';
import 'package:smart_cards/core/services/notifications_service/push_notification_service.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Bloc.observer = MyBlocObserver(); // bloc observer

  runApp(const SmartCards());
}

class SmartCards extends StatefulWidget {
  const SmartCards({super.key});

  @override
  State<SmartCards> createState() => _SmartCardsState();
}

class _SmartCardsState extends State<SmartCards> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      PushNotificationService.handleNotificationTap(context);
      PushNotificationService.handleInitialMessage(context);
    });
  }

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
