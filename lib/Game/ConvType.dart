import 'package:conversation_game/Game/game_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ConversationType extends StatefulWidget {
  @override
  _ConversationTypeState createState() => _ConversationTypeState();
}

class _ConversationTypeState extends State<ConversationType> {
  // static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // List? conList;
  // static String collectionPath = "Intermediate level conversations";
  // static final collectionReference = firestore
  //     .collection(collectionPath)
  //     .doc("uR3yADpPFd5Bom0TGG4E")
  //     .collection('Shopping');
  // static final documentReference =
  //     collectionReference.doc('rggHTu8Fk6lJByrzD3jt');
  // readData() async {
  //   var documentSnapshot = await documentReference.get();
  //   if (documentSnapshot.exists) {
  //     print("Doc exists");
  //     var data = documentSnapshot.data();
  //     print("addig data to list");
  //     conList = data?['conversation'];
  //     print("data added to the list only printing remaing");
  //     // Fluttertoast.showToast(msg: data.toString());
  //     print('This is list frm wakanda : $conList');
  //     // print(data.runtimeType);
  //     // for (var i = 0; i < conList!.length; i++) {
  //     //   print(data?['shopping_conversation'][i]['english']);
  //     //   print(data?['shopping_conversation'][i]['hindi']);
  //     // }
  //   }
  // }

  @override
  void initState() {
    checkPermissions();
    super.initState();
  }

  checkPermissions() async {
    await Permission.speech.request();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xffFE834A),
        // appBar: AppBar(
        //   title: Text(
        //     "Conversation Game",
        //     style: TextStyle(color: Colors.white),
        //   ),
        //   centerTitle: true,
        // ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.white,
                onPressed: () async {
                  // readData();
                  // List? conversationList = await readData();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => NewPage(
                                subCollectionPath: "In a meeting",
                                subCollectionID: "pmOnqAcN5h5UBr6vhDgf",
                              )));
                },
                minWidth: size.width,
                height: 50,
                child: Text('In a meeting'),
              ),
              SizedBox(height: 20),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.white,
                onPressed: () async {
                  // readData();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => NewPage(
                                subCollectionPath: "Good Manners",
                                subCollectionID: "9YFHAkNcZFn7rnLdRLAr",
                              )));
                },
                minWidth: size.width,
                height: 50,
                child: Text('Good Manners'),
              ),
              // SizedBox(height: 20),
              // MaterialButton(
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20)),
              //   color: Colors.white,
              //   onPressed: () async {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (c) => NewPage(
              //                   subCollectionPath: "At home",
              //                   subCollectionID: "7efMV07DERPQcmZtNxAt",
              //                 )));
              //   },
              //   minWidth: size.width,
              //   height: 50,
              //   child: Text('At home'),
              // ),
              SizedBox(height: 20),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.white,
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => NewPage(
                                subCollectionPath: "Greetings",
                                subCollectionID: "QUsoRScQPnALS0BtcdsK",
                              )));
                },
                minWidth: size.width,
                height: 50,
                child: Text('Greetings'),
              ),
            ],
          ),
        ));
  }
}
