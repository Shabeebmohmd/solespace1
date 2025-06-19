import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/core/widgets/custom_brand_card.dart';
import 'package:sole_space_user1/core/widgets/shimmer.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/brand/brand_bloc.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb

class BrandSection extends StatelessWidget {
  const BrandSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandBloc, BrandState>(
      builder: (context, state) {
        if (state is BrandLoading) {
          return ShimmerLoaders.brandLoader();
        } else if (state is BrandLoaded) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Popular Brands',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  double itemWidth;
                  double itemHeight;
                  final screenHeight = MediaQuery.of(context).size.height;
                  if (kIsWeb) {
                    itemWidth = constraints.maxWidth * 0.15;
                    itemHeight = screenHeight * 0.30;
                  } else {
                    itemWidth = MediaQuery.of(context).size.width * 0.4;
                    itemHeight = screenHeight * 0.20;
                  }
                  return SizedBox(
                    height: itemHeight,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(width: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.data.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final brands = state.data[index];
                        return InkWell(
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              AppRouter.brandBasedProducts,
                              arguments: brands,
                            );
                            // ignore: use_build_context_synchronously
                            refresh(context);
                          },
                          child: SizedBox(
                            width: itemWidth,
                            child: BrandCard(brand: brands),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          );
        } else if (state is BrandError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
