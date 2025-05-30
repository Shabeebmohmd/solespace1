part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfileImage extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String email;
  final String? currentPassword;
  final String? newPassword;

  const UpdateProfile({
    required this.name,
    required this.email,
    this.currentPassword,
    this.newPassword,
  });

  @override
  List<Object?> get props => [name, email, currentPassword, newPassword];
}
