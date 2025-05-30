import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sole_space_user1/features/auth/data/model/user_model.dart';
import 'package:sole_space_user1/features/auth/data/repositories/auth_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;
  final CloudinaryPublic cloudinary;
  final ImagePicker imagePicker;
  final user = FirebaseAuth.instance.currentUser;

  ProfileBloc({
    required this.authRepository,
    required this.cloudinary,
    required this.imagePicker,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileImage>(_onUpdateProfileImage);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final userDoc = await authRepository.getUserData(user!.uid);
      emit(ProfileLoaded(userDoc));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfileImage(
    UpdateProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is! ProfileLoaded) {
      emit(ProfileError(message: 'Profile not loaded'));
      return;
    }

    final currentUser = (state as ProfileLoaded).user;
    emit(ProfileLoading());

    try {
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final cloudinaryResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path, folder: "profile_images"),
        );

        final updatedUser = UserModel(
          id: user!.uid,
          name: currentUser.name,
          email: currentUser.email,
          profileImageUrl: cloudinaryResponse.secureUrl,
        );

        await authRepository.updateUserData(updatedUser);
        emit(ProfileLoaded(updatedUser));
      } else {
        emit(ProfileLoaded(currentUser));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is! ProfileLoaded) {
      emit(ProfileError(message: 'Profile not loaded'));
      return;
    }

    final currentUser = (state as ProfileLoaded).user;
    emit(ProfileLoading());

    try {
      // Update email if changed
      if (event.email != currentUser.email) {
        await user!.updateEmail(event.email);
      }

      // Update password if provided
      if (event.currentPassword != null && event.newPassword != null) {
        // Reauthenticate user before changing password
        final credential = EmailAuthProvider.credential(
          email: currentUser.email,
          password: event.currentPassword!,
        );
        await user!.reauthenticateWithCredential(credential);
        await user!.updatePassword(event.newPassword!);
      }

      // Update user data in Firestore
      final updatedUser = UserModel(
        id: user!.uid,
        name: event.name,
        email: event.email,
        profileImageUrl: currentUser.profileImageUrl,
      );

      await authRepository.updateUserData(updatedUser);
      emit(ProfileLoaded(updatedUser));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
