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
                DividerWithType(
                  type: "New Orders",
                ),
                NewOrderCard(pendingRequest: pendingRequest),
                DividerWithType(
                  type: "Running Orders",
                ),
                CurrentOrderCard(
                  current: current,
                ),
                DividerWithType(
                  type: "Recent Orders",
                ),
                HistoryCard(
                  history: history,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
