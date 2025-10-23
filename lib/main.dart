import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ✅ استورد الباكدج
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/add_and_show_card_repo_impl/add_and_show_card_repo_impl.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_and_show_card_cubit/add_and_show_card_cubit.dart';
import 'package:smart_cards/Features/Auth/Data/Repos/auth_repo_impl.dart';
import 'package:smart_cards/Features/Auth/Data/models/user_model.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/view_model/sign_in_cubit/sign_in_cubit.dart';
import 'package:smart_cards/Features/Revision/Data/Repos_impl/revision_repo_impl.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/fetch_and_rating_cubit/fetch_and_rating_cubit.dart';
import 'package:smart_cards/core/services/Bloc_observes_service/my_Bloc_observe.dart';
import 'package:smart_cards/core/services/locator_service/service_locator.dart';
import 'package:smart_cards/core/services/test_movement.dart';
import 'package:smart_cards/core/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Bloc.observer = MyBlocObserver();

  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('myBox');
  // await migrateFlashCardsToEnglish();

  setup();
  runApp(const SmartCards());
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
          ],
          child: MaterialApp.router(
            routerConfig: AppRoutes.route,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
