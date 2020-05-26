import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  
  final String orderId;

  OrderTile( this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection('orders').document(orderId).snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            } else {

              int status = snapshot.data['statusOrder'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Código do pedido: ${snapshot.data.documentID}', 
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.0,),
                  Text(_buildProductsText(snapshot.data)),
                  SizedBox(height: 5.0,),
                  Text('Status do pedido: ', 
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.0,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _builderCircle('1', 'Aguardando Pagamento', status, 1),
                        _lineBetweenCircle(),
                        _builderCircle('2', 'Preparando Pedido', status, 2),
                        _lineBetweenCircle(),
                        _builderCircle('3', 'Emissão Nota Fiscal', status, 3),
                        _lineBetweenCircle(),
                        _builderCircle('4', 'Em Transporte', status, 4),
                        _lineBetweenCircle(),
                        _builderCircle('5', 'Entrega Realizada', status, 5),
                      ]
                    )
                  ),
                ],
              );
            }
          }
        ),
      ),
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot){
    String text = 'Descrição: \n';
    for(LinkedHashMap product in snapshot.data['products']){
      text += '${product['quantity']} x ${product['product']['title']} R\$ ${product['product']['price'].toStringAsFixed(2)} \n';
    }
    if(snapshot.data['discount'] != 0 ){
      text += 'Desconto: R\$ ${snapshot.data['discount'].toStringAsFixed(2)} \n';
    }
    if(snapshot.data['shipPrice'] != 0 ){
      text += 'Frete: R\$ ${snapshot.data['shipPrice'].toStringAsFixed(2)} \n';
    }
    text += 'Total: R\$ ${snapshot.data['totalPrice'].toStringAsFixed(2)}';

    return text;
  }

  Widget _builderCircle ( String title, String subTitle, int status, int thisStatus ){
    Color backColor;
    Widget child;

    if(status < thisStatus){
      backColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white));
    } else if (status == thisStatus){
      backColor = Colors.orangeAccent;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white)),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.blueAccent;
      child = Icon(Icons.check, color: Colors.white,);
    }  
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 18.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subTitle, style: TextStyle( fontSize: 12.0),)
      ],
    );
  }

  Widget _lineBetweenCircle(){
    return Container(
      height: 1.0,
      width: 30.0,
      color: Colors.grey[500],
    );
  }

}