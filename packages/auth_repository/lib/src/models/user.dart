import 'package:firestore_converter/firestore_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBAuth;

part 'generated/user.firestore_converter.dart';
part 'generated/user.freezed.dart';
part 'generated/user.g.dart';

@freezed
@FirestoreConverter(defaultPath: 'users')
class User with _$User {
  factory User({
    required String id,
    String? firstName,
    String? lastName,
    String? email,
    @Default(true) bool? active,
    String? photo,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromFirebaseUser(FBAuth.User? user) {
    if (user == null) {
      return User(id: "default");
    }
    return User(id: user.uid, email: user.email ?? "");
  }
}
