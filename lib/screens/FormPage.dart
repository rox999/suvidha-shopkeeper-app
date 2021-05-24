import 'package:flutter/material.dart';
import 'package:suvidha_shopkeeper/database/shopkeeper_database.dart';
import 'package:suvidha_shopkeeper/models/constants.dart';
import 'package:suvidha_shopkeeper/models/shopkeeper.dart';

class FormPage extends StatefulWidget {
  Shopkeeper shopkeeper = Shopkeeper();
  FormPage({this.shopkeeper});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  Shopkeeper tempShopkeeper = Shopkeeper();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tempShopkeeper = widget.shopkeeper;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(children: [
                Text(
                  'Update Shop Info:',
                  style: TextStyle(
                      fontFamily: "ReggaeOne",
                      fontWeight: FontWeight.w900,
                      fontSize: 25.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Divider(
                    color: Colors.teal[500],
                    height: 10,
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) return "please enter a valid shop name";
                    return null;
                  },
                  initialValue: widget.shopkeeper.shopName != null
                      ? widget.shopkeeper.shopName
                      : 'Shop Name',
                  decoration: textInputDecoration.copyWith(
                    // hintText: 'Shop Name',
                    labelText: 'Shop Name',
                  ),
                  onChanged: (val) {
                    setState(() {
                      tempShopkeeper.shopName = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) return "please enter your valid Name";
                    return null;
                  },
                  initialValue: widget.shopkeeper.shopkeeperName != null
                      ? widget.shopkeeper.shopkeeperName
                      : 'Your Name',
                  decoration: textInputDecoration.copyWith(
                    // hintText: 'Shop Name',
                    labelText: 'Your Name',
                  ),
                  onChanged: (val) {
                    setState(() {
                      tempShopkeeper.shopkeeperName = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) return "please enter a valid shop address";
                    return null;
                  },
                  //enabled: false,
                  initialValue: widget.shopkeeper.address != null
                      ? widget.shopkeeper.address
                      : 'Address',
                  decoration: textInputDecoration.copyWith(
                    // hintText: 'Shop Name',
                    labelText: 'Shop Address',
                  ),
                  onChanged: (val) {
                    setState(() {
                      tempShopkeeper.address = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.teal[400], width: 2.0),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Mobile No. : ${tempShopkeeper.phoneNumber.toString()}",
                            maxLines: 2,
                            style: TextStyle(fontSize: 20, letterSpacing: 1.2),
                          )),
                    )),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      ShopkeeperDatabase(uid: tempShopkeeper.uid)
                          .updateShopkeeperDatabase(tempShopkeeper);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save Changes'),
                ),
              ]),
            ),
          ),
        ),
      ),
    ));
  }
}
