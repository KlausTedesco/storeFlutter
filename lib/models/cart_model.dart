import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/datas/cart_product.dart';
import 'package:virtual_store/models/user_model.dart';

class CartModel extends Model {
  UserModel user;

  bool isLoading = false;

  String couponCode;
  int discountPercentage = 0;

  List<CartProduct> products = [];

  CartModel(this.user) {
    if (user.isLoggedIn()) {
      _loadCartItens();
    }
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);

    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.idCart = doc.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.idCart)
        .delete();

    products.remove(cartProduct);

    notifyListeners();
  }

  void decrementProduct(CartProduct cartProduct) {
    cartProduct.quantity--;

    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.idCart)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void incrementProduct(CartProduct cartProduct) {
    cartProduct.quantity++;

    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.idCart)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void _loadCartItens() async {
    QuerySnapshot query = await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .getDocuments();

    products =
        query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrices(){
    notifyListeners();
  }

  double getProductsPrice(){
    double price = 0.0;
    for(CartProduct cart in products){
      if(cart.productData != null){
        price += cart.quantity * cart.productData.price;
      }
    }
    return price;
  }

  double getDiscount(){
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice(){
    return 9.99; 
  }

  double getTotalPrice(){
    double price = getProductsPrice();
    double discount = getDiscount();
    double ship = getShipPrice();
    double total = price - discount + ship;

    return total;
  }

  Future<String> finishOrder() async {
    if(products.length == 0 ) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double discount = getDiscount();
    double shipPrice = getShipPrice();
    double total = getTotalPrice();

    DocumentReference referenceOrder = await Firestore.instance.collection('orders').add(
      {
        'clientId': user.firebaseUser.uid,
        'products': products.map((cartProduct)=>cartProduct.toMap()).toList(),
        'shipPrice': shipPrice,
        'productsPrice': productsPrice,
        'discount': discount,
        'totalPrice': total,
        'statusOrder': 1 // status 1 = Aguardando Pagamento
      }
    );

    await Firestore.instance.collection('users').document(user.firebaseUser.uid)
      .collection('orders').document(referenceOrder.documentID).setData(
        {
          'orderId': referenceOrder.documentID
        }
    );
    
    QuerySnapshot query = await Firestore.instance.collection('users').document(user.firebaseUser.uid)
      .collection('cart').getDocuments();
    
    for( DocumentSnapshot doc in query.documents ){
      doc.reference.delete();
    }

    products.clear();
    couponCode = null;
    discountPercentage = 0;
    isLoading = false;

    notifyListeners();

    return referenceOrder.documentID;
  }


}
