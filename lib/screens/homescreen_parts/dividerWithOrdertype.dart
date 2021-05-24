import 'package:flutter/material.dart';

class DividerWithType extends StatelessWidget {
  String type;
  DividerWithType({this.type});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(type,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: "ReggaeOne",
                  fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              color: Colors.black,
              height: 10,
              thickness: 2,
              indent: 10,
              endIndent: 10,
            ),
          ),
        )
      ],
    );
  }
}
