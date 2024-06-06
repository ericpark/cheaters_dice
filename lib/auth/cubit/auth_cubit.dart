import 'package:auth_repository/auth_repository.dart' hide User;
import 'package:bloc/bloc.dart';
import 'package:cheaters_dice/auth/auth.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthState());

  final AuthRepository _authRepository;

  /// Initialize the auth repository and log in user if already exists
  Future<void> init() async {
    // checks if user was previously logged in
    if (_authRepository.isLoggedIn) {
      // if get the user info from firebase and then emit user
      final user = User.fromJson(
        (await _authRepository.getUserById(
          id: _authRepository.currentUser.id,
        ))!
            .toJson(),
      );
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
    }
  }

  Future<String?> login({
    required String emailAddress,
    required String password,
  }) async {
    final user = await _authRepository.loginWithEmailAndPassword(
      emailAddress: emailAddress,
      password: password,
    );
    if (user == null) {
      return 'Incorrect email or password';
    }
    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        user: User.fromJson(user.toJson()),
      ),
    );
    return null;
  }

  Future<String?> signup({
    required String emailAddress,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final user = await _authRepository.signUpWithEmailAndPassword(
      emailAddress: emailAddress,
      password: password,
    );
    if (user == null) {
      return 'Issue creating account. Please try again later.';
    }
    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        user: User.fromJson(user.toJson()),
      ),
    );
    return null;
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
  }
}
