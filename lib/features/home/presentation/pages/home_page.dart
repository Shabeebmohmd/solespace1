import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/auth/auth_event.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/auth/auth_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2; // Start with center item selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.pushReplacementNamed(context, AppRouter.login);
          }
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildBrandsList(),
              _buildPopularShoes(),
              _buildNewArrivals(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Store location',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.red, size: 16),
                    Text(
                      'Mondolibug, Sylhet',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Badge(
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Log out'),
                      content: const Text('Are you sure you want to log out.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(SignOut());
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Looking for shoes',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: const Icon(Icons.tune),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildBrandsList() {
    final brands = [
      {'name': 'Nike', 'logo': 'assets/images/nike.png', 'isSelected': true},
      {'name': 'Puma', 'logo': 'assets/images/puma.png', 'isSelected': false},
      {'name': 'UA', 'logo': 'assets/images/ua.png', 'isSelected': false},
      {
        'name': 'Adidas',
        'logo': 'assets/images/adidas.png',
        'isSelected': false,
      },
      {
        'name': 'Converse',
        'logo': 'assets/images/converse.png',
        'isSelected': false,
      },
    ];

    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final brand = brands[index];
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color:
                  brand['isSelected'] == true
                      ? Colors.blue[100]
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                brand['name'] as String,
                style: TextStyle(
                  color:
                      brand['isSelected'] == true ? Colors.blue : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularShoes() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Shoes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: () {}, child: const Text('See all')),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildShoeCard(
                'Nike Jordan',
                '\$493.00',
                'assets/images/jordan.png',
                'BEST SELLER',
              ),
              _buildShoeCard(
                'Nike Air Max',
                '\$897.99',
                'assets/images/airmax.png',
                'BEST SELLER',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewArrivals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'New Arrivals',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: () {}, child: const Text('See all')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildNewArrivalCard(
            'Nike Air Jordan',
            '\$849.69',
            'assets/images/airmax.png',
            'BEST CHOICE',
          ),
        ),
      ],
    );
  }

  Widget _buildShoeCard(String name, String price, String image, String tag) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tag, style: TextStyle(color: Colors.blue[300], fontSize: 12)),
          Expanded(
            child: Center(child: Image.asset(image, fit: BoxFit.contain)),
          ),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewArrivalCard(
    String name,
    String price,
    String image,
    String tag,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tag,
                style: TextStyle(color: Colors.blue[300], fontSize: 12),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Image.asset(image, height: 100, fit: BoxFit.contain),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: Theme.of(context).colorScheme.surface,
      buttonBackgroundColor: Colors.blue,
      height: 60,
      animationDuration: const Duration(milliseconds: 300),
      items: [
        Icon(
          Icons.shopping_bag_outlined,
          color: _selectedIndex == 0 ? Colors.white : Colors.grey,
        ),
        Icon(
          Icons.favorite_border,
          color: _selectedIndex == 1 ? Colors.white : Colors.grey,
        ),
        Icon(
          Icons.home_outlined,
          color: _selectedIndex == 2 ? Colors.white : Colors.grey,
        ),
        Icon(
          Icons.notifications_none_outlined,
          color: _selectedIndex == 3 ? Colors.white : Colors.grey,
        ),
        Icon(
          Icons.person_outline,
          color: _selectedIndex == 4 ? Colors.white : Colors.grey,
        ),
      ],
      index: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        // Handle navigation here
        switch (index) {
          case 0:
            print('Home tapped');
            break;
          case 1:
            print('Favorites tapped');
            break;
          case 2:
            print('Cart tapped');
            break;
          case 3:
            print('Notifications tapped');
            break;
          case 4:
            print('Profile tapped');
            break;
        }
      },
    );
  }
}

              // BlocProvider(
              //   create:
              //       (context) =>
              //           BrandBloc(homeRepository: BrandRepository())
              //             ..add(FetchBrands()),
              //   child: BlocBuilder<BrandBloc, BrandState>(
              //     builder: (context, state) {
              //       if (state is BrandLoading) {
              //         return const Center(child: CircularProgressIndicator());
              //       } else if (state is BrandLoaded) {
              //         return Container(
              //           height: 60,
              //           margin: const EdgeInsets.symmetric(vertical: 16),
              //           child: ListView.builder(
              //             scrollDirection: Axis.horizontal,
              //             itemCount: state.data.length,
              //             itemBuilder: (context, index) {
              //               final brands = state.data[index];
              //               return Material(
              //                 elevation: 3,
              //                 borderRadius: BorderRadius.circular(8),
              //                 child: Container(
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(8),
              //                   ),
              //                   child: Column(
              //                     mainAxisSize:
              //                         MainAxisSize
              //                             .min, // Adjust height based on content
              //                     mainAxisAlignment: MainAxisAlignment.end,
              //                     children: [
              //                       // Add any additional content here if needed
              //                       // Flexible(
              //                       //   child: CircleAvatar(
              //                       //     radius: 60,
              //                       //     backgroundImage: FileImage(
              //                       //       brands['logoImage']??Icon(Icons.image),
              //                       //     ),
              //                       //   ),
              //                       // ),
              //                       SizedBox(height: 8),
              //                       Text(brands['name']),
              //                     ],
              //                   ),
              //                 ),
              //               );
              //             },
              //           ),
              //         );
              //       } else if (state is BrandError) {
              //         return Center(child: Text(state.message));
              //       }
              //       return const Center(child: Text('No data'));
              //       _buildBrandsList();
              //     },
              //   ),
              // ),