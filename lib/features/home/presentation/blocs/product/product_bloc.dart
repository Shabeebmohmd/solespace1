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
    on<FetchProductsByBrand>(_onFetchProductsByBrand);
    on<ToggleFavorite>(_onToggleFavorite);
    on<SearchProduct>(_onSearchProducts);
    on<FilterProducts>(_onFilterProducts);
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

  Future<void> _onFetchProductsByBrand(
    FetchProductsByBrand event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await productRepsitory.fetchProductsByBrand(
        event.brandId,
      );
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

  void _onFilterProducts(FilterProducts event, Emitter<ProductState> emit) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      var filteredProducts = _allProducts;

      if (event.brandId != null && event.brandId!.isNotEmpty) {
        filteredProducts =
            filteredProducts
                .where((product) => product.brandId == event.brandId)
                .toList();
      }

      if (event.categoryId != null && event.categoryId!.isNotEmpty) {
        filteredProducts =
            filteredProducts
                .where((product) => product.categoryId == event.categoryId)
                .toList();
      }

      if (event.minPrice != null && event.minPrice! > 0) {
        filteredProducts =
            filteredProducts
                .where(
                  (product) =>
                      product.discountPrice != null &&
                      product.discountPrice! >= event.minPrice!,
                )
                .toList();
      }

      if (event.maxPrice != null && event.maxPrice! > 0) {
        filteredProducts =
            filteredProducts
                .where(
                  (product) =>
                      product.discountPrice != null &&
                      product.discountPrice! <= event.maxPrice!,
                )
                .toList();
      }

      if (event.color != null && event.color!.isNotEmpty) {
        filteredProducts =
            filteredProducts
                .where((product) => product.colors.contains(event.color))
                .toList();
      }

      if (event.size != null && event.size!.isNotEmpty) {
        filteredProducts =
            filteredProducts
                .where((product) => product.sizes.contains(event.size))
                .toList();
      }

      emit(
        ProductLoaded(
          data: filteredProducts,
          favorites: currentState.favorites,
        ),
      );
    }
  }
}
