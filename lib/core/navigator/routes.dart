import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Repos/add_and_show_card_repo.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Repos/quota_repo.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_ai_card_cubit/add_ai_card_cubit.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/quota_cubit/quota_cubit.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/show_ai_card_cubit/show_ai_card_cubit.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/add_and_show_card_view.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/select_input_language.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/select_output_language.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/add_normal_card_view.dart';
import 'package:smart_cards/Features/Auth/Data/Repos/auth_repo_impl.dart';
import 'package:smart_cards/Features/Auth/Forget_Password/Presentation/Views/forget_password_view.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/view_model/sign_in_cubit/sign_in_cubit.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/Views/sign_in_view.dart';
import 'package:smart_cards/Features/Auth/Sign_up/Presentation/Views/sign_up_view.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/home_view.dart';
import 'package:smart_cards/Features/On_Boarding/Presentation/Views/on_boarding_view.dart';
import 'package:smart_cards/Features/Revision/Data/Repos_impl/revision_repo_impl.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/revision_cubit/recision_cubit.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/revision_view.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/settings_view.dart';
import 'package:smart_cards/Features/Splash/Presentation/views/spalsh_view.dart';
import 'package:smart_cards/core/services/locator_service/service_locator.dart';
import 'package:smart_cards/core/services/purchase_service/purchase_service_logic.dart';
import 'package:smart_cards/core/views/collection_view.dart';

class AppRoutes {
  static String spalshScreen = '/';
  static String onBoardingPage = '/onBoarding';
  static const String signInScreen = '/signIn';
  static const String forgetPasswordScreen = '/forgetPassword';
  static const String signUpScreen = '/signUp';
  static const String homeScreen = '/home';
  static const String addNormalCardScreen = '/addNormalCard';
  static const String addAndShowCardScreen = '/addAndShowCard';
  static const String revisionCardScreen = '/revisionCard';
  static const String collectionsScreen = '/collections';
  static const String settingsScreen = '/settings';
  static const String selectInputLanguageScreen = '/selectInputLanguage';
  static const String selectOutputLanguageScreen = '/selectOutputLanguage';
  static const String editCardScreen = '/editCard';

  static final route = GoRouter(
    routes: [
      GoRoute(
        path: spalshScreen,
        builder: (context, state) => const SplashView(),
      ),

      GoRoute(
        path: onBoardingPage,
        builder: (context, state) => const OnBoardingView(),
      ),
      GoRoute(path: homeScreen, builder: (context, state) => const HomeView()),
      GoRoute(
        path: addNormalCardScreen,
        builder: (context, state) {
          return AddNormalCardView();
        },
      ),
      GoRoute(
        path: addAndShowCardScreen,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ShowAICardCubit(
                  addAndShowCardRepo: getIt<AddAndShowCardRepo>(),
                  quotaRepo: getIt<QuotaRepo>(),
                ),
              ),
              BlocProvider(
                create: (context) => QuotaCubit(
                  quotaRepo: getIt<QuotaRepo>(),
                  purchaseService: getIt<PurchaseServiceLigic>(),
                )..fetchQuota(FirebaseAuth.instance.currentUser!.uid),
              ),
              BlocProvider(
                create: (context) => AddAICardCubit(
                  addAndShowCardRepoImpl: getIt<AddAndShowCardRepo>(),
                ),
              ),
            ],
            child: AddAndShowCardView(),
          );
        },
      ),
      GoRoute(
        path: revisionCardScreen,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => RevisionCubit(getIt<RevisionRepoImpl>()),
            ),
          ],
          child: RevisionView(collection: state.extra as CollectionEntity),
        ),
      ),

      GoRoute(
        path: signInScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => SignInCubit(getIt<AuthRepoImpl>()),
          child: const SignInView(),
        ),
      ),
      GoRoute(
        path: forgetPasswordScreen,
        builder: (context, state) => const ForgetPasswordView(),
      ),
      GoRoute(
        path: signUpScreen,
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        path: collectionsScreen,
        builder: (context, state) => CollectionView(),
      ),
      GoRoute(
        path: settingsScreen,
        builder: (context, state) => SettingsView(),
      ),
      GoRoute(
        path: selectInputLanguageScreen,
        builder: (context, state) => SelectInputLanguage(),
      ),
      GoRoute(
        path: selectOutputLanguageScreen,
        builder: (context, state) => SelectOutputLanguage(),
      ),
      /*GoRoute(
        path: editCardScreen,
        builder: (context, state) => EditCard(card: state.extra as BaseCardEntity),
      ),*/
    ],
  );
}
