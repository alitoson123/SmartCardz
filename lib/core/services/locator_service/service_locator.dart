import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/Remote_data_source/add_and_show_card_remote_data_source_impl.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/add_and_show_card_repo_impl/add_and_show_card_repo_impl.dart';
import 'package:smart_cards/Features/Add_normal_card/Data/Repos_impl/normal_card_repo_impl.dart';
import 'package:smart_cards/Features/Add_normal_card/Data/normal_card_remote_data_source/normal_card_remote_data_source_impl.dart';
import 'package:smart_cards/Features/Auth/Data/Repos/auth_repo_impl.dart';
import 'package:smart_cards/Features/Home/Data/Repo_impl/collection_repo_impl.dart';
import 'package:smart_cards/Features/Home/Data/collection_remote_data_source/collection_remote_data_source_impl.dart';
import 'package:smart_cards/Features/Revision/Data/Data_source/revision_remote_data_source.dart';
import 'package:smart_cards/Features/Revision/Data/Repos_impl/revision_repo_impl.dart';
import 'package:smart_cards/core/services/ARUD_user/ARUD_user.dart';
import 'package:smart_cards/core/services/app_services/card_service.dart';
import 'package:smart_cards/core/services/app_services/collection_service.dart';
import 'package:smart_cards/core/services/app_services/dio_service.dart';
import 'package:smart_cards/core/services/firebase_auth_service/firebase_auth_service.dart';
import 'package:smart_cards/Features/Home/Domain/Repos/collection_stats_repo/collection_stats_repo.dart';
import 'package:smart_cards/Features/Home/Data/Repo_impl/collection_stats_repo_impl.dart';
import 'package:smart_cards/Features/Home/Data/collection_stats_local_data_source/collection_stats_local_data_source.dart';
import 'package:smart_cards/Features/Home/Data/collection_stats_remote_data_source/collection_stats_remote_data_source.dart';

final getIt = GetIt.instance;
final Dio dio = Dio();

void setup() {
  // 1. Register AppServices first
  getIt.registerLazySingleton<DioService>(() => DioService(dio: dio));
  getIt.registerLazySingleton<CardService>(() => CardService());
  getIt.registerLazySingleton<CollectionService>(() => CollectionService());

  //  Register AI Card Feature dependencies
  getIt.registerLazySingleton<AddAndShowCardRepoImpl>(
    () => AddAndShowCardRepoImpl(
      addAndShowCardRemoteDataSource: ShowCardRemoteDataSourceImpl(
        dioService: getIt<DioService>(),
        cardService: getIt<CardService>(),
      ),
    ),
  );

  //  Register Normal Card Feature dependencies
  getIt.registerLazySingleton<NormalCardRepoImpl>(
    () => NormalCardRepoImpl(
      normalCardRemoteDataSourceImpl: NormalCardRemoteDataSourceImpl(
        cardService: getIt<CardService>(),
      ),
    ),
  );

  //  Register Auth Feature dependencies
  getIt.registerLazySingleton<AuthRepoImpl>(
    () => AuthRepoImpl(authObject: Auth(), arudUserObject: ArudUser()),
  );

  //  Register Collection Feature dependencies
  getIt.registerLazySingleton<CollectionRepoImpl>(
    () => CollectionRepoImpl(
      collectionRemoteDataSource: CollectionRemoteDataSourceImpl(
        collectionService: getIt<CollectionService>(),
      ),
    ),
  );

  //  Register CollectionStats Feature dependencies
  getIt.registerLazySingleton<CollectionStatsLocalDataSource>(
    () => const CollectionStatsLocalDataSourceImpl(),
  );
  //  Register CollectionStats Remote Data Source dependencies
  getIt.registerLazySingleton<CollectionStatsRemoteDataSource>(
    () => const CollectionStatsRemoteDataSourceImpl(),
  );
  //  Register CollectionStats Repo dependencies
  getIt.registerLazySingleton<CollectionStatsRepo>(
    () => CollectionStatsRepoImpl(
      localDataSource: getIt<CollectionStatsLocalDataSource>(),
      remoteDataSource: getIt<CollectionStatsRemoteDataSource>(),
    ),
  );

  //  Register Revision Feature dependencies
  getIt.registerLazySingleton<RevisionRepoImpl>(
    () => RevisionRepoImpl(
      revisionRemoteDataSource: RevisionRemoteDataSource(
        cardService: getIt<CardService>(),
      ),
    ),
  );
}
