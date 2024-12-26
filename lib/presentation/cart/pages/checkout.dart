import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/common/bloc/button/button_state_cubit.dart';
import 'package:pharmacyapp/common/helper/cart/cart.dart';
import 'package:pharmacyapp/common/helper/navigator/app_navigator.dart';
import 'package:pharmacyapp/common/widgets/appbar/app_bar.dart';
import 'package:pharmacyapp/common/widgets/button/basic_reactive_button.dart';
import 'package:pharmacyapp/data/order/models/order_registration_req.dart';
import 'package:pharmacyapp/domain/order/entities/order_status.dart';
import 'package:pharmacyapp/domain/order/usecases/order_registration.dart';
import 'package:pharmacyapp/presentation/cart/pages/order_placed.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../domain/order/entities/product_ordered.dart';
import 'package:pharmacyapp/common/helper/receipt/receipt_generator.dart';
import 'package:pharmacyapp/common/helper/email/email_sender.dart';

class CheckOutPage extends StatelessWidget {
  final List<ProductOrderedEntity> products;

  const CheckOutPage({required this.products, super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController addressCon =
        TextEditingController(); // Pindahkan ke dalam build

    return Scaffold(
      appBar: const BasicAppbar(
        title: Text('Checkout'),
      ),
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) async {
            if (state is ButtonSuccessState) {
              try {
                final orderCode = _generateOrderCode();
                final createdDate = DateTime.now().toString();
                final totalPrice =
                    CartHelper.calculateCartSubtotal(products) + 0.05 + 0.01;
                final shippingAddress = addressCon.text;

                final receiptFile = await ReceiptGenerator.generateReceipt(
                  orderCode: orderCode,
                  createdDate: createdDate,
                  products: products,
                  totalPrice: totalPrice,
                  shippingAddress: shippingAddress,
                );

                await showDialog(
                  context: context,
                  builder: (contextDialog) {
                    String recipientEmail = '';
                    return AlertDialog(
                      title: const Text('Bukti Bayar'),
                      content: SingleChildScrollView(
                        // Agar struk bisa di-scroll jika panjang
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Kode Order: $orderCode'),
                            Text('Tanggal: $createdDate'),
                            Text('Alamat Pengiriman: $shippingAddress'),
                            const Divider(),
                            Column(
                              // Daftar Produk
                              children: products
                                  .map((product) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(product.productTitle),
                                          Text(
                                              '\$${product.productPrice} x ${product.productQuantity}'),
                                        ],
                                      ))
                                  .toList(),
                            ),
                            const Divider(),
                            Text('Ongkir: \$0.05'),
                            Text('Pajak \$0.01'),
                            Text('Total: \$$totalPrice',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Receipt saved at ${receiptFile.path}')),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Download'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'Masukkan Email Tujuan',
                            ),
                            onChanged: (value) {
                              recipientEmail = value;
                            },
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (recipientEmail.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Email tujuan harus diisi')),
                              );
                              return;
                            }

                            try {
                              await EmailSender.sendEmailWithAttachment(
                                toEmail:
                                    recipientEmail, // Gunakan email dari input
                                subject: 'Bukti Bayar Anda',
                                body:
                                    'Terima kasih atas pembelian Anda. Berikut adalah bukti bayar Anda.',
                                attachmentPath: receiptFile.path,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Email berhasil dikirim')),
                              );
                              Navigator.pop(contextDialog);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Gagal mengirim email: $e')),
                              );
                            }
                          },
                          child: const Text('Kirim via Email'),
                        ),
                        TextButton(
                          // Tombol untuk menutup preview
                          onPressed: () {
                            Navigator.pop(contextDialog);
                            AppNavigator.pushAndRemove(context,
                                const OrderPlacedPage()); // Close dialog preview
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );

                AppNavigator.pushAndRemove(context, const OrderPlacedPage());
              } catch (e) {
                print('Error during order processing: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order processing failed: $e')),
                );
              }
            }

            if (state is ButtonFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Builder(
              builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextField(
                      // Gunakan addressCon yang dideklarasikan di build
                      controller: addressCon,
                      minLines: 2,
                      maxLines: 4,
                      decoration:
                          const InputDecoration(hintText: 'Shipping Address'),
                    ),
                    BasicReactiveButton(
                      content: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${CartHelper.calculateCartSubtotal(products) + 0.05 + 0.01}',
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
                            createdDate: Timestamp.fromDate(DateTime.now()),
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
                                shippingAddress: addressCon.text,
                              ),
                            );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _generateOrderCode() {
    final random = Random();
    final code = List.generate(6, (index) => random.nextInt(10)).join();
    return '$code';
  }
}
