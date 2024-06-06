import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/bid.g.dart';
part 'generated/bid.freezed.dart';

@freezed
abstract class Bid with _$Bid {
  const factory Bid({
    @Default(0) int number,
    @Default(0) int value,
    String? playerId,
  }) = _Bid;
  factory Bid.initial() => const _Bid(number: 1, value: 1);
  factory Bid.minimum() => const _Bid(number: 1, value: 2);
  factory Bid.fromJson(Map<String, dynamic> json) => _$BidFromJson(json);
}
