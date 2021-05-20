import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:suvidha_shopkeeper/database/request_database.dart';
import 'package:suvidha_shopkeeper/database/shopkeeper_database.dart';
import 'package:suvidha_shopkeeper/models/request.dart';
import 'package:suvidha_shopkeeper/models/shopkeeper.dart';
import 'package:suvidha_shopkeeper/service/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSwitched = false;
  TextEditingController acceptTimeController;
  TextEditingController rejectTextController;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    acceptTimeController = TextEditingController();
    rejectTextController = TextEditingController();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    acceptTimeController.dispose();
    rejectTextController.dispose();
  }

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
    Shopkeeper shopkeeper = Provider.of<Shopkeeper>(context) ??
        Shopkeeper(
          uid: "0",
          shopName: "",
          shopkeeperName: "",
          requestIds: [],
          phoneNumber: "",
          address: "",
          available: false,
        );
    List<Request> req = Provider.of<List<Request>>(context) ?? [];
    List<Request> pendingRequest = [];
    List<Request> history = [];
    List<Request> current = [];

    for (Request r in req) {
      if (shopkeeper.requestIds.contains(r.uid)) {
        if (r.status == "STATUS_PENDING") {
          pendingRequest.add(r);
        }
        if (r.status == "STATUS_ACCEPTED") {
          current.add(r);
        }
        if (r.status == "STATUS_COMPLETED" || r.status == "STATUS_REJECTED") {
          history.add(r);
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
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
                                  toggleSwitch(val);
                                  ShopkeeperDatabase(uid: shopkeeper.uid).updateUserAvail(isSwitched);
                                },
                                value: isSwitched,
                                activeColor: Colors.black,
                                activeTrackColor: Colors.grey,
                                inactiveThumbColor: Colors.white54,
                                inactiveTrackColor: Colors.grey,
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.logout),
                                onPressed: () {
                                  AuthService().signOut();
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.shop),
                              SizedBox(width: 15),
                              Text('${shopkeeper.shopName}',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 15),
                              Text('${shopkeeper.shopkeeperName}',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w200)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            children: [
                              Icon(Icons.phone),
                              SizedBox(width: 15),
                              Text('${shopkeeper.phoneNumber}',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w200)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            children: [
                              Icon(Icons.location_on_outlined),
                              SizedBox(width: 15),
                              Flexible(
                                  flex: 3,
                                  child: Text('${shopkeeper.address}',
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w200))),
                            ],
                          ),
                        ),
                      ]),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('New Orders',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
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
                ),
                Card(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: pendingRequest.length,
                      itemBuilder: (_, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.timelapse_rounded),
                                    SizedBox(width: 15),
                                    Text(
                                        '${DateTime.parse(pendingRequest[index].requestTime).day}/${DateTime.parse(pendingRequest[index].requestTime).month}/${DateTime.parse(pendingRequest[index].requestTime).year}',
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w200)),
                                    SizedBox(width: 10.0),
                                    Text(
                                        '${DateTime.parse(pendingRequest[index].requestTime).hour}:${DateTime.parse(pendingRequest[index].requestTime).minute}',
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w200)),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: [
                                  Icon(Icons.person),
                                  SizedBox(width: 15),
                                  Text('${pendingRequest[index].customerName}',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w200)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on_outlined),
                                  SizedBox(width: 15),
                                  Flexible(
                                      flex: 3,
                                      child: Text(
                                          '${pendingRequest[index].customerAddress}',
                                          maxLines: 2,
                                          softWrap: true,
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w200))),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 20.0),
                                  ExpansionTile(
                                    title: Text(
                                      "Order Summary",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    children: [
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: pendingRequest[index]
                                              .items
                                              .length,
                                          itemBuilder: (_, index1) {
                                            String key = pendingRequest[index]
                                                .items
                                                .keys
                                                .elementAt(index1)
                                                .toString();
                                            return Text(
                                                '$key -> ${pendingRequest[index].items[key].toString()}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w200));
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        showDialog(context: context, builder: (_){
                                          return AlertDialog(
                                            title: Text("How much time do you take to deliver (in minutes)"),
                                            content: TextFormField(
                                              keyboardType: TextInputType.number,
                                              controller: acceptTimeController,
                                              decoration:InputDecoration(
                                                hintText: "eg. 45 min.",
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                )
                                              ),
                                            ),
                                            actions: [
                                              MaterialButton(onPressed: (){
                                                if(acceptTimeController.text.isNotEmpty){
                                                  int expectedTime = int.parse(acceptTimeController.text);
                                                  Navigator.pop(context);
                                                  RequestDatabase().acceptRequest(pendingRequest[index].uid, "STATUS_ACCEPTED", expectedTime, DateTime.now().toIso8601String());
                                                }
                                              },child: Text("accept"),) ,
                                              MaterialButton(onPressed: (){
                                                Navigator.pop(context);
                                              },child: Text("cancel"),)
                                            ],
                                          );
                                        });
                                      }, child: Text('Accept')),
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                      onPressed: () {
                                        showDialog(context: context, builder: (_){
                                          return AlertDialog(
                                            title: Text("Give specific reason to decline the order"),
                                            content: TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: rejectTextController,
                                              decoration:InputDecoration(
                                                  hintText: "eg. Item you order is not available",
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8.0),
                                                  )
                                              ),
                                            ),
                                            actions: [
                                              MaterialButton(onPressed: (){
                                                if(rejectTextController.text.isNotEmpty){
                                                  Navigator.pop(context);
                                                  RequestDatabase().rejectRequest(pendingRequest[index].uid, "STATUS_REJECTED",rejectTextController.text, DateTime.now().toIso8601String());
                                                }
                                              },child: Text("Decline"),) ,
                                              MaterialButton(onPressed: (){
                                                Navigator.pop(context);
                                              },child: Text("cancel"),)
                                            ],
                                          );
                                        });
                                      }, child: Text('Reject')),
                                ],
                              ),
                            ),
                            index != (pendingRequest.length - 1)
                                ? Divider(
                                    color: Colors.black,
                                    height: 10,
                                    thickness: 2,
                                    indent: 10,
                                    endIndent: 10,
                                  )
                                : Container(),
                          ],
                        );
                      }),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Running Orders',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
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
                ),
                Card(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: current.length,
                      itemBuilder: (_, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [

                                        Icon(Icons.timelapse_rounded),
                                        SizedBox(width: 15),
                                        Text(
                                            '${DateTime.parse(current[index].requestTime).day}/${DateTime.parse(current[index].requestTime).month}/${DateTime.parse(current[index].requestTime).year}',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w200)),
                                        SizedBox(width: 10.0),
                                        Text(
                                            '${DateTime.parse(current[index].requestTime).hour}:${DateTime.parse(current[index].requestTime).minute}',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w200)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [

                                        Icon(Icons.timelapse_rounded),
                                        SizedBox(width: 15),
                                        Text(
                                            '${DateTime.parse(current[index].acceptTime).add(Duration(minutes: current[index].expectedTime)).difference(DateTime.now()).inMinutes} min. left ',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w200)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: [
                                  Icon(Icons.person),
                                  SizedBox(width: 15),
                                  Text('${current[index].customerName}',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w200)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on_outlined),
                                  SizedBox(width: 15),
                                  Flexible(
                                      flex: 3,
                                      child: Text(
                                          '${current[index].customerAddress}',
                                          maxLines: 2,
                                          softWrap: true,
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w200))),
                                ],
                              ),
                            ),

                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 20.0),
                                  ExpansionTile(
                                    title: Text(
                                      "Order Summary",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    children: [
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: current[index]
                                              .items
                                              .length,
                                          itemBuilder: (_, index1) {
                                            String key = current[index]
                                                .items
                                                .keys
                                                .elementAt(index1)
                                                .toString();
                                            return Text(
                                                '$key -> ${current[index].items[key].toString()}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.w200));
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                ElevatedButton(onPressed: (){
                                  RequestDatabase().orderDelivered(current[index].uid, "STATUS_COMPLETED");
                                }, child: Text('Order Delivered'),),
                                SizedBox(width: 10,),
                                ElevatedButton(onPressed: (){
                                  RequestDatabase().orderDelivered(current[index].uid, "STATUS_REJECTED");
                                }, child: Text('Cancel Delivery'),),
                              ],
                            ),

                            index != (current.length - 1)
                                ? Divider(
                              color: Colors.black,
                              height: 10,
                              thickness: 2,
                              indent: 10,
                              endIndent: 10,
                            )
                                : Container(),
                          ],
                        );
                      }),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Recent Orders',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
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
                ),
                Card(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: history.length,
                      itemBuilder: (_, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [

                                        Icon(Icons.timelapse_rounded),
                                        SizedBox(width: 15),
                                        Text(
                                            '${DateTime.parse(history[index].requestTime).day}/${DateTime.parse(history[index].requestTime).month}/${DateTime.parse(history[index].requestTime).year}',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w200)),
                                        SizedBox(width: 10.0),
                                        Text(
                                            '${DateTime.parse(history[index].requestTime).hour}:${DateTime.parse(history[index].requestTime).minute}',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w200)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(history[index].status),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: [
                                  Icon(Icons.person),
                                  SizedBox(width: 15),
                                  Text('${history[index].customerName}',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w200)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on_outlined),
                                  SizedBox(width: 15),
                                  Flexible(
                                      flex: 3,
                                      child: Text(
                                          '${history[index].customerAddress}',
                                          maxLines: 2,
                                          softWrap: true,
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w200))),
                                ],
                              ),
                            ),

                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 20.0),
                                  ExpansionTile(
                                    title: Text(
                                      "Order Summary",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    children: [
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: history[index]
                                              .items
                                              .length,
                                          itemBuilder: (_, index1) {
                                            String key = history[index]
                                                .items
                                                .keys
                                                .elementAt(index1)
                                                .toString();
                                            return Text(
                                                '$key -> ${history[index].items[key].toString()}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.w200));
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            index != (history.length - 1)
                                ? Divider(
                              color: Colors.black,
                              height: 10,
                              thickness: 2,
                              indent: 10,
                              endIndent: 10,
                            )
                                : Container(),
                          ],
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
