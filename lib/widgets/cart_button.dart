import 'package:flutter/material.dart';
import 'package:virtual_store/screens/cart_screen.dart';

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>CartScreen() )
        );
      },
      child: Icon(Icons.shopping_cart,
        color: Colors.white,
      ),
      backgroundColor: Colors.blueAccent,
    );
  }
}