import 'package:flutter/material.dart';
import 'package:sole_space_user1/features/home/presentation/pages/product%20related/search_results_page.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchResultsPage(initialQuery: ''),
            ),
          );
        },
        readOnly: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Looking for shoes',
          hintStyle: const TextStyle(color: Colors.black),
          prefixIcon: const Icon(Icons.search, color: Colors.black),
          suffixIcon: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => const SearchResultsPage(initialQuery: ''),
                ),
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
