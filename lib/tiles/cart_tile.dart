import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/datas/cart_product.dart';
import 'package:virtual_store/datas/product_data.dart';

class CartTile extends StatelessWidget {
  
  final CartProduct cartProduct;

  CartTile( this.cartProduct );

  Widget _buidContent(){
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          width: 120.0,
          child: Image.network(
            cartProduct.productData.images[0],
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text( cartProduct.productData.title,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text( 'Tamanho: ${cartProduct.size} ', 
                  style: TextStyle( fontWeight: FontWeight.w500 ),
                ),
                Text( 'R\$ ${cartProduct.productData.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold
                  ), 
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.remove), 
                      color: Colors.blueAccent,
                      onPressed: cartProduct.quantity > 1 ? 
                      (){} : null
                    ),
                    Text(cartProduct.quantity.toString()),
                    IconButton(icon: Icon(Icons.add), 
                      color: Colors.blueAccent,
                      onPressed: (){}),
                    FlatButton(
                      child: Text('Remover'),
                      textColor: Colors.grey,
                      onPressed: (){}, 
                    )
                  ],
                ),
              ],
            ),
          )
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: cartProduct.productData == null ?
        FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance.collection('product').document(cartProduct.category)
            .collection('itens').document(cartProduct.idProduct).get(),
          builder: (context, snapshot){
            if ( snapshot.hasData ){
              cartProduct.productData = ProductData.fromDocument(snapshot.data);
              return _buidContent();
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