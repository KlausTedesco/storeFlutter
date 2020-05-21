import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/datas/cart_product.dart';
import 'package:virtual_store/datas/product_data.dart';

class CartTile extends StatelessWidget {
  
  final CartProduct cartProduct;

  CartTile( this.cartProduct );

  @override
  Widget build(BuildContext context) {

    Widget _buidContent(){
      // dados do cartao
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: cartProduct.productData == null ?
        FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance.collection('products').document(cartProduct.category)
            .collection('itens').document(cartProduct.idProduct).get(),
          builder: (context, snapshot){
            if ( snapshot.hasData ){
              cartProduct.productData = ProductData.fromDocument(snapshot.data);
              _buidContent();
            } else {
              return Container(
                height: 70.0,
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              );
            }
          },
        ) :
        _buidContent()
    );
  }
}