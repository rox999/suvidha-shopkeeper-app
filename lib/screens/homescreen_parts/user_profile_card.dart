import 'package:flutter/material.dart';
import 'package:suvidha_shopkeeper/database/shopkeeper_database.dart';
import 'package:suvidha_shopkeeper/models/shopkeeper.dart';
import 'package:suvidha_shopkeeper/screens/FormPage.dart';
import 'package:suvidha_shopkeeper/service/auth.dart';

class UserProfileCard extends StatefulWidget {
  Shopkeeper shopkeeper = Shopkeeper(
    uid: "0",
    shopName: "",
    shopkeeperName: "",
    requestIds: [],
    phoneNumber: "",
    address: "",
    available: false,
  );

  UserProfileCard({this.shopkeeper});

  @override
  _UserProfileCardState createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  bool isSwitched = false;
  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
      });
    } else {
      setState(() {
        isSwitched = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    isSwitched = widget.shopkeeper.available;
    return Card(
      elevation: 15.0,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Switch(
                    onChanged: (val) {
                      showDialog(context: context, builder: (_){
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          title: val ? Text('Do you want to enable online dilevery?') : Text('Do you want to disable online dilevery?'),
                          actions: [
                            MaterialButton(onPressed: (){
                              toggleSwitch(val);
                              ShopkeeperDatabase(uid: widget.shopkeeper.uid).updateUserAvail(isSwitched);
                              Navigator.pop(context);
                            },child: Text('Yes'),color: Colors.teal[300],),
                            MaterialButton(onPressed: (){
                              Navigator.pop(context);
                            },child: Text('No'),color: Colors.teal[300],),
                          ],
                        );
                      });
                      // toggleSwitch(val);
                      // ShopkeeperDatabase(uid: shopkeeper.uid).updateUserAvail(isSwitched);
                    },
                    value: isSwitched,
                  ),
                  IconButton(
                    icon: Icon(Icons.mode_edit, semanticLabel: "edit"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FormPage(shopkeeper: widget.shopkeeper)),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.logout,semanticLabel: "sign out",),
                    onPressed: () {
                      //AuthService().signOut();
                      showDialog(context: context, builder: (_){
                        return AlertDialog(
                          title: Text('Do you want to Logout?'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          actions: [
                            MaterialButton(onPressed: (){
                              AuthService().signOut();
                              Navigator.pop(context);
                            }, child: Text('Yes'),color: Colors.teal[300],),
                            MaterialButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: Text('No'),color: Colors.teal[300],)
                          ],
                        );
                      });

                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 8.0),
                    child: Icon(Icons.shop),
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    flex: 3,
                    child: Text('${widget.shopkeeper.shopName}',
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontFamily: "ReggaeOne",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 8.0),
                    child: Icon(Icons.person),
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    flex: 3,
                    child: Text('${widget.shopkeeper.shopkeeperName}',
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w200)),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 8.0),
                    child: Icon(Icons.phone),
                  ),
                  SizedBox(width: 15),
                  Text('${widget.shopkeeper.phoneNumber}',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w200)),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 8.0),
                    child: Icon(Icons.location_on_rounded),
                  ),
                  SizedBox(width: 15),
                  Flexible(
                      flex: 3,
                      child: Text('${widget.shopkeeper.address}',
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.w200))),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ]),
    );
  }
}
