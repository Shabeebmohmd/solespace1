import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/product/product_bloc.dart';
import 'package:sole_space_user1/features/home/widgets/brand_based_product_card.dart';

class BrandBasedProductListPage extends StatelessWidget {
  const BrandBasedProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the brandId from the route arguments
    final String? brandId =
        ModalRoute.of(context)?.settings.arguments as String?;

    if (brandId == null) {
      return Scaffold(
        appBar: CustomAppBar(),
        body: const Center(child: Text('No brand selected')),
      );
    }

    // Trigger the FetchProductsByBrand event
    context.read<ProductBloc>().add(FetchProductsByBrand(brandId: brandId));

    return Scaffold(
      appBar: CustomAppBar(),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final product = state.data[index];
                return BrandBasedProductCard(
                  product: product,
                ); // Create a ProductCard widget
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No products found'));
          }
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
// import 'package:sole_space_user1/core/widgets/shimmer.dart';
// import 'package:sole_space_user1/features/home/models/brand_model.dart';
// import 'package:sole_space_user1/features/home/presentation/blocs/product/product_bloc.dart';

// class BrandBasedProductListPage extends StatelessWidget {
//   final Brand brand;
//   const BrandBasedProductListPage({super.key, required this.brand});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(),
//       body: BlocBuilder<ProductBloc, ProductState>(
//         builder: (context, state) {
//           if (state is ProductLoading) {
//             return ShimmerLoaders.newArrivalsLoader();
//           } else if (state is ProductLoaded) {
//             return ListView.builder(
//               itemCount: state.data.length,
//               itemBuilder: (context, index) {
//                 final brandBasedProducts = state.data.
//                 return ListTile();
//               },
//             );
//           }else if(state is ProductError){
//              return Center(child: Text(state.message));
//           }else{
//             return const SizedBox.shrink();
//           }
//         },
//       ),
//     );
//   }
// }
