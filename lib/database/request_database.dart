import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suvidha_shopkeeper/models/request.dart';

class RequestDatabase{


  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('request');


  Future acceptRequest(String uid,String status,int expectedTime ,String acceptTime)async{
    await collectionReference.doc(uid).update({
      "status":status,
      "expectedTime":expectedTime,
      "acceptTime":acceptTime
    });
  }

  Future rejectRequest(String uid,String status,String error,String acceptTime)async{
    await collectionReference.doc(uid).update({
      "status":status,
      "acceptTime":acceptTime,
      "error":error
    });
  }

  List<Request>requestListFromSnap(QuerySnapshot snap){
    return snap.docs.map((e){
      dynamic dt = Map<String, dynamic>.from(e.data());
      return Request(
          uid: dt["uid"],
          items:Map<String,int>.from(dt["items"]),
          status: dt["status"],
          expectedTime: dt["expectedTime"],
          acceptTime: dt["acceptedTime"],
          customerAddress: dt["customerAddress"],
          customerName: dt["customerName"],
          error: dt["error"],
          requestTime: dt["requestTime"],
          totalPrice: dt["totalPrice"]
      );
    }).toList();
  }


  Stream<List<Request>> get request {
    return collectionReference.snapshots()
        .map(requestListFromSnap);

  }

}