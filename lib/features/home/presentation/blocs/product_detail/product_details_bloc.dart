import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc() : super(const ProductDetailsState()) {
    on<SelectSize>((event, emit) {
      emit(state.copyWith(selectedSize: event.size));
    });

    on<SelectColor>((event, emit) {
      emit(state.copyWith(selectedColor: event.color));
    });

    on<UpdateQuantity>((event, emit) {
      emit(state.copyWith(quantity: event.quantity));
    });
  }
}
