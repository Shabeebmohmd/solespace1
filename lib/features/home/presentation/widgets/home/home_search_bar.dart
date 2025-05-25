import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/product/product_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/widgets/home/filter_dialog.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        onChanged: (value) {
          context.read<ProductBloc>().add(SearchProduct(query: value));
        },
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Looking for shoes',
          hintStyle: const TextStyle(color: Colors.black),
          prefixIcon: const Icon(Icons.search, color: Colors.black),
          suffixIcon: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const FilterDialog(),
              );
            },
            icon: const Icon(Icons.tune, color: Colors.black),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
}
