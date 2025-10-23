import 'package:hive/hive.dart';
import 'package:smart_cards/Features/Auth/Domain/Entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends UserEntity with HiveObjectMixin {
  @HiveField(0)
  @override
  String? email;

  @HiveField(1)
  @override
  String? useruid;

  @HiveField(2)
  @override
  String? Fname;

  @HiveField(3)
  @override
  String? Lname;

  UserModel({this.email, this.useruid, this.Fname, this.Lname})
    : super(email: email, useruid: useruid, Fname: Fname, Lname: Lname);

  factory UserModel.fromFirebaseAddUserOfSignUpAndSignInWithGoogle(user) =>
      UserModel(
        email: user.email.toString(),
        useruid: user.uid.toString(),
        Fname: user.displayName.toString(),
      );

  factory UserModel.fromFirebaseGetUser(Map<String, dynamic> user) => UserModel(
    email: user['email'],
    useruid: user['useruid'],
    Fname: user['Fname'],
    Lname: user['Lname'],
  );

  Map<String, dynamic> toMapOfSignUp() => {
    'Fname': Fname,
    'Lname': Lname,
    'email': email,
    'useruid': useruid,
  };
}
