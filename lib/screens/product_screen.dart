import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/datas/cart_product.dart';
import 'package:virtual_store/datas/product_data.dart';
import 'package:virtual_store/models/cart_model.dart';
import 'package:virtual_store/models/user_model.dart';
import 'package:virtual_store/screens/cart_screen.dart';
import 'package:virtual_store/screens/login_screen.dart';

class ProductScreen extends StatefulWidget {
  
  final ProductData product;

  ProductScreen(this.product);
  
  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  
  final ProductData product;

  String selectSize;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: product.images.map(
                (url){
                  return NetworkImage(url);
                }
              ).toList(),
              dotSize: 5.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: Colors.blueAccent,
              autoplay: false,
            ),  
          ),
          Padding(
            padding: EdgeInsets.all( 15.0 ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0, 
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0, 
                    color: Colors.blueAccent
                  ),
                ),
                SizedBox(height: 10.0,),
                Text(
                  "Tamanho",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(
                  height: 35.0,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, 
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.5,
                    ),
                    children: product.sizes.map(
                      (size){
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              selectSize = size;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              border: Border.all(
                                color: size == selectSize ? Colors.blueAccent : Colors.grey[500],
                                width: 3.0
                              )
                            ),
                            width: 50.0,
                            alignment: Alignment.center,
                            child: Text(size),
                          ),
                        );
                      }
                    ).toList(),
                  ),
                ),
                SizedBox( height: 10.0,),
                SizedBox(
                  height: 45.0,
                  child: RaisedButton(
                    onPressed: selectSize != null ?
                    (){
                      if( UserModel.of(context).isLoggedIn() ){

                        CartProduct cartProduct = CartProduct();
                        cartProduct.size = selectSize;
                        cartProduct.quantity = 1;
                        cartProduct.idProduct = product.id;
                        cartProduct.category = product.category;

                        CartModel.of(context).addCartItem(cartProduct);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ( context )=> CartScreen()
                          )
                        );

                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ( context )=> LoginScreen()
                          )
                        );
                      } 
                    } : null,
                    child: Text( UserModel.of(context).isLoggedIn() ? 'Adicionar ao Carrinho' : 'Entre para Comprar',
                      style: TextStyle(fontSize: 15.0),
                    ),
                    color: Colors.blueAccent,
                    textColor: Colors.white,        
                  ),
                ),
                SizedBox(height: 10.0,),
                Text(
                  "Descrição:",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          )    
        ],
      ),
    );
  }
}