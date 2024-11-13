import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacyapp/core/configs/theme/app_colors.dart';
import 'package:pharmacyapp/core/configs/widget/support_widget.dart';
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController discountedPriceController = TextEditingController();
  TextEditingController salesNumberController = TextEditingController();

  String? selectedCategory;
  final List<String> categoryItems = ['Alat Kesehatan', 'Vitamin', 'Herbal'];

  Future<void> getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> uploadItem() async {
    if (selectedImage != null && nameController.text.isNotEmpty) {
      String productId = randomAlphaNumeric(10);

      // Prepare product data map for Firestore
      Map<String, dynamic> productData = {
        "categoryId": selectedCategory,
        "createdDate": FieldValue.serverTimestamp(),
        "discountedPrice": num.tryParse(discountedPriceController.text) ?? 0,
        "images": "Products/Images/$productId.jpg",
        "price": num.tryParse(priceController.text) ?? 0,
        "productId": productId,
        "descriptions": detailController.text,
        "salesNumber": int.tryParse(salesNumberController.text) ?? 0,
        "title": nameController.text,
      };

      // Save to the 'Products' collection directly
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(productId)
          .set(productData)
          .then((_) {
        clearForm();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: AppColors.primary,
          content: Text(
            "Produk berhasil di-upload!",
            style: TextStyle(fontSize: 20.0),
          ),
        ));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Upload gagal: $error",
            style: const TextStyle(fontSize: 18.0),
          ),
        ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Pilih gambar dan masukkan nama produk!"),
      ));
    }
  }

  void clearForm() {
    selectedImage = null;
    nameController.clear();
    priceController.clear();
    detailController.clear();
    discountedPriceController.clear();
    salesNumberController.clear();
    setState(() {
      selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        title: Text(
          "Add Product",
          style: AppWidget.semiboldTextFeildStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Upload foto Produk",
                  style: AppWidget.lightTextFieldStyle()),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: getImage,
                child: Center(
                  child: selectedImage == null
                      ? Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.camera_alt_outlined),
                        )
                      : Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child:
                                Image.file(selectedImage!, fit: BoxFit.cover),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20.0),
              buildTextField("Nama Produk", nameController),
              buildTextField("Harga Produk", priceController),
              buildTextField("Detail Produk", detailController, maxLines: 6),
              buildTextField("Harga Diskon", discountedPriceController),
              buildTextField("Jumlah Penjualan", salesNumberController),
              Text("Produk Kategori", style: AppWidget.lightTextFieldStyle()),
              buildDropdown(),
              const SizedBox(height: 30.0),
              Center(
                child: ElevatedButton(
                  onPressed: uploadItem,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text(
                    "Tambah Produk",
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppWidget.lightTextFieldStyle()),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: const Color(0xFFececf8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }

  Widget buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xFFececf8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          items: categoryItems
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: AppWidget.semiboldTextFeildStyle(),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() {
            selectedCategory = value;
          }),
          dropdownColor: Colors.white,
          hint: const Text("Pilih Kategori"),
          iconSize: 36,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          value: selectedCategory,
        ),
      ),
    );
  }
}
