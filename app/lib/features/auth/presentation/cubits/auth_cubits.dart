import 'package:app/features/auth/domain/entities/app_patient.dart';
import 'package:app/features/auth/domain/repos/auth_repo.dart';
import 'package:app/features/auth/presentation/cubits/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubits extends Cubit<AuthStates> {
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthCubits({required this.authRepo}) : super(AuthIntial());

  // check if patient is already authenticated
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();
    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(UnAuthenticated());
    }
  }

  // get current patient
  AppUser? get currentUser => _currentUser;
  // login with email
  Future<void> login(String email, String pw) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailPassowrd(email, pw);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  Future<void> resetpassword() async {}
  //register with email
  Future<void> register(String email, String pw, String lastName,
      String firstName, int phoneNumber, DateTime dateOfBirth) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.registerWithEmailPassowrd(
          email, pw, lastName, firstName, dateOfBirth);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  //logout
  Future<void> logout() async {
    authRepo.logout();
    emit(UnAuthenticated());
  }
}

class SwitchBloc extends Bloc<SwitchEvent, SwitchState> {
  SwitchBloc() : super(SwitchState(false)) {
    on<ToggleSwitchEvent>((event, emit) {
      emit(SwitchState(!state.isOn));
    });
  }
}
