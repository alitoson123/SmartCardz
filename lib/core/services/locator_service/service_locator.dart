import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/Remote_data_source/add_and_show_card_remote_data_source_impl.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/add_and_show_card_repo_impl/add_and_show_card_repo_impl.dart';
import 'package:smart_cards/Features/Add_normal_card/Data/Repos_impl/normal_card_repo_impl.dart';
import 'package:smart_cards/Features/Add_normal_card/Data/normal_card_remote_data_source/normal_card_remote_data_source_impl.dart';
import 'package:smart_cards/Features/Auth/Data/Repos/auth_repo_impl.dart';
import 'package:smart_cards/Features/Home/Data/Repo_impl/add_collection_repo_impl.dart';
import 'package:smart_cards/Features/Home/Data/add_collection_remote_data_source/add_collection_remote_data_source_impl.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/add_collection_cubit/add_collection_cubit.dart';
import 'package:smart_cards/Features/Revision/Data/Repos_impl/revision_repo_impl.dart';
import 'package:smart_cards/Features/Revision/Data/revision_remote_data_source/revision_remote_data_source_impl.dart';
import 'package:smart_cards/core/services/ARUD_user/ARUD_user.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';
import 'package:smart_cards/core/services/firebase_auth_service/firebase_auth_service.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<AddAndShowCardRepoImpl>(
    AddAndShowCardRepoImpl(
      addAndShowCardRemoteDataSource: ShowCardRemoteDataSourceImpl(
        appServices: AppServices(dio: Dio()),
      ),
    ),
  );
  getIt.registerSingleton<RevisionRepoImpl>(
    RevisionRepoImpl(
      revisionRemoteDataSaource: RevisionRemoteDataSourceImpl(
        appServices: AppServices(dio: Dio()),
      ),
    ),
  );
  getIt.registerSingleton<NormalCardRepoImpl>(
    NormalCardRepoImpl(
      normalCardRemoteDataSourceImpl: NormalCardRemoteDataSourceImpl(
        appServices: AppServices(dio: Dio()),
      ),
    ),
  );
    getIt.registerSingleton<AuthRepoImpl>(
    AuthRepoImpl(authObject: Auth(), arudUserObject: ArudUser()),
  );
   getIt.registerSingleton<AddCollectionRepoImpl>(
    AddCollectionRepoImpl(
      addCollectionRemoteDataSource: AddCollectionRemoteDataSourceImpl(
        appServices: AppServices(dio: Dio()),
      ),// addCollectionLocalDataSource: null,
    ),
  );
}
