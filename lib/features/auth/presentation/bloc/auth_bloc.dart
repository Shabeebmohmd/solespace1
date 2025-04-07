import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/features/auth/data/repositories/auth_repository.dart';
import 'package:sole_space_user1/features/auth/presentation/bloc/auth_event.dart';
import 'package:sole_space_user1/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignInWithEmailAndPassword>(_onSignInWithEmailAndPassword);
    on<RegisterWithEmailAndPassword>(_onRegisterWithEmailAndPassword);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<ResetPassword>(_onResetPassword);
    on<SignOut>(_onSignOut);
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
}
