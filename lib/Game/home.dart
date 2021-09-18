import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FBtesting extends StatefulWidget {
  const FBtesting({Key? key}) : super(key: key);

  @override
  _FBtestingState createState() => _FBtestingState();
}

class _FBtestingState extends State<FBtesting> {
  // static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // static final _collectionReference =
  //     _firestore.collection("Users").doc("UsersInfo").collection("Profile");
  // static final _documentReference = _collectionReference.doc("ProfileData");

  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // static final collectionReference = firestore
  //     .collection("Intermediate level conversations")
  //     .doc("uR3yADpPFd5Bom0TGG4E")
  //     .collection("In a meeting");
  // static final documentReference =
  //     collectionReference.doc("pmOnqAcN5h5UBr6vhDgf");
  static final collectionReference = firestore
      .collection("Intermediate level conversations")
      .doc("uR3yADpPFd5Bom0TGG4E")
      .collection("shopping");
  static final documentReference = collectionReference.doc("shopping_id");

  readData() async {
    var documentSnapshot = await documentReference.get();
    if (documentSnapshot.exists) {
      var data = documentSnapshot.data();
      List conList = data?['shopping_conversation'];
      Fluttertoast.showToast(msg: data.toString());
      print(conList.length);
      // print(data.runtimeType);
      for (var i = 0; i < conList.length; i++) {
        print(data?['shopping_conversation'][i]['english']);
        print(data?['shopping_conversation'][i]['hindi']);
      }
    }
  }

  // updateData() async {
  //   Map<String, dynamic> demoData = {
  //     "name": "Kartik More",
  //   };
  //   _documentReference
  //       .update(demoData)
  //       .whenComplete(() => Fluttertoast.showToast(msg: "data updated"))
  //       .onError((error, stackTrace) =>
  //           Fluttertoast.showToast(msg: error.toString()));
  // }

  // deleteData() async {
  //   _documentReference
  //       .delete()
  //       .whenComplete(() => Fluttertoast.showToast(msg: "User deleted"))
  //       .onError((error, stackTrace) =>
  //           Fluttertoast.showToast(msg: error.toString()));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
                onPressed: () {
                  // addData();
                },
                child: Text('Add data')),
            TextButton(
                onPressed: () {
                  readData();
                },
                child: Text('Read')),
            TextButton(
                onPressed: () {
                  // updateData();
                },
                child: Text('Update')),
            TextButton(
                onPressed: () {
                  // deleteData();
                },
                child: Text('Delete')),
            TextButton(
                onPressed: () {
                  // Navigator.push(
                  //     context, MaterialPageRoute(builder: (c) => NewPage()));
                },
                child: Text('next')),
          ],
        ),
      ),
    );
  }
}
