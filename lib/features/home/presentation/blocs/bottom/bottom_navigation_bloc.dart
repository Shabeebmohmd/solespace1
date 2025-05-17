import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_navigation_event.dart';
part 'bottom_navigation_state.dart';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc()
    : super(
        BottomNavigationState(
          selectedIndex: 2,
          // pageController: PageController(initialPage: 2),
        ),
      ) {
    on<TabSelected>((event, emit) {
      emit(BottomNavigationState(selectedIndex: event.index));
    });
  }
}
