import 'package:bakirdal_final/models/product.dart';
import 'package:bakirdal_final/screens/ProductDetails/productDetailPage.dart';
import 'package:flutter/material.dart';

class ProductWidget extends StatefulWidget {

  Product product;


  ProductWidget(this.product);

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
       Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>ProductDetails(widget.product))
        );

      },
      child: Card(
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Hero(
                tag: widget.product.img.toString(),
                child: Container(
                  child: Image.network(
                      widget.product.img,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                        widget.product.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                        widget.product.price + " TL",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange
                      ),
                    )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
