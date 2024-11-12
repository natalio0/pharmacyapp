import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmacyapp/common/bloc/product/products_display_cubit.dart';
import 'package:pharmacyapp/common/bloc/product/products_display_state.dart';
import 'package:pharmacyapp/common/widgets/product/product_card.dart';
import 'package:pharmacyapp/core/configs/assets/app_vectors.dart';
import 'package:pharmacyapp/core/configs/theme/app_colors.dart';
import 'package:pharmacyapp/domain/order/entities/product_ordered.dart';
import 'package:pharmacyapp/domain/product/entities/product.dart';
import 'package:pharmacyapp/domain/product/usecases/get_favorties_products.dart';
import 'package:pharmacyapp/presentation/cart/bloc/cart_products_display_cubit.dart';
import 'package:pharmacyapp/presentation/cart/bloc/cart_products_display_state.dart';
import 'package:pharmacyapp/presentation/cart/widgets/checkout.dart';
import 'package:pharmacyapp/presentation/cart/widgets/product_ordered_card.dart';
import 'package:pharmacyapp/presentation/home/widgets/categories.dart';
import 'package:pharmacyapp/presentation/home/widgets/header.dart';
import 'package:pharmacyapp/presentation/home/widgets/search_field.dart';
import 'package:pharmacyapp/presentation/home/widgets/top_selling.dart';
import 'package:pharmacyapp/presentation/home/widgets/new_in.dart';
import 'package:pharmacyapp/presentation/settings/widgets/account_tile.dart';
import 'package:pharmacyapp/presentation/settings/widgets/logout_tile.dart';
import 'package:pharmacyapp/presentation/settings/widgets/my_favorties_tile.dart';
import 'package:pharmacyapp/presentation/settings/widgets/my_orders_tile.dart';
import 'package:pharmacyapp/service_locator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var currentIndex = 0;

  final List<Widget> pages = [
    const HomeContent(),
    const CartContent(),
    const FavoriteContent(),
    const AccountContent(),
  ];

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(displayWidth * .05),
        height: displayWidth * .155,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: ListView.builder(
          itemCount: 4, // Adjusted to match the actual number of pages
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              setState(() {
                currentIndex = index;
                HapticFeedback.lightImpact();
              });
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  width: index == currentIndex
                      ? displayWidth * .32
                      : displayWidth * .18,
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    height: index == currentIndex ? displayWidth * .12 : 0,
                    width: index == currentIndex ? displayWidth * .32 : 0,
                    decoration: BoxDecoration(
                      color: index == currentIndex
                          ? AppColors.primary.withOpacity(.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  width: index == currentIndex
                      ? displayWidth * .31
                      : displayWidth * .18,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            width:
                                index == currentIndex ? displayWidth * .13 : 0,
                          ),
                          AnimatedOpacity(
                            opacity: index == currentIndex ? 1 : 0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            child: Text(
                              index == currentIndex ? listOfStrings[index] : '',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            width:
                                index == currentIndex ? displayWidth * .03 : 20,
                          ),
                          Icon(
                            listOfIcons[index],
                            size: displayWidth * .076,
                            color: index == currentIndex
                                ? AppColors.primary
                                : Colors.black26,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.shopping_cart_rounded,
    Icons.favorite_rounded,
    Icons.person_rounded,
  ];

  List<String> listOfStrings = [
    'Home',
    'Cart',
    'Favorite',
    'Account',
  ];
}

// Separate widget for the main home content
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          Header(),
          SizedBox(height: 24),
          SearchField(),
          SizedBox(height: 24),
          Categories(),
          SizedBox(height: 24),
          TopSelling(),
          SizedBox(height: 24),
          NewIn(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class FavoriteContent extends StatelessWidget {
  const FavoriteContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          const SizedBox(height: 50),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'My Favorites',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          BlocProvider(
            create: (context) =>
                ProductsDisplayCubit(useCase: sl<GetFavortiesProductsUseCase>())
                  ..displayProducts(),
            child: BlocBuilder<ProductsDisplayCubit, ProductsDisplayState>(
              builder: (context, state) {
                if (state is ProductsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ProductsLoaded) {
                  return _products(state.products);
                }
                if (state is LoadProductsFailure) {
                  return const Center(
                    child: Text('Please try again'),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _products(List<ProductEntity> products) {
  return Expanded(
    child: GridView.builder(
      itemCount: products.length,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.6),
      itemBuilder: (BuildContext context, int index) {
        return ProductCard(productEntity: products[index]);
      },
    ),
  );
}

class CartContent extends StatelessWidget {
  const CartContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Cart',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: BlocProvider(
              create: (context) =>
                  CartProductsDisplayCubit()..displayCartProducts(),
              child: BlocBuilder<CartProductsDisplayCubit,
                  CartProductsDisplayState>(
                builder: (context, state) {
                  if (state is CartProductsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is CartProductsLoaded) {
                    return state.products.isEmpty
                        ? Center(child: _cartIsEmpty())
                        : Stack(
                            children: [
                              _products(state.products),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Checkout(
                                  products: state.products,
                                ),
                              ),
                            ],
                          );
                  }
                  if (state is LoadCartProductsFailure) {
                    return Center(
                      child: Text(state.errorMessage),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _products(List<ProductOrderedEntity> products) {
    return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return ProductOrderedCard(
            productOrderedEntity: products[index],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
        itemCount: products.length);
  }

  Widget _cartIsEmpty() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(AppVectors.cartBag),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Cart is empty",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        )
      ],
    );
  }
}

class AccountContent extends StatelessWidget {
  const AccountContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                AccountTile(),
                SizedBox(height: 20),
                MyFavortiesTile(),
                SizedBox(height: 20),
                MyOrdersTile(),
                SizedBox(height: 20),
                LogOutTile(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
