import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacyapp/core/configs/theme/app_colors.dart';
import 'package:pharmacyapp/core/configs/widget/support_widget.dart';
import 'package:pharmacyapp/services/database.dart';
import 'package:random_string/random_string.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  TextEditingController namecontroller = TextEditingController();

  Future<void> getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

uploadItem() async {
  if(selectedImage!=null &&namecontroller.text!=""){
    String addId= randomAlphaNumeric(10);
    Reference firebaseStorageRef= FirebaseStorage.instance.ref().child("blogImage").child(addId);

    final UploadTask task= firebaseStorageRef.putFile(selectedImage!);
    var downloadUrl= await (await task).ref.getDownloadURL();

    Map<String, dynamic> addProduct={
      "Nama": namecontroller.text,
      "Gambar": downloadUrl,

    };
    await DatabaseMethods().addProduct(addProduct, value!).then((value) {
      selectedImage=null;
      namecontroller.text="";
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text("Produk berhasil di upload!", style: TextStyle(fontSize: 20.0),)));
  });
  }
}
  String? value;
  final List<String> categoryitem = ['Alat Kesehatan', 'Vitamin', 'Herbal'];

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
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Upload foto Produk",
              style: AppWidget.lightTextFieldStyle(),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Center(
              child: GestureDetector(
                onTap: getImage,
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: selectedImage != null
                      ? Image.file(selectedImage!)
                      : const Icon(Icons.camera_alt_outlined),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              "Nama Produk",
              style: AppWidget.lightTextFieldStyle(),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0xFFececf8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: namecontroller,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              "Produk Kategori",
              style: AppWidget.lightTextFieldStyle(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0xFFececf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  items: categoryitem
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
                    this.value = value;
                  }),
                  dropdownColor: Colors.white,
                  hint: const Text("Pilih Kategori"),
                  iconSize: 36,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  value: value,
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  uploadItem();
                },
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
    );
  }
}
