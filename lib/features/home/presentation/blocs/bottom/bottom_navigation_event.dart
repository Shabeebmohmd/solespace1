part of 'bottom_navigation_bloc.dart';

sealed class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();

  @override
  List<Object> get props => [];
}

class TabSelected extends BottomNavigationEvent {
  final int index;
  const TabSelected({required this.index});
  @override
  List<Object> get props => [index];
}
