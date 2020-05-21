import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/models/user_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if(model.isLoading){
            return Center(child: CircularProgressIndicator());
          }
          return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(20.0),
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: "Nome Completo"),
                    validator: (text) {
                      if (text.isEmpty) return "Nome inválido!";
                    },
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "E-mail"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text.isEmpty || !text.contains("@"))
                        return "E-mail inválido!";
                    },
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(hintText: "Senha"),
                    obscureText: true,
                    validator: (text) {
                      if (text.isEmpty || text.length < 6)
                        return "Senha inválida!";
                    },
                  ),
                  SizedBox(height: 15.0),
                  SizedBox(
                    height: 45.0,
                    child: RaisedButton(
                      child: Text(
                        "Criar",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      textColor: Colors.white,
                      color: Colors.blueAccent,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          
                          Map<String, dynamic> userData = {
                            'name': _nameController.text,
                            'email': _emailController.text, 
                          };

                          model.signUp(
                            userData: userData, 
                            pass: _passController.text, 
                            onSuccess: _onSuccess, 
                            onFail: _onFail
                          );
                        }
                      },
                    ),
                  )
                ],
              ));
        }));
  }
  void _onSuccess(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text('Usuário cadastrado com sucesso!'),
        backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 4)
      )
    );

    Future.delayed(Duration(seconds: 4)).then((_){
      Navigator.of(context).pop();
    });
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text('Falha ao cadastrar usuário!'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 4)
      )
    );

    Future.delayed(Duration(seconds: 4)).then((_){
      Navigator.of(context).pop();
    });
  }

}

