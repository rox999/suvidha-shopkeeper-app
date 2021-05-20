import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:suvidha_shopkeeper/database/request_database.dart';
import 'package:suvidha_shopkeeper/database/shopkeeper_database.dart';
import 'package:suvidha_shopkeeper/service/auth.dart';
import 'package:suvidha_shopkeeper/wrapper.dart';

import 'screens/homePage.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      StreamProvider.value(value: AuthService().authChange,initialData: null),
    ],child:Wrapper(),);
  }
}
