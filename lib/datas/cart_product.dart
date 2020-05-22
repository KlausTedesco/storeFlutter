import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_store/datas/product_data.dart';

class CartProduct {

  String idCart;
  String category;
  String idProduct;

  int quantity;
  String size;

  ProductData productData;

  CartProduct();

  CartProduct.fromDocument( DocumentSnapshot document){
    idCart = document.documentID;
    category = document.data['category'];
    idProduct = document.data['idProduct'];
    quantity = document.data['quantity'];
    size = document.data['size'];
  }

  Map<String, dynamic> toMap() { 
    return{
      'category' : category,
      'idProduct' : idProduct,
      'quantity' : quantity,
      'size' : size,
      //'product' : productData.toResumeMap()
    };
  }
  

}