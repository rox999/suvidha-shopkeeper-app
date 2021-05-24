import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suvidha_shopkeeper/database/request_database.dart';
import 'package:suvidha_shopkeeper/database/shopkeeper_database.dart';
import 'package:suvidha_shopkeeper/screens/homePage.dart';

class HomeWrapper extends StatefulWidget {
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  @override
  Widget build(BuildContext context) {
    User firebaseUser = Provider.of<User>(context);
    return MultiProvider(
      providers: [
        StreamProvider.value(
          value: ShopkeeperDatabase(uid: firebaseUser.uid).shopkeeper,
          initialData: null,
        ),
        StreamProvider.value(
            value: RequestDatabase().request,
            initialData: null)
      ],
      child: Home(),
    );
  }
}
