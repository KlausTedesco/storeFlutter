import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {

  final String orderId;

  OrderScreen (this.orderId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido Realizado'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check,
              color: Colors.blueAccent,
              size: 80.0,
            ),
            Text(
              'Pedido realizado com sucesso!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 30.0),
            Text(
              'Acompanhe seu pedido com o código abaixo', style: TextStyle(fontSize: 15.0),
            ),
            Text(
              'Código do pedido: $orderId', style: TextStyle(fontSize: 16.0),
            )
          ],
        ),
      ),
    );
  }
}
