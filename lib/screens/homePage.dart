import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:suvidha_shopkeeper/models/request.dart';
import 'package:suvidha_shopkeeper/models/shopkeeper.dart';
import 'package:suvidha_shopkeeper/screens/homescreen_parts/current_order_card.dart';
import 'package:suvidha_shopkeeper/screens/homescreen_parts/dividerWithOrdertype.dart';
import 'package:suvidha_shopkeeper/screens/homescreen_parts/history_card.dart';
import 'package:suvidha_shopkeeper/screens/homescreen_parts/new_order_card.dart';
import 'package:suvidha_shopkeeper/screens/homescreen_parts/user_profile_card.dart';
import 'FormPage.dart';
//home page start...
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;

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
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
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
                UserProfileCard(
                  shopkeeper: shopkeeper,
                ),
                DefaultTabController(
                    length: 3,
                    initialIndex: 0,
                    child: Column(
                      children: [
                        Container(
                          child: TabBar(
                            labelColor: Colors.teal,
                            unselectedLabelColor: Colors.black,
                            tabs: [
                              Tab(text: 'New '),
                              Tab(text: 'Running ',),
                              Tab(text: 'Recent ')
                            ],
                          ),
                        ),
                        Container(
                        height: 500, 
                        decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.black, width: 0.6))
                        ),
                        child: TabBarView(children: <Widget>[
                        SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: Container(
                          child: NewOrderCard(pendingRequest: pendingRequest),
                          ),
                        ),
                          SingleChildScrollView(
                            physics: ScrollPhysics(),
                            child: Container(
                              child: CurrentOrderCard(
                                current: current,
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            physics: ScrollPhysics(),
                            child: Container(
                              child: HistoryCard(
                                history: history,
                              )
                            ),
                          ),


                        ],
                      )
                      ),
                    ]
                    )),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
