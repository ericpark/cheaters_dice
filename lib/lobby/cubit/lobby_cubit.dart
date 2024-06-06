import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lobby_state.dart';
part 'generated/lobby_cubit.g.dart';
part 'generated/lobby_cubit.freezed.dart';

class LobbyCubit extends Cubit<LobbyState> {
  LobbyCubit() : super(LobbyState.initial());
}
