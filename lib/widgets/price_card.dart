import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/models/cart_model.dart';

class PriceCard extends StatelessWidget {

  final VoidCallback buy;

  PriceCard( this.buy );

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: ScopedModelDescendant<CartModel>(
          builder: (context, child, model){

            double price = model.getProductsPrice();
            double discount = model.getDiscount();
            double ship = model.getShipPrice();
            double total = model.getTotalPrice();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Resumo do pedido:',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Subtotal'),
                    Text('R\$ ${price.toStringAsFixed(2)}')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Desconto'),
                    Text('R\$ ${discount.toStringAsFixed(2)}')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Frete'),
                    Text('R\$ ${ship.toStringAsFixed(2)}')
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Total',
                      style: TextStyle( fontWeight: FontWeight.bold ),
                    ),
                    Text('R\$ ${total.toStringAsFixed(2)}',
                      style: TextStyle( 
                        fontSize: 15.0, 
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8.0),
                RaisedButton(
                  child: Text('Finalizar Pedido'),
                  textColor: Colors.white,
                  color: Colors.blueAccent,
                  onPressed: buy,
                )
              ],
            );
          }
        ),
      ),
    );
  }
}