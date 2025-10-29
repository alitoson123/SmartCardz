import 'package:go_router/go_router.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/add_and_show_card_view.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/add_normal_card_view.dart';
import 'package:smart_cards/Features/Auth/Forget_Password/Presentation/Views/forget_password_view.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/Views/sign_in_view.dart';
import 'package:smart_cards/Features/Auth/Sign_up/Presentation/Views/sign_up_view.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/home_view.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/revision_view.dart';
import 'package:smart_cards/core/views/collection_view.dart';

class AppRoutes {
  //static String KinitialPage = '/';
  //  static String KOnBoardingPage = '/OnBoarding';
  static const String SignInPage = '/';
  static const String ForgetPasswordPage = '/ForgetPassword';
  static const String SignUpPage = '/SignUp';
  static const String homeScreen = '/home';
  static const String addNormalCardScreen = '/addNormalCard';
  static const String addAndShowCardScreen = '/addAndShowCard';
  static const String revisionCardScreen = '/revisionCard';
  static const String collectionsScreen = '/collections';

  static final route = GoRouter(
    routes: [
      GoRoute(path: homeScreen, builder: (context, state) => const HomeView()),
      GoRoute(
        path: addNormalCardScreen,
        builder: (context, state) {
          return AddNormalCardView(collectionId: state.extra as String);
        },
      ),
      GoRoute(
        path: addAndShowCardScreen,
        builder: (context, state) {
          return AddAndShowCardView(collectionId: state.extra as String);
        },
      ),
      GoRoute(
        path: revisionCardScreen,
        builder: (context, state) => const RevisionView(),
      ),

      GoRoute(
        path: SignInPage,
        builder: (context, state) => const SignInView(),
      ),
      GoRoute(
        path: ForgetPasswordPage,
        builder: (context, state) => const ForgetPasswordView(),
      ),
      GoRoute(
        path: SignUpPage,
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        path: collectionsScreen,
        builder: (context, state) => CollectionView(),
      ),
    ],
  );
}
