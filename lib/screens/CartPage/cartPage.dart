
import 'package:bakirdal_final/DatabaseHelper/databaseHelper.dart';
import 'package:bakirdal_final/models/product.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Map<String,dynamic>>>(
          future: dbHelper.getCartProduct(),
          builder: (context,snapshot){
            if(snapshot.hasData){

              return ListView.separated(
                  itemCount: snapshot.data.length,
                  separatorBuilder: (context,i)=>SizedBox(height: 10),
                  itemBuilder: (context,i){
                    Product currentProduct = Product.fromJson(snapshot.data[i]);
                    return Card(
                      color: Colors.grey.shade200,
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                              "${currentProduct.name}",
                            style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 14
                            ),
                          ),
                          subtitle: Text(
                              "${currentProduct.price} TL",
                            style: TextStyle(
                              color: Colors.deepOrange
                            ),
                          ),
                          leading: Image.network(currentProduct.img),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline,color: Colors.redAccent,),
                            onPressed: ()async{
                              await dbHelper.deleteProductFromCart(currentProduct.id);
                              setState(() {

                              });
                            },
                          ),
                        ),
                      ),
                    );
                  }
              );
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),
    );
  }
}
