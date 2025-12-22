import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/add_and_show_card_repo_impl/add_and_show_card_repo_impl.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_and_show_card_cubit/add_and_show_card_cubit.dart';
import 'package:smart_cards/Features/Auth/Data/Repos/auth_repo_impl.dart';
import 'package:smart_cards/Features/Auth/Data/models/user_model.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/view_model/sign_in_cubit/sign_in_cubit.dart';
import 'package:smart_cards/Features/Home/Data/Models/collection_model.dart';
import 'package:smart_cards/Features/Home/Data/Repo_impl/collection_repo_impl.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/add_collection_cubit1.dart/add_collection_cubit.dart';
import 'package:smart_cards/Features/Revision/Data/Repos_impl/revision_repo_impl.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/fetch_and_rating_cubit/fetch_and_rating_cubit.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/models/card__with_AI_model.dart';
import 'package:smart_cards/Features/Add_normal_card/Data/models/normal_card_model.dart';
import 'package:smart_cards/core/services/notifications_service/push_notification_service.dart';
import 'package:smart_cards/core/utils/hive_adapters/timestamp_adapter.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';
import 'package:smart_cards/core/services/Bloc_observes_service/my_Bloc_observe.dart';
import 'package:smart_cards/core/services/Shared_preferences_service/shared_preferences.dart';
import 'package:smart_cards/core/services/locator_service/service_locator.dart';
import 'package:smart_cards/core/utils/app_theme/dark_theme.dart';
import 'package:smart_cards/core/utils/app_theme/light_theme.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_cards/core/view_model/app_language_cubit/app_language_cubit.dart';
import 'package:smart_cards/core/view_model/app_language_cubit/app_language_states.dart';
import 'package:smart_cards/core/view_model/app_theme_cubit/app_theme_cubit.dart';
import 'package:smart_cards/core/view_model/app_theme_cubit/app_theme_states.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Bloc.observer = MyBlocObserver(); // bloc observer

  await Hive.initFlutter(); // hive
  Hive.registerAdapter(UserModelAdapter()); // hive
  Hive.registerAdapter(CollectionModelAdapter()); // hive
  Hive.registerAdapter(CardWithAIModelAdapter()); // hive
  Hive.registerAdapter(NormalCardModelAdapter()); // hive
  Hive.registerAdapter(TimestampAdapter()); // hive

  await Hive.openBox<UserModel>(K_USER_BOX); // hive
  await Hive.openBox<CollectionModel>(K_COLLECTION_BOX); // hive
  await Hive.openBox<BaseCardEntity>(K_DUE_CARDS_BOX); // hive

  await SharedPreferencesService.instance.init(); // shared preferences

  await PushNotificationService.init(); // notification

  setup(); // locator service

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
    // final backgroundService = BackGroundService();
    // backgroundService.updateLastOpened();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 800),
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SignInCubit(getIt<AuthRepoImpl>()),
            ),
            BlocProvider<AddAndShowCardCubit>(
              create: (context) => AddAndShowCardCubit(
                addAndShowCardRepoImpl: getIt<AddAndShowCardRepoImpl>(),
              ),
            ),
            BlocProvider<FetchAndRatingCubit>(
              create: (context) => FetchAndRatingCubit(
                revisionRepoImpl: getIt<RevisionRepoImpl>(),
              ),
            ),
            BlocProvider<AddCollectionCubit>(
              create: (context) => AddCollectionCubit(
                addCollectionRepo: getIt<CollectionRepoImpl>(),
              ),
            ),
            BlocProvider<GetCollectionsCubit>(
              create: (context) => GetCollectionsCubit(
                collectionRepoImpl: getIt<CollectionRepoImpl>(),
              ),
            ),
            BlocProvider(create: (context) => ThemeCubit()..loadInitialTheme()),
            BlocProvider(
              create: (context) => AppLanguageCubit()..loadInitialLanguage(),
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
