import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suvidha_shopkeeper/models/shopkeeper.dart';

class ShopkeeperDatabase{

  String uid;
  ShopkeeperDatabase({this.uid});

  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('shopkeeper');

  Future updateUserAvail(bool avail)async{
    await collectionReference.doc(uid).update({
      "available":avail
    });
  }

  Future updateShopkeeperRequestIdList (List<String> ids)async{
    return await collectionReference.doc(uid).update({
      "requestIds":ids
    });
  }

  Future updateShopName(String shopName)async{
    await collectionReference.doc(uid).update({
      "shopName":shopName
    });
  }

  Future updateShopkeeperName(String shopkeeperName)async{
    await collectionReference.doc(uid).update({
      "shopkeeperName":shopkeeperName
    });
  }

  Future updateShopkeeperAddress(String shopkeeperAddress)async{
    await collectionReference.doc(uid).update({
      "address":shopkeeperAddress
    });
  }

  Future updateShopkeeperDatabase(Shopkeeper shopkeeper)async{
    await collectionReference.doc(uid).set({
      "uid":shopkeeper.uid,
      "shopkeeperName":shopkeeper.shopkeeperName,
      "number":shopkeeper.phoneNumber,
      "address":shopkeeper.address,
      "available":shopkeeper.available,
      "shopName":shopkeeper.shopName,
      "requestIds":shopkeeper.requestIds
    });
  }

  List<Shopkeeper>shopKeeperListFromSnapshot(QuerySnapshot snap){
    return snap.docs.map((e){
      dynamic dt = Map<String, dynamic>.from(e.data());
      return Shopkeeper(
          uid: dt["uid"],
          shopkeeperName: dt["shopkeeperName"],
          address: dt["address"],
          phoneNumber: dt["number"],
          shopName: dt["shopName"].toString(),
          available: dt["available"],
          requestIds: dt["requestIds"].cast<String>()
      );
    }).toList();
  }


  Stream<List<Shopkeeper>> get shopkeepersList{
    return collectionReference.snapshots()
        .map(shopKeeperListFromSnapshot);
  }


  Stream<Shopkeeper> get shopkeeper {
    Stream<DocumentSnapshot> user = collectionReference.doc(uid).snapshots();
    return user.map((snapshot) {
      if (snapshot.exists == true && snapshot.data != null) {
        dynamic dt = Map<String, dynamic>.from(snapshot.data());
        return Shopkeeper(
            uid: dt["uid"],
            shopkeeperName: dt["shopkeeperName"],
            shopName: dt["shopName"],
            phoneNumber: dt["number"],
            address: dt["address"],
            available: dt["available"],
            requestIds: dt["requestIds"].cast<String>()
        );
      }
      else {
        if (snapshot.exists == false) {
          Shopkeeper user = Shopkeeper(
              uid:uid,shopkeeperName: "shopkeeper", available: true,address: "",phoneNumber: "0000000000", shopName: "shopName",requestIds: []);
          updateShopkeeperDatabase(user);
          return user;
        } else {
          return null;
        }
      }
    });
  }



}