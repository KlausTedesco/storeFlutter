import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/models/cart_model.dart';
import 'package:virtual_store/models/user_model.dart';
import 'package:virtual_store/screens/login_screen.dart';
import 'package:virtual_store/tiles/cart_tile.dart';
import 'package:virtual_store/widgets/discount_card.dart';
import 'package:virtual_store/widgets/price_card.dart';
import 'package:virtual_store/widgets/ship_card.dart';

class CartScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model){
                if(UserModel.of(context).isLoggedIn()){
                  int quatityProduct = 0;
                  model.products == null ? quatityProduct = 0 : quatityProduct = model.products.length;
                  return Text(
                    '${quatityProduct ?? 0} ${quatityProduct == 1 ? 'Item' : 'Itens'} ',
                    style: TextStyle(fontSize: 15.0),
                  );
                } else {
                  return Text('');
                }
              }, 
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model){
          if ( model.isLoading && UserModel.of(context).isLoggedIn() ){
            return CircularProgressIndicator();
          } else if ( !UserModel.of(context).isLoggedIn() ){
            return Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.remove_shopping_cart, 
                    size: 80.0, color: Colors.blueAccent
                  ),
                  SizedBox(height: 10.0,),
                  Text("Faça o login para adicionar produtos:",
                    style: TextStyle( fontSize: 20.0, fontWeight: FontWeight.bold ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0,),
                  RaisedButton(
                    child: Text("Login", style: TextStyle( fontSize: 18.0 ),),
                    textColor: Colors.white,
                    color: Colors.blueAccent,    
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen() ) 
                      );
                    },
                  ),
                ],
              ),
            );
          } else if( model.products == null || model.products.length == 0 ){
            return Center(
              child: Text("Nenhum produto no carrinho!", 
                style: TextStyle(
                  fontSize: 20.0, 
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center
              ),
            );
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  children: model.products.map(
                    (product){
                      return CartTile(product);
                    }
                  ).toList(),
                ),
                DiscountCart(),
                ShipCard(),
                PriceCard((){})
              ],
            );
          }
        }
      ),
    );
  }
}