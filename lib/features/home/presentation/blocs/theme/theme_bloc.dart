import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeInitial()) {
    on<ToggleTheme>((event, emit) {
      emit(
        ThemeInitial(
          themeMode: event.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        ),
      );
    });
  }
}
