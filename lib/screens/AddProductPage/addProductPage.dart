import 'dart:convert';
import 'dart:io';

import 'package:bakirdal_final/models/category.dart';
import 'package:bakirdal_final/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  List<Product> products = [];
  List<Category> categories = [];

  bool loading = false;

  int id;
  int categoryId;
  String name;
  String price;
  String img;

  Category currentCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Ürün Ekle"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchDatas(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Text(
                    "Ürün Ekle",
                    style: TextStyle(fontSize: 30, color: Colors.grey.shade800, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Ürün ID
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: "Ürün ID'si : ${products.length +3}",
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Ürün ID',
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        // Ürün Adı
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            validator: (value) {
                              if (value.length > 0) {
                                return null;
                              } else {
                                return "Geçerli İsim Giriniz";
                              }
                            },
                            onSaved: (value) {
                              name = value;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange, width: 1),
                                ),
                                hintText: 'Ürün Adı',
                                labelText: "Ürün Adı"),
                          ),
                        ),
                        SizedBox(height: 10),
                        // Fiyatı
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.length > 0) {
                                return null;
                              } else {
                                return "Geçerli Fiyat Giriniz";
                              }
                            },
                            onSaved: (value) {
                              price = value;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange, width: 1),
                                ),
                                hintText: 'Ürün Fiyatı',
                                labelText: "Ürün Fiyatı"),
                          ),
                        ),
                        SizedBox(height: 10),
                        // Kategori
                        if (categories.isNotEmpty)
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Card(
                                color: Colors.grey.shade300,
                                child: ListTile(
                                  title: Text("Kategori Seç"),
                                  subtitle: currentCategory==null ?Text("Kategori Seç"):Text(currentCategory.categoryName),
                                  onTap: (){
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: false, // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Kategori Seç'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: List.generate(categories.length, (index){
                                                return ListTile(
                                                  title: Text(categories[index].categoryName),
                                                  onTap: (){
                                                    setState(() {
                                                      currentCategory = categories[index];
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                );
                                              })
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              )
                          ),
                        SizedBox(height: 10),
                        // Ürün Görseli
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            initialValue: "https://via.placeholder.com/600x800",
                            validator: (value) {
                              if (value.length > 0) {
                                return null;
                              } else {
                                return "Geçerli Börsel bağlantısı Giriniz";
                              }
                            },
                            onSaved: (value) {
                              img = value;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange, width: 1),
                                ),
                                hintText: 'Ürünün Görsel Bağlatısı',
                                labelText: 'Ürünün Görsel Bağlatısı'),
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async{
                            if(loading){
                              return;
                            }
                            await addProduct();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                            child: loading ? CircularProgressIndicator() :Text("Ürün Ekle"),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 100),

                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<void> addProduct()async{
      if(currentCategory != null){
        if(_formKey.currentState.validate()){
          setState(() {
            loading = true;
          });
          _formKey.currentState.save();
          id = products.length + 3;
          categoryId = currentCategory.id;


          Map<String,dynamic> myProduct =  {
            "id":id,
            "categoryId": categoryId,
            "name": name,
            "price": price,
            "img": img
          };


          var productUrl = Uri.parse("http://10.0.2.2:3000/products");
          var responseProduct = await http.post(
              productUrl,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(myProduct)
          );

          setState(() {
            loading = false;
          });
          Navigator.of(context).pop();
        }
      }else{
        SnackBar snackbar = SnackBar(
          content: Text("Kategori Seçmedin !"),
          backgroundColor: Colors.redAccent,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }

  }

  Future<bool> fetchDatas() async {
    try {

       products = [];
       categories = [];

      // localhost yerine ip adresi(10.0.2.2) kullandım
      var productUrl = Uri.parse("http://10.0.2.2:3000/products");
      var categoriesUrl = Uri.parse("http://10.0.2.2:3000/categories");

      var responseProduct = await http.get(productUrl);
      var responseCategories = await http.get(categoriesUrl);

      if (responseProduct.statusCode == HttpStatus.ok && responseCategories.statusCode == HttpStatus.ok) {
        List productBody = jsonDecode(responseProduct.body);
        List categoriesBody = jsonDecode(responseCategories.body);

        productBody.forEach((productJson) {
          products.add(Product.fromJson(productJson));
        });


        categoriesBody.forEach((categoryJson) {
          categories.add(Category.fromJson(categoryJson));
        });
      }
      return true;
    } catch (e) {
      print("Error AddProductPage : " + e.toString());
      return false;
    }
  }
}
