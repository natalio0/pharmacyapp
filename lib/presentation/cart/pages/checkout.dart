import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmacyapp/common/bloc/button/button_state_cubit.dart';
import 'package:pharmacyapp/common/helper/cart/cart.dart';
import 'package:pharmacyapp/common/widgets/button/basic_reactive_button.dart';
import 'package:pharmacyapp/data/order/models/order_registration_req.dart';
import 'package:pharmacyapp/domain/order/entities/order_status.dart';
import 'package:pharmacyapp/domain/order/usecases/order_registration.dart';
import 'package:pharmacyapp/presentation/cart/pages/order_placed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/helper/navigator/app_navigator.dart';
import '../../../common/widgets/appbar/app_bar.dart';
import '../../../domain/order/entities/product_ordered.dart';

class CheckOutPage extends StatelessWidget {
  final List<ProductOrderedEntity> products;
  CheckOutPage({required this.products, super.key});

  final TextEditingController _addressCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        title: Text('Checkout'),
      ),
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonSuccessState) {
              AppNavigator.pushAndRemove(context, const OrderPlacedPage());
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
            child: Builder(builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _addressField(context),
                  BasicReactiveButton(
                      content: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${CartHelper.calculateCartSubtotal(products)}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const Text(
                              'Place Order',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      onPressed: () {
                        String orderCode = _generateOrderCode();
                        List<OrderStatusEntity> orderStatus = [
                          OrderStatusEntity(
                            title: 'Order Placed',
                            done: true,
                            createdDate: Timestamp.fromDate(
                                DateTime.now()), // Use createdDate here
                          )
                        ];
                        context.read<ButtonStateCubit>().execute(
                            usecase: OrderRegistrationUseCase(),
                            params: OrderRegistrationReq(
                              code: orderCode,
                              orderStatus: orderStatus,
                              products: products,
                              createdDate: DateTime.now().toString(),
                              itemCount: products.length,
                              totalPrice:
                                  CartHelper.calculateCartSubtotal(products),
                              shippingAddress: _addressCon.text,
                            ));
                      })
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _addressField(BuildContext context) {
    return TextField(
      controller: _addressCon,
      minLines: 2,
      maxLines: 4,
      decoration: const InputDecoration(hintText: 'Shipping Address'),
    );
  }
}

String _generateOrderCode() {
  final random = Random();
  final code = List.generate(6, (index) => random.nextInt(10)).join();
  return '-$code';
}
