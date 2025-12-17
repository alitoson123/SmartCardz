import 'package:dartz/dartz.dart';
import 'package:smart_cards/Features/Auth/Data/models/user_model.dart';
import 'package:smart_cards/Features/Auth/Domain/Entities/user_entity.dart';
import 'package:smart_cards/core/errors/failure.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signup({
    required String email,
    required String password,
    required String Fname,
    required String Lname,
  });
  Future<Either<Failure, void>> forgetPassword({required String email});
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<void> addUser({
    required UserEntity data,
    required Map<String, dynamic> MapOfData,
  });
  Future<UserModel> getUser();
  Future<void> deleteUser({required String useruid});

  Future<bool> CheckIsUserAddDataBefore({required String useruid});
}
