import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/add_and_show_card_repo_impl/add_and_show_card_repo_impl.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_ai_card_cubit/add_ai_card_cubit.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/show_ai_card_cubit/show_ai_card_cubit.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/add_and_show_card_view.dart';
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
import 'package:smart_cards/Features/Revision/Presentation/View_model/fetch_and_rating_cubit/fetch_and_rating_cubit.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/revision_view.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/settings_view.dart';
import 'package:smart_cards/Features/Splash/Presentation/views/spalsh_view.dart';
import 'package:smart_cards/core/services/locator_service/service_locator.dart';
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
                  addAndShowCardRepoImpl: getIt<AddAndShowCardRepoImpl>(),
                ),
              ),
              BlocProvider(
                create: (context) => AddAICardCubit(
                  addAndShowCardRepoImpl: getIt<AddAndShowCardRepoImpl>(),
                ),
              ),
            ],
            child: AddAndShowCardView(),
          );
        },
      ),
      GoRoute(
        path: revisionCardScreen,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              FetchAndRatingCubit(revisionRepoImpl: getIt<RevisionRepoImpl>()),
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
    ],
  );
}
