import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/die.g.dart';
part 'generated/die.freezed.dart';

@freezed
class Die with _$Die {
  factory Die({
    required String id,
    @Default(0) int value,
  }) = _Die;

  factory Die.fromJson(Map<String, dynamic> json) => _$DieFromJson(json);
}
