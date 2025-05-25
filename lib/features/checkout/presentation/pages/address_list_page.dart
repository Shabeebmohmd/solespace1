import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/core/utils/snack_bar_utils.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/features/checkout/data/model/address_model.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_bloc.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_event.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_state.dart';
import 'package:sole_space_user1/features/checkout/presentation/widgets/address/address_list_item.dart';

class AddressListPage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  AddressListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: const Text('Addresses')),
        body: BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) {
            if (state is AddressLoaded && state.addresses.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: state.addresses.length,
                  itemBuilder: (context, index) {
                    final address = state.addresses[index];
                    return AddressListItem(
                      address: address,
                      onEdit: () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.editAddress,
                          arguments: address,
                        );
                      },
                      onDelete: () {
                        context.read<AddressBloc>().add(
                          DeleteAddress(
                            userId: user!.uid,
                            addressId: address.id,
                          ),
                        );
                      },
                      onSelect: (bool? value) {
                        if (value == true) {
                          context.read<AddressBloc>().add(
                            SelectAddress(addressId: address.id),
                          );
                        }
                      },
                    );
                  },
                ),
              );
            } else if (state is AddressLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AddressError) {
              SnackbarUtils.showSnackbar(
                context: context,
                message: state.message,
              );
            }
            return const Center(child: Text('No addresses found.'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.address);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
