import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/user.freezed.dart';
part 'generated/user.g.dart';

@freezed
class User with _$User {
  factory User({
    required String id,
    String? firstName,
    String? lastName,
    String? email,
    //@Default([]) List<String> calendars,
    String? photo,
    @Default(true) bool? active,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
