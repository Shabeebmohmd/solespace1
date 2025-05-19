part of 'theme_bloc.dart';

sealed class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {
  final ThemeMode themeMode;
  const ThemeInitial({this.themeMode = ThemeMode.dark}); // Default to dark

  @override
  List<Object> get props => [themeMode];
}
