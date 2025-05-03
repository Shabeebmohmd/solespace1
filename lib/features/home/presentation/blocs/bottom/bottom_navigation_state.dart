part of 'bottom_navigation_bloc.dart';

sealed class BottomNavigationState extends Equatable {
  const BottomNavigationState();
  
  @override
  List<Object> get props => [];
}

final class BottomNavigationInitial extends BottomNavigationState {}
