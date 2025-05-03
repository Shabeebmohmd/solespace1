import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/features/home/data/brand_repository.dart';
import 'package:sole_space_user1/features/home/models/brand_model.dart';

part 'brand_event.dart';
part 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final BrandRepository brandRepository;
  BrandBloc({required this.brandRepository}) : super(BrandInitial()) {
    on<FetchBrands>(_onFetchBrand);
  }

  Future<void> _onFetchBrand(
    FetchBrands event,
    Emitter<BrandState> emit,
  ) async {
    emit(BrandLoading());
    try {
      final brands = await brandRepository.fetchBrands();
      emit(BrandLoaded(data: brands));
    } catch (e) {
      emit(BrandError(message: e.toString()));
    }
  }
}
