import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sole_space_user1/firebase_options.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/config/theme/app_theme.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:sole_space_user1/features/auth/data/repositories/auth_repository.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/password/password_bloc.dart';
import 'package:sole_space_user1/features/checkout/data/repository/address_repo.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_bloc.dart';
import 'package:sole_space_user1/features/home/data/brand_repository.dart';
import 'package:sole_space_user1/features/home/data/cart_repository.dart';
import 'package:sole_space_user1/features/home/data/category_repsitory.dart';
import 'package:sole_space_user1/features/home/data/product_repsotory.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/bottom/bottom_navigation_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/brand/brand_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/cart/cart_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/category/category_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/product/product_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/theme/theme_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/profile/profile_bloc.dart';
import 'package:sole_space_user1/core/config/cloudinary_config.dart';
import 'package:sole_space_user1/features/checkout/data/services/payment_service.dart';
import 'package:sole_space_user1/core/constants/stripe_constants.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/payment/payment_bloc.dart';
import 'package:sole_space_user1/features/orders/data/order_repository.dart';
import 'package:sole_space_user1/features/orders/presentation/blocs/order/order_bloc.dart';
import 'package:sole_space_user1/features/orders/presentation/blocs/order/order_event.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Stripe
    final paymentService = PaymentService();
    await paymentService.initializeStripe(StripeConstants.publishableKey);

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    runApp(const MyApp());
  }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => BrandRepository()),
        RepositoryProvider(create: (context) => CategoryRepsitory()),
        RepositoryProvider(create: (context) => ProductRepsitory()),
        RepositoryProvider(create: (context) => AddressRepository()),
        RepositoryProvider(create: (context) => CartRepository()),
        RepositoryProvider(create: (context) => OrderRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) =>
                    AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(create: (context) => PasswordBloc()),
          BlocProvider(
            create:
                (context) =>
                    BrandBloc(brandRepository: context.read<BrandRepository>())
                      ..add(FetchBrands()),
          ),
          BlocProvider(
            create:
                (context) => CategoryBloc(
                  categoryRepsitory: context.read<CategoryRepsitory>(),
                )..add(FetchCategory()),
          ),
          BlocProvider(
            create:
                (context) => ProductBloc(
                  productRepsitory: context.read<ProductRepsitory>(),
                )..add(FetchProducts()),
          ),
          BlocProvider(create: (context) => BottomNavigationBloc()),
          BlocProvider(
            create:
                (context) =>
                    CartBloc(cartRepository: context.read<CartRepository>())
                      ..add(LoadCart()),
          ),
          BlocProvider(
            create:
                (context) => AddressBloc(
                  addressRepository: context.read<AddressRepository>(),
                ),
          ),
          BlocProvider(create: (context) => ThemeBloc()),
          BlocProvider(
            create:
                (context) => ProfileBloc(
                  authRepository: context.read<AuthRepository>(),
                  cloudinary: CloudinaryConfig.cloudinary,
                  imagePicker: ImagePicker(),
                )..add(LoadProfile()),
          ),
          BlocProvider(create: (context) => PaymentBloc(PaymentService())),
          BlocProvider(
            create:
                (context) =>
                    OrderBloc(context.read<OrderRepository>())
                      ..add(LoadOrders()),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Sole Space',
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode:
                  state is ThemeInitial ? state.themeMode : ThemeMode.dark,
              onGenerateRoute: AppRouter.onGenerateRoute,
              initialRoute: AppRouter.splash,
            );
          },
        ),
      ),
    );
  }
}
