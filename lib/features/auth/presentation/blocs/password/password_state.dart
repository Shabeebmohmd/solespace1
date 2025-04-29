part of 'password_bloc.dart';

class PasswordState extends Equatable {
  final bool isPasswordVisible;
  const PasswordState({this.isPasswordVisible = true});

  PasswordState copyWith({bool? isPasswordVisible}) {
    return PasswordState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

  @override
  List<Object> get props => [isPasswordVisible];
}
