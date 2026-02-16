import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_cards/Features/Auth/Data/models/user_model.dart';
import 'package:smart_cards/Features/Auth/Domain/Entities/user_entity.dart';
import 'package:smart_cards/Features/Auth/Domain/Repos/auth_repo.dart';
import 'package:smart_cards/core/errors/failure.dart';
import 'package:smart_cards/core/services/ARUD_user/ARUD_user.dart';
import 'package:smart_cards/core/services/Local_service/local_service_with_hive.dart';
import 'package:smart_cards/core/services/firebase_auth_service/firebase_auth_service.dart';

class AuthRepoImpl extends AuthRepo {
  final Auth authObject;
  final ArudUser arudUserObject;

  AuthRepoImpl({required this.arudUserObject, required this.authObject});
  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await authObject.signInWithEmailAndPasswordAndIsLoginCheck(
        email: email,
        password: password,
      );
      var userData = await getUser(); // Step 2
      await LocalServiceWithHive().saveUser(userData); // Step 3

      return right(
        UserModel.fromFirebaseAddUserOfSignUpAndSignInWithGoogle(user),
      );
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      return left(ServerFailure(errorMessage: errorMessage));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signup({
    required String email,
    required String password,
    required String Fname,
    required String Lname,
  }) async {
    try {
      var user = await authObject.SignUpMethod(
        email: email,
        password: password,
      );
      /*  var userEntity = UserModel.fromFirebaseAddUserOfSignUpAndSignInWithGoogle(
        user,
      );*/
      var userEntity = UserModel(
        email: email,
        useruid: user.uid,
        Fname: Fname,
        Lname: Lname,
      );
      addUser(
        data: userEntity,
        MapOfData: userEntity.toMapOfSignUp(),
      ); // Step 1
      await LocalServiceWithHive().saveUser(userEntity); // Step 2

      return right(userEntity);
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      return left(ServerFailure(errorMessage: errorMessage));
    }
  }

  @override
  Future<Either<Failure, void>> forgetPassword({required String email}) async {
    try {
      var user = await authObject.ForgetPasswordMethod(email: email);
      return right(user);
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      return left(ServerFailure(errorMessage: errorMessage));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final user = await authObject.signInWithGoogle();

      var userEntity = UserModel.fromFirebaseAddUserOfSignUpAndSignInWithGoogle(
        user,
      );

      bool isTrue = await CheckIsUserAddDataBefore(
        useruid: userEntity.useruid!,
      );

      if (isTrue) {
        var userData = await getUser(); // Step 2

        await LocalServiceWithHive().saveUser(userData); // Step 3
      } else {
        await addUser(
          // Step 1
          data: userEntity,
          MapOfData: userEntity.toMapOfSignUp(),
        );

        var userData = await getUser(); // Step 2

        await LocalServiceWithHive().saveUser(userData); // Step 3
      }

      return right(
        UserModel.fromFirebaseAddUserOfSignUpAndSignInWithGoogle(user),
      );
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      return left(ServerFailure(errorMessage: errorMessage));
    }
  }

  @override
  Future<void> addUser({
    required UserEntity data,
    required Map<String, dynamic> MapOfData,
  }) async {
    await arudUserObject.addUser(
      documentName: "users",
      data: MapOfData,
      userUid: FirebaseAuth.instance.currentUser!.uid,
    );
  }

  @override
  Future<UserModel> getUser() async {
    var user = await arudUserObject.getUser(
      documentName: "users",
      useruid: FirebaseAuth.instance.currentUser!.uid,
    );
    return UserModel.fromFirebaseGetUser(user);
  }

  @override
  Future<void> deleteUser({required String useruid}) async {
    await arudUserObject.deleteUser(documentName: "users", useruid: useruid);
  }

  @override
  Future<bool> CheckIsUserAddDataBefore({required String useruid}) {
    return arudUserObject.CheckIsUserAddDataBefore(
      documentName: "users",
      useruid: useruid,
    );
  }
}
