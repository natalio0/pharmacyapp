import 'package:pharmacyapp/common/bloc/button/button_state.dart';
import 'package:pharmacyapp/common/bloc/button/button_state_cubit.dart';
import 'package:pharmacyapp/common/helper/product/product_price.dart';
import 'package:pharmacyapp/common/widgets/button/basic_reactive_button.dart';
import 'package:pharmacyapp/data/order/models/add_to_cart_req.dart';
import 'package:pharmacyapp/domain/order/usecases/add_to_cart.dart';
import 'package:pharmacyapp/domain/product/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/presentation/product_detail/bloc/product_quantity_cubit.dart';

class AddToBag extends StatelessWidget {
  final ProductEntity productEntity;

  const AddToBag({required this.productEntity, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ButtonStateCubit, ButtonState>(
      listener: (context, state) {
        if (state is ButtonSuccessState) {
          // Tampilkan SnackBar untuk memberi tahu bahwa item berhasil ditambahkan ke cart
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item berhasil ditambahkan ke Cart'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        if (state is ButtonFailureState) {
          var snackbar = SnackBar(
            content: Text(state.errorMessage),
            behavior: SnackBarBehavior.floating,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BasicReactiveButton(
          onPressed: () {
            // Menambahkan item ke cart
            context.read<ButtonStateCubit>().execute(
                  usecase: AddToCartUseCase(),
                  params: AddToCartReq(
                    productId: productEntity.productId,
                    productTitle: productEntity.title,
                    productQuantity: context.read<ProductQuantityCubit>().state,
                    productPrice: productEntity.price.toDouble(),
                    totalPrice:
                        ProductPriceHelper.provideCurrentPrice(productEntity) *
                            context.read<ProductQuantityCubit>().state,
                    productImage: productEntity.images[0],
                    createdDate: DateTime.now().toString(),
                  ),
                );
          },
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<ProductQuantityCubit, int>(
                builder: (context, state) {
                  var price =
                      ProductPriceHelper.provideCurrentPrice(productEntity) *
                          state;
                  return Text(
                    "\$${price.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14),
                  );
                },
              ),
              const Text(
                'Add to Cart',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
