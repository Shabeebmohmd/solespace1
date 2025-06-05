import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/features/auth/data/model/user_model.dart';
import 'package:sole_space_user1/features/auth/data/repositories/auth_repository.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/auth/auth_event.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  StreamSubscription<User?>? _authStateSubscription;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignInWithEmailAndPassword>(_onSignInWithEmailAndPassword);
    on<RegisterWithEmailAndPassword>(_onRegisterWithEmailAndPassword);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<ResetPassword>(_onResetPassword);
    on<SignOut>(_onSignOut);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<AuthStateChanged>(_onAuthStateChanged);

    _initializeAuthStateListener();
  }

  void _initializeAuthStateListener() {
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        add(AuthStateChanged(user: user));
      },
      onError: (error) {
        add(CheckAuthStatus());
      },
    );
  }

  Future<void> _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (event.user != null) {
        add(CheckAuthStatus());
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
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
      if (userCredential.user != null) {
        emit(Authenticated(uid: userCredential.user!.uid));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
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
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // First ensure we're signed out
      // await authRepository.signOut();

      final userCredential = await authRepository.signInWithGoogle();
      if (userCredential.user != null) {
        // Create or update user data in Firestore
        final user = UserModel(
          id: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          name: userCredential.user!.displayName ?? 'User',
          profileImageUrl: userCredential.user!.photoURL,
        );
        await authRepository.addUserToFirestore(user);
        emit(Authenticated(uid: userCredential.user!.uid));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
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
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await user.getIdToken(true);
          emit(Authenticated(uid: user.uid));
        } catch (e) {
          await authRepository.signOut();
          emit(Unauthenticated());
        }
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }
}
