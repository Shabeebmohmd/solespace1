import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/features/auth/data/model/user_model.dart';
import 'package:sole_space_user1/features/auth/data/repositories/auth_repository.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/auth/auth_event.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignInWithEmailAndPassword>(_onSignInWithEmailAndPassword);
    on<RegisterWithEmailAndPassword>(_onRegisterWithEmailAndPassword);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<ResetPassword>(_onResetPassword);
    on<SignOut>(_onSignOut);
    on<CheckAuthStatus>(_onCheckAuthStatus);

    // Check initial auth state
    // add(CheckAuthStatus());
  }

  Future<void> _onSignInWithEmailAndPassword(
    SignInWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(Authenticated(uid: userCredential.user!.uid));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRegisterWithEmailAndPassword(
    RegisterWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await authRepository.registerWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      final user = UserModel(
        id: userCredential.user!.uid,
        email: event.email,
        name: event.name,
      );
      await authRepository.addUserToFirestore(user);
      emit(Authenticated(uid: userCredential.user!.uid));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await authRepository.signInWithGoogle();
      emit(Authenticated(uid: userCredential.user!.uid));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onResetPassword(
    ResetPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.resetPassword(event.email);
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      print('Checking auth status...');
      final user = FirebaseAuth.instance.currentUser;
      print('Current user: ${user?.uid}');

      if (user != null) {
        emit(Authenticated(uid: user.uid));
      } else {
        print('No user found, emitting Unauthenticated');
        emit(Unauthenticated());
      }
    } catch (e) {
      print('Error in _onCheckAuthStatus: $e');
      emit(AuthError(message: e.toString()));
    }
  }
}
