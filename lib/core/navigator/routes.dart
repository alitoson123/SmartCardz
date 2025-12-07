import 'package:go_router/go_router.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/add_and_show_card_view.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/add_normal_card_view.dart';
import 'package:smart_cards/Features/Auth/Forget_Password/Presentation/Views/forget_password_view.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/Views/sign_in_view.dart';
import 'package:smart_cards/Features/Auth/Sign_up/Presentation/Views/sign_up_view.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/home_view.dart';
import 'package:smart_cards/Features/On_Boarding/Presentation/Views/on_boarding_view.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/revision_view.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/settings_view.dart';
import 'package:smart_cards/Features/Splash/Presentation/views/spalsh_view.dart';
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
          return AddAndShowCardView();
        },
      ),
      GoRoute(
        path: revisionCardScreen,
        builder: (context, state) =>
            RevisionView(collection: state.extra as CollectionEntity),
      ),

      GoRoute(
        path: signInScreen,
        builder: (context, state) => const SignInView(),
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
