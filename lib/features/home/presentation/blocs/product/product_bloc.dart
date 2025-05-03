import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sole_space_user1/features/home/data/product_repsotory.dart';
import 'package:sole_space_user1/features/home/models/product_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepsitory productRepsitory;
  ProductBloc({required this.productRepsitory}) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProduct);
  }

  Future<void> _onFetchProduct(
    FetchProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await productRepsitory.fetchProducts();
      emit(ProductLoaded(data: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}
