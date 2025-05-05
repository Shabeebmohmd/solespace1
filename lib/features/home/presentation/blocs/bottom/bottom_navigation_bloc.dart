import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_navigation_event.dart';
part 'bottom_navigation_state.dart';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc()
    : super(const BottomNavigationState(selectedIndex: 2)) {
    on<TabSelected>((event, emit) {
      emit(BottomNavigationState(selectedIndex: event.index));
    });
  }
}
