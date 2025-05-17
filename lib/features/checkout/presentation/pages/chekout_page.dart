import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_bloc.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_state.dart';
import 'package:sole_space_user1/features/checkout/presentation/widget/custom_address_card.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) {
            if (state is AddressLoaded && state.addresses.isNotEmpty) {
              final selectedAddress = state.addresses.firstWhere(
                (address) => address.isSelected,
                orElse:
                    () =>
                        state
                            .addresses
                            .first, // Fallback to first if none selected
              );
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomCard(
                      child: ListTile(
                        title: Text(selectedAddress.fullName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(selectedAddress.address),
                            Text(selectedAddress.city),
                            Text(selectedAddress.state),
                            Text(selectedAddress.postalCode),
                            Text(selectedAddress.phoneNumber),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.addressList);
                      },
                      child: const Text("Change"),
                    ),
                  ],
                ),
              );
            } else {
              return TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.address);
                },
                child: const Text("Add Address"),
              );
            }
          },
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sole_space_user1/config/routes/app_router.dart';
// import 'package:sole_space_user1/features/home/presentation/blocs/cart/cart_bloc.dart';
// import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_bloc.dart';
// import 'package:sole_space_user1/features/checkout/data/model/address_model.dart';

// class ChekoutPage extends StatelessWidget {
//   const ChekoutPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // // Trigger loading of addresses when the page is built
//     // context.read<AddressBloc>().add(LoadAddress());

//     return Scaffold(
//       appBar: AppBar(title: const Text('Checkout')),
//       body: BlocBuilder<AddressBloc, AddressState>(
//         builder: (context, addressState) {
//           // Determine the address to display
//           String? userAddress;
//           AddressModel? selectedAddress;

//           if (addressState is AddressLoaded &&
//               addressState.address.isNotEmpty) {
//             selectedAddress = addressState.address.first;
//             userAddress =
//                 selectedAddress.addressLine; // Uses getter from AddressModel
//           } else if (addressState is AddressError) {
//             userAddress = 'Error: ${addressState.message}';
//           } else if (addressState is AddressLoading) {
//             userAddress = 'Loading address...';
//           } else {
//             userAddress = null; // No address found
//           }

//           return BlocBuilder<CartBloc, CartState>(
//             builder: (context, cartState) {
//               if (cartState is CartLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (cartState is CartLoaded) {
//                 final cartItems = cartState.cartItems;
//                 final shipping = 49.0;
//                 final total = context.read<CartBloc>().calculateTotal(
//                   cartItems,
//                   shipping,
//                 );

//                 return ListView(
//                   padding: const EdgeInsets.all(16),
//                   children: [
//                     // Address Section
//                     Card(
//                       child: ListTile(
//                         title: Text(userAddress ?? 'No address found'),
//                         subtitle:
//                             addressState is AddressLoading
//                                 ? const Text('Loading...')
//                                 : addressState is AddressError
//                                 ? Text('Error: ${addressState.message}')
//                                 : null,
//                         trailing: ElevatedButton(
//                           onPressed: () {
//                             Navigator.pushNamed(context, AppRouter.address);
//                           },
//                           child: Text(
//                             userAddress == null ? 'Add Address' : 'Change',
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     // Cart Items
//                     ...cartItems.map(
//                       (item) => ListTile(
//                         leading: Image.network(
//                           item.imageUrl,
//                           width: 50,
//                           height: 50,
//                           fit: BoxFit.cover,
//                         ),
//                         title: Text(item.name),
//                         subtitle: Text('Qty: ${item.quantity}'),
//                         trailing: Text('\$${item.price.toStringAsFixed(2)}'),
//                       ),
//                     ),
//                     const Divider(),
//                     // Payment Summary
//                     ListTile(
//                       title: const Text('Subtotal'),
//                       trailing: Text('\$${total.toStringAsFixed(2)}'),
//                     ),
//                     ListTile(
//                       title: const Text('Shipping'),
//                       trailing: Text('\$${shipping.toStringAsFixed(2)}'),
//                     ),
//                     ListTile(
//                       title: const Text(
//                         'Total',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       trailing: Text(
//                         '\$${total.toStringAsFixed(2)}',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     // Place Order Button
//                     ElevatedButton(
//                       onPressed:
//                           userAddress == null ||
//                                   addressState is AddressLoading ||
//                                   addressState is AddressError
//                               ? null
//                               : () {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                       'Order placed for delivery to ${selectedAddress?.addressLine}',
//                                     ),
//                                   ),
//                                 );
//                               },
//                       child: const Text('Place Order'),
//                     ),
//                   ],
//                 );
//               }
//               return const Center(child: Text('Cart is empty'));
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sole_space_user1/config/routes/app_router.dart';
// import 'package:sole_space_user1/features/home/presentation/blocs/cart/cart_bloc.dart';
// import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_bloc.dart';
// import 'package:sole_space_user1/features/checkout/data/model/address_model.dart';

// class ChekoutPage extends StatelessWidget {
//   const ChekoutPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Trigger loading of addresses when the page is built
//     context.read<AddressBloc>().add(LoadAddress());

//     return Scaffold(
//       appBar: AppBar(title: const Text('Checkout')),
//       body: BlocBuilder<AddressBloc, AddressState>(
//         builder: (context, addressState) {
//           // Determine the address to display
//           String? userAddress;
//           AddressModel? selectedAddress;

//           if (addressState is AddressLoaded &&
//               addressState.address.isNotEmpty) {
//             selectedAddress =
//                 addressState.address.first; // Use the first address
//             userAddress =
//                 selectedAddress
//                     .addressLine; // Assuming AddressModel has a fullAddress field
//           } else if (addressState is AddressError) {
//             userAddress = 'Error: ${addressState.message}';
//           } else {
//             userAddress = null; // No address found
//           }

//           return BlocBuilder<CartBloc, CartState>(
//             builder: (context, cartState) {
//               if (cartState is CartLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (cartState is CartLoaded) {
//                 final cartItems = cartState.cartItems;
//                 final shipping = 49.0;
//                 final total = context.read<CartBloc>().calculateTotal(
//                   cartItems,
//                   shipping,
//                 );

//                 return ListView(
//                   padding: const EdgeInsets.all(16),
//                   children: [
//                     // Address Section
//                     Card(
//                       child: ListTile(
//                         title: Text(userAddress ?? 'No address found'),
//                         subtitle:
//                             addressState is AddressLoading
//                                 ? const Text('Loading...')
//                                 : null,
//                         trailing: ElevatedButton(
//                           onPressed: () {
//                             // Navigate to AddAddressPage
//                             Navigator.pushNamed(context, AppRouter.address);
//                           },
//                           child: Text(
//                             userAddress == null ? 'Add Address' : 'Change',
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     // Cart Items
//                     ...cartItems.map(
//                       (item) => ListTile(
//                         leading: Image.network(
//                           item.imageUrl,
//                           width: 50,
//                           height: 50,
//                           fit: BoxFit.cover,
//                         ),
//                         title: Text(item.name),
//                         subtitle: Text('Qty: ${item.quantity}'),
//                         trailing: Text('\$${item.price.toStringAsFixed(2)}'),
//                       ),
//                     ),
//                     const Divider(),
//                     // Payment Summary
//                     ListTile(
//                       title: const Text('Subtotal'),
//                       trailing: Text('\$${total.toStringAsFixed(2)}'),
//                     ),
//                     ListTile(
//                       title: const Text('Shipping'),
//                       trailing: Text('\$${shipping.toStringAsFixed(2)}'),
//                     ),
//                     ListTile(
//                       title: const Text(
//                         'Total',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       trailing: Text(
//                         '\$${total.toStringAsFixed(2)}',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     // Place Order Button
//                     ElevatedButton(
//                       onPressed:
//                           userAddress == null
//                               ? null
//                               : () {
//                                 // Place order logic here, possibly using selectedAddress
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                       'Order placed for delivery to ${selectedAddress?.addressLine}',
//                                     ),
//                                   ),
//                                 );
//                               },
//                       child: const Text('Place Order'),
//                     ),
//                   ],
//                 );
//               }
//               return const SizedBox();
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sole_space_user1/config/routes/app_router.dart';
// import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_bloc.dart';
// import 'package:sole_space_user1/features/home/presentation/blocs/cart/cart_bloc.dart';

// class ChekoutPage extends StatelessWidget {
//   const ChekoutPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     context.read<AddressBloc>().add(LoadAddress());

//     return Scaffold(
//       appBar: AppBar(title: const Text('Checkout')),
//       body: BlocBuilder<CartBloc, CartState>(
//         builder: (context, state) {
//           if (state is CartLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is CartLoaded) {
//             final cartItems = state.cartItems;
//             final shipping = 49.0;
//             final total = context.read<CartBloc>().calculateTotal(
//               cartItems,
//               shipping,
//             );

//             return ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 // Address Section
//                 Card(
//                   child: ListTile(
//                     title: Text(userAddress ?? 'No address found'),
//                     trailing: ElevatedButton(
//                       onPressed: () {
//                         // Navigate to AddAddressPage if no address
//                         if (userAddress == null) {
//                           Navigator.pushNamed(context, AppRouter.address);
//                         }
//                       },
//                       child: Text(
//                         userAddress == null ? 'Add Address' : 'Change',
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Cart Items
//                 ...cartItems.map(
//                   (item) => ListTile(
//                     leading: Image.network(
//                       item.imageUrl,
//                       width: 50,
//                       height: 50,
//                       fit: BoxFit.cover,
//                     ),
//                     title: Text(item.name),
//                     subtitle: Text('Qty: ${item.quantity}'),
//                     trailing: Text('\$${item.price.toStringAsFixed(2)}'),
//                   ),
//                 ),
//                 const Divider(),
//                 // Payment Summary
//                 ListTile(
//                   title: const Text('Subtotal'),
//                   trailing: Text('\$${total.toStringAsFixed(2)}'),
//                 ),
//                 ListTile(
//                   title: const Text('Shipping'),
//                   trailing: Text('\$${shipping.toStringAsFixed(2)}'),
//                 ),
//                 ListTile(
//                   title: const Text(
//                     'Total',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   trailing: Text(
//                     '\$${total.toStringAsFixed(2)}',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 // Place Order Button
//                 ElevatedButton(
//                   onPressed:
//                       userAddress == null
//                           ? null
//                           : () {
//                             // Place order logic here
//                           },
//                   child: const Text('Place Order'),
//                 ),
//               ],
//             );
//           }
//           return const SizedBox();
//         },
//       ),
//     );
//   }
// }
