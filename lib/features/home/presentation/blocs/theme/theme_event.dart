part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ToggleTheme extends ThemeEvent {
  final bool isDarkMode;
  const ToggleTheme(this.isDarkMode);

  @override
  List<Object> get props => [isDarkMode];
}
