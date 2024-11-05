import 'package:flutter/material.dart';
import 'package:pharmacyapp/core/configs/widget/support_widget.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        title: Text("Add Product", style: AppWidget.semiboldTextFeildStyle(),),),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Text("Upload foto Produk", style: AppWidget.lightTextFieldStyle(),),
        SizedBox(height: 20.0,),
        Center(
          child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.5), borderRadius: BorderRadius.circular(20)
            ),
         child: Icon(Icons.camera_alt_outlined), 
         ),
        ),      
        SizedBox(height: 20.0,),
        Text(
          "Nama Produk",
           style: AppWidget.lightTextFieldStyle(),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Color(0xFFececf8)),
            child: TextField(
              decoration: InputDecoration(border: InputBorder.none),
            ),
          )
        ],
      ),
    ),
  );
  }
}