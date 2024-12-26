import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../../../domain/order/entities/product_ordered.dart';

class ReceiptGenerator {
  static Future<File> generateReceipt({
    required String orderCode,
    required String createdDate,
    required List<ProductOrderedEntity> products,
    required double totalPrice,
    required String shippingAddress,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Bukti Bayar', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 8),
              pw.Text('Kode Order: $orderCode'),
              pw.Text('Tanggal: $createdDate'),
              pw.Text('Alamat Pengiriman: $shippingAddress'),
              pw.SizedBox(height: 16),
              pw.Text('Produk:', style: pw.TextStyle(fontSize: 18)),
              pw.Table.fromTextArray(
                headers: ['Nama', 'Harga', 'Jumlah', 'Subtotal','ongkir','Pajak'],
                data: products.map((product) {
                  return [
                    product.productTitle,
                    '\$${product.productPrice.toStringAsFixed(2)}',
                    '${product.productQuantity}',
                    '\$${(product.totalPrice * product.productQuantity).toStringAsFixed(2)}',
                    '\$0.05',
                    '\$0.01',
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'Total: \$${totalPrice.toStringAsFixed(2)}',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );

    final outputDir = await getApplicationDocumentsDirectory();
    final file = File('${outputDir.path}/Bukti bayar_$orderCode.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }
}
