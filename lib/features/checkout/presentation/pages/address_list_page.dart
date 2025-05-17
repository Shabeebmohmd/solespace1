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
import 'package:sole_space_user1/features/checkout/presentation/widget/custom_address_card.dart';

class AddressListPage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  AddressListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: Text('Addresses')),
        body: BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) {
            if (state is AddressLoaded && state.addresses.isNotEmpty) {
              return ListView.builder(
                itemCount: state.addresses.length,
                itemBuilder: (context, index) {
                  final addresses = state.addresses[index];
                  return CustomCard(
                    child: _listTileforAddress(addresses, context),
                  );
                },
              );
            } else if (state is AddressLoading) {
              return Center(child: CircularProgressIndicator());
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
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  ListTile _listTileforAddress(AddressModel address, BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: address.isSelected,
        onChanged: (bool? value) {
          if (value == true) {
            context.read<AddressBloc>().add(
              SelectAddress(addressId: address.id),
            );
          }
        },
      ),
      title: Text(
        address.fullName,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(address.address),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              final addressModel = AddressModel(
                address: address.address,
                city: address.city,
                fullName: address.fullName,
                id: address.id,
                phoneNumber: address.phoneNumber,
                postalCode: address.postalCode,
                state: address.state,
                isSelected: address.isSelected,
              );
              context.read<AddressBloc>().add(
                UpdateAddress(userId: user!.uid, address: addressModel),
              );
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              context.read<AddressBloc>().add(
                DeleteAddress(userId: user!.uid, addressId: address.id),
              );
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
