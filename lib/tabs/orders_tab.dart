import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/models/user_model.dart';
import 'package:virtual_store/screens/login_screen.dart';
import 'package:virtual_store/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    if(UserModel.of(context).isLoggedIn()){
      
      String userId = UserModel.of(context).firebaseUser.uid;
      
      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection('users').document(userId).collection('orders').getDocuments(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView(
              children: snapshot.data.documents.map((doc) => OrderTile(doc.documentID)).toList().reversed.toList()
            ); 
          }
        }
      );
    } else {
      return Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.local_mall, 
              size: 80.0, color: Colors.blueAccent
            ),
            SizedBox(height: 10.0,),
            Text("Faça o login \n para acompanhar seus pedidos:",
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
    }
  }
}