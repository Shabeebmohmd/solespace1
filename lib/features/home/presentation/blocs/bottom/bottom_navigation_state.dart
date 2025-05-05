part of 'bottom_navigation_bloc.dart';

class BottomNavigationState extends Equatable {
  final int selectedIndex;
  const BottomNavigationState({required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];
}
