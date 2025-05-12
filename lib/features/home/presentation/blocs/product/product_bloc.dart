import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sole_space_user1/features/home/data/product_repsotory.dart';
import 'package:sole_space_user1/features/home/models/product_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepsitory productRepsitory;
  List<Product> _allProducts = [];
  ProductBloc({required this.productRepsitory}) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProduct);
    on<ToggleFavorite>(_onToggleFavorite);
    on<SearchProduct>(_onSearchProducts);
  }

  Future<void> _onFetchProduct(
    FetchProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await productRepsitory.fetchProducts();
      _allProducts = products;
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList('favorite_product_ids') ?? [];
      final favorites =
          products
              .where((product) => favoriteIds.contains(product.id))
              .toList();
      emit(ProductLoaded(data: products, favorites: favorites));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  void _onToggleFavorite(
    ToggleFavorite event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final product = event.product;
      final favorites = List<Product>.from(currentState.favorites);
      final isFavorited = favorites.any((element) => element.id == product.id);

      if (isFavorited) {
        favorites.removeWhere((element) => element.id == product.id);
      } else {
        favorites.add(product);
      }

      final prefs = await SharedPreferences.getInstance();
      final favoriteIds =
          favorites.map((p) => p.id).whereType<String>().toList();
      await prefs.setStringList('favorite_product_ids', favoriteIds);

      emit(ProductLoaded(data: currentState.data, favorites: favorites));
    }
  }

  void _onSearchProducts(SearchProduct event, Emitter<ProductState> emit) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      if (event.query.trim().isEmpty) {
        emit(
          ProductLoaded(data: _allProducts, favorites: currentState.favorites),
        );
        return;
      }
      final filteredProducts =
          _allProducts
              .where(
                (product) => product.name.toLowerCase().contains(
                  event.query.toLowerCase(),
                ),
              )
              .toList();
      emit(
        ProductLoaded(
          data: filteredProducts,
          favorites: currentState.favorites,
        ),
      );
    }
  }
}
