import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sole_space_user1/features/home/data/category_repsitory.dart';
import 'package:sole_space_user1/features/home/models/brand_model.dart';
import 'package:sole_space_user1/features/home/models/category_model.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepsitory categoryRepsitory;
  CategoryBloc({required this.categoryRepsitory}) : super(CategoryInitial()) {
    on<FetchCategory>(_onFetchCategory);
  }
  Future<void> _onFetchCategory(
    FetchCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final category = await categoryRepsitory.fetchCategory();
      emit(CategoryLoaded(data: category));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }
}
