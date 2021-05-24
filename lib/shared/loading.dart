import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //color: Colors.pink[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  'SUVIDHA',
                  style: TextStyle(
                    fontFamily: 'ReggaeOne',
                    fontSize: 40,
                    //color: Colors.white,
                  ),
                ),
                Text(
                  'SHOPKEEPER',
                  style: TextStyle(
                    fontFamily: 'ReggaeOne',
                    fontSize: 25,
                    //color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: SpinKitChasingDots(
                color: Colors.teal[300],
                size: 50.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
