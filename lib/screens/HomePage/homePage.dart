import 'dart:convert';
import 'dart:io';
import 'package:bakirdal_final/Widgets/productWidget.dart';
import 'package:bakirdal_final/models/category.dart';
import 'package:bakirdal_final/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _loading = false;
  List<Product> products = [];
  List<Category> categories = [];
  Category currentCategory;
  List<Product> categoryProducts = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }


  Future<void> fetchData()async{
    try{
      setState(() {
        _loading = true;
      });

      // localhost yerine ip adresi(10.0.2.2) kullandım
      var productUrl = Uri.parse("http://10.0.2.2:3000/products");
      var categoriesUrl = Uri.parse("http://10.0.2.2:3000/categories");

      var responseProduct = await http.get(productUrl);
      var responseCategories = await http.get(categoriesUrl);

      if(responseProduct.statusCode == HttpStatus.ok && responseCategories.statusCode == HttpStatus.ok){

        List productBody = jsonDecode(responseProduct.body);
        List categoriesBody = jsonDecode(responseCategories.body);

        products = [];
        categories = [];

        productBody.forEach((productJson) {
          products.add(Product.fromJson(productJson));
        });

        categoriesBody.forEach((categoryJson) {
          categories.add(Category.fromJson(categoryJson));
        });

        categoryProducts = products;

      }

    }catch(e){
      print("ERROR HomePage : "+e.toString());
      print(e);
    }finally{
      setState(() {
        _loading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    if(!_loading){
      return Column(
        children: [
          // Kategoriler
          Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: ListView.builder(
                itemCount: categories.length+1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,i){
                  if(i==0) {
                    return GestureDetector(
                      onTap: (){

                        categoryProducts = products;


                        setState(() {
                          currentCategory = null;
                        });
                      },
                      child: Card(
                        color: Colors.grey.shade600,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Tüm Ürünler",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade200
                            ),
                          ),
                        ),
                      ),
                    );

                  }
                  return GestureDetector(
                    onTap: (){

                      currentCategory = categories[i-1];

                      if(currentCategory != null) {
                        categoryProducts = [];

                        products.forEach((product) {
                          if (product.categoryId == currentCategory.id) {
                            categoryProducts.add(product);
                          }
                        });
                      }
                      setState(() {});
                    },
                    child: Card(
                      color: Colors.grey.shade600,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            categories[i-1].categoryName,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade200
                          ),
                        ),
                      ),
                    ),
                  );
                },
            ),
          ),
          SizedBox(height: 10),
          Text(
              currentCategory==null?"Tüm Ürünler":"${currentCategory.categoryName}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async{
                await Future.delayed(Duration(seconds: 1));
                setState(() {
                  fetchData();
                });
              },
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3/5,
                children: List.generate(categoryProducts.length, (index){
                  return ProductWidget(categoryProducts[index]);
                }),
              ),
            ),
          )
        ],
      );
    }else{
      // Veriler Gelene Kadar CircularProgressIndicator Göster
      return Center(
        child: CircularProgressIndicator(),
      );
    }

  }
}
