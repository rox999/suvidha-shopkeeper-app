import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suvidha_shopkeeper/home_wrapper.dart';
import 'package:suvidha_shopkeeper/screens/homePage.dart';
import 'package:suvidha_shopkeeper/screens/loginPage.dart';
class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {

   User firebaseUser =  Provider.of<User>(context);
   return  (firebaseUser==null )?LoginPage():HomeWrapper();
  }
}
