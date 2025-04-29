part of 'password_bloc.dart';

sealed class PasswordEvent extends Equatable {
  const PasswordEvent();

  @override
  List<Object> get props => [];
}

class PasswordShow extends PasswordEvent {
  final bool isVisible;

  const PasswordShow({required this.isVisible});

  @override
  List<Object> get props => [isVisible];
}

class PasswordHide extends PasswordEvent {}
