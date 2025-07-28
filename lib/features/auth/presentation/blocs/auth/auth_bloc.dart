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
      emit(AuthError(message: 'Failed to check authentication status'));
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
        emit(AuthError(message: 'Sign in failed. Please try again.'));
        emit(Unauthenticated());
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        default:
          errorMessage = 'An error occurred during sign in.';
      }
      emit(AuthError(message: errorMessage));
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred.'));
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
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'An account already exists with this email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        default:
          errorMessage = 'An error occurred during registration.';
      }
      emit(AuthError(message: errorMessage));
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Failed to create user account.'));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await authRepository.signInWithGoogle();
      if (userCredential.user != null) {
        final user = UserModel(
          id: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          name: userCredential.user!.displayName ?? 'User',
          profileImageUrl: userCredential.user!.photoURL,
        );
        await authRepository.addUserToFirestore(user);
        emit(Authenticated(uid: userCredential.user!.uid));
      } else {
        emit(AuthError(message: 'Google sign in failed.'));
        emit(Unauthenticated());
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage =
              'An account already exists with the same email address but different sign-in credentials.';
          break;
        case 'invalid-credential':
          errorMessage = 'The credential is invalid or has expired.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Google sign in is not enabled.';
          break;
        default:
          errorMessage = 'An error occurred during Google sign in.';
      }
      emit(AuthError(message: errorMessage));
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Failed to sign in with Google.'));
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
      emit(PasswordResetSent());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email address.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        default:
          errorMessage = 'Failed to send password reset email.';
      }
      emit(AuthError(message: errorMessage));
      emit(Unauthenticated());
    } catch (e) {
      emit(
        AuthError(
          message: 'An unexpected error occurred while resetting password.',
        ),
      );
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      // emit(AuthError(message: 'Failed to sign out. Please try again.'));
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
        emit(Authenticated(uid: user.uid));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to check authentication status.'));
      emit(Unauthenticated());
    }
  }

  // Future<void> _onCheckAuthStatus(
  //   CheckAuthStatus event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       try {
  //         // await user.getIdToken(true);
  //         emit(Authenticated(uid: user.uid));
  //       } catch (e) {
  //         await authRepository.signOut();
  //         emit(AuthError(message: 'Session expired. Please sign in again.'));
  //         emit(Unauthenticated());
  //       }
  //     } else {
  //       emit(Unauthenticated());
  //     }
  //   } catch (e) {
  //     emit(AuthError(message: 'Failed to check authentication status.'));
  //     emit(Unauthenticated());
  //   }
  // }
}
