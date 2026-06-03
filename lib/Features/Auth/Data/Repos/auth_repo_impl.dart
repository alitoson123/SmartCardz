import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
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
      if (user == null) {
        return left(CancelFailure());
      }

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
  Future<Either<Failure, UserEntity>> signInWithApple() async {
    try {
      final user = await authObject.signInWithApple();
      if (user == null) {
        return left(CancelFailure());
      }

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
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return left(CancelFailure());
      }
      return left(ServerFailure(errorMessage: e.toString()));
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      return left(ServerFailure(errorMessage: errorMessage));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return left(ServerFailure(errorMessage: 'No user logged in.'));
      }

      // 1. Re-authentication Logic
      String providerId = '';
      for (var userInfo in user.providerData) {
        if (userInfo.providerId == 'google.com' || userInfo.providerId == 'apple.com') {
          providerId = userInfo.providerId;
          break;
        }
      }

      try {
        if (providerId == 'google.com') {
          final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
          if (googleUser == null) {
            return left(ServerFailure(errorMessage: 'Re-authentication cancelled by user.'));
          }
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          await user.reauthenticateWithCredential(credential);

        } else if (providerId == 'apple.com') {
          final AuthorizationCredentialAppleID appleIdCredential =
              await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );
          final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
          final AuthCredential credential = oAuthProvider.credential(
            idToken: appleIdCredential.identityToken,
            accessToken: appleIdCredential.authorizationCode,
          );
          await user.reauthenticateWithCredential(credential);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          return left(ServerFailure(errorMessage: 'Please log out and log back in to verify your identity.'));
        }
        return left(ServerFailure(errorMessage: e.message ?? 'Re-authentication failed.'));
      } catch (e) {
        return left(ServerFailure(errorMessage: 'An error occurred during re-authentication.'));
      }

      // 2. Delete user document from Firestore
      await arudUserObject.deleteUser(documentName: "users", useruid: user.uid);

      // 3. Delete user account from Firebase Auth
      await authObject.deleteAuthAccount();

      return right(null);
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (errorMessage.contains('requires-recent-login')) {
        return left(ServerFailure(errorMessage: 'Please log out and log back in before deleting your account.'));
      }
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
