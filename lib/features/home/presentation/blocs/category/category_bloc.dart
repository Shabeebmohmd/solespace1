import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/features/home/data/category_repsitory.dart';
import 'package:sole_space_user1/features/home/models/category_model.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepsitory categoryRepsitory;
  CategoryBloc({required this.categoryRepsitory}) : super(CategoryInitial()) {
    on<FetchCategory>(_onFetchCategory);
    on<SearchCategory>(_onSearchCategories);
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

  void _onSearchCategories(SearchCategory event, Emitter<CategoryState> emit) {
    if (state is CategoryLoaded) {
      final currentState = state as CategoryLoaded;
      final filteredCategories =
          currentState.data
              .where(
                (category) => category.name.toLowerCase().contains(
                  event.query.toLowerCase(),
                ),
              )
              .toList();
      emit(CategoryLoaded(data: filteredCategories));
    }
  }
}
