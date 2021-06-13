import 'dart:io';

import 'package:bakirdal_final/DatabaseHelper/databaseHelper.dart';
import 'package:bakirdal_final/models/product.dart';
import 'package:bakirdal_final/screens/BottomNavBar/BottomNavBar.dart';
import 'package:bakirdal_final/screens/EditProduct/editProductPage.dart';
import 'package:bakirdal_final/screens/HomePage/homePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductDetails extends StatefulWidget {
  Product product;

  ProductDetails(this.product);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Product product;

  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ürün Detayları"),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>EditProductPage(product))
                );

              },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: ()async{
              var productUrl = Uri.parse("http://10.0.2.2:3000/products/${product.id}");
              var responseProduct = await http.delete(
                  productUrl,
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
              );

              if(responseProduct.statusCode == HttpStatus.ok){
                Navigator.of(context).pop();
                SnackBar success = SnackBar(
                  content: Text("${product.name} Silindi"),
                  backgroundColor: Colors.green,
                );
                ScaffoldMessenger.of(context).showSnackBar(success);
              }else{
                SnackBar error = SnackBar(
                  content: Text("${product.name} Silinirken Hata Oluştu"),
                  backgroundColor: Colors.red,
                );
                ScaffoldMessenger.of(context).showSnackBar(error);
              }

            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 80,
        color: Colors.grey.shade200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.product.price + " TL",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.deepOrange),
            ),
            ElevatedButton(
              onPressed: () async {
                bool result = await addItemToCart(product);
                if (result) {
                  SnackBar success = SnackBar(
                    content: Text("${product.name} Sepete Eklendi"),
                    backgroundColor: Colors.green,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(success);
                }else{
                  SnackBar error = SnackBar(
                    content: Text("Bu Ürün Sepetiniz de Zaten Mevcut"),
                    backgroundColor: Colors.redAccent,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(error);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Sepete Ekle"),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: Hero(
              tag: product.img.toString(),
              child: Center(
                child: Container(
                  child: Image.network(
                    widget.product.img,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    product.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> addItemToCart(Product product) async {
    try {
      DatabaseHelper _databaseHelper = DatabaseHelper();
      await _databaseHelper.addProduct(product);
      return true;
    } catch (e) {
      return false;
    }
  }
}
