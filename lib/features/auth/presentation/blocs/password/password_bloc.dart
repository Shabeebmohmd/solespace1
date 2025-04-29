// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  PasswordBloc() : super(PasswordState()) {
    on<PasswordShow>((event, emit) {
      return emit(state.copyWith(isPasswordVisible: event.isVisible));
    });
    on<PasswordHide>((event, emit) {
      return emit(const PasswordState());
    });
  }
}
