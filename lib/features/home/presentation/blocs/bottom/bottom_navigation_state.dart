part of 'bottom_navigation_bloc.dart';

class BottomNavigationState extends Equatable {
  final int selectedIndex;
  // final PageController pageController;
  const BottomNavigationState({
    required this.selectedIndex,
    // required this.pageController,
  });

  @override
  List<Object> get props => [selectedIndex];
}
