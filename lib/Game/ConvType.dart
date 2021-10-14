// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';

import 'package:conversation_game/Game/game_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
        // backgroundColor: Colors.grey.shade200,
        // backgroundColor: Colors.transparent,
        appBar: AppBar(
            centerTitle: true,
            elevation: 0.5,
            backgroundColor: Colors.white,
            title: Column(
              children: [
                Text(
                  'Conversation Game',
                  style: TextStyle(
                    color: Color(0xff5250E4),
                    // color: Colors.blue.shade600,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Learn english with AI',
                  style: TextStyle(
                      color: Color(0xff5250E4),
                      // color: Colors.blue.shade600,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400),
                )
              ],
            )),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 5),
                ConversationCard(
                  convName: 'In a meeting',
                  imageName: 'meeting',
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => GamePage(
                                  subCollectionPath: "In a meeting",
                                  subCollectionID: "pmOnqAcN5h5UBr6vhDgf",
                                )));
                  },
                ),
                ConversationCard(
                  convName: 'Greetings',
                  imageName: 'greetings',
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => GamePage(
                                  subCollectionPath: "Greetings",
                                  subCollectionID: "QUsoRScQPnALS0BtcdsK",
                                )));
                  },
                ),

                ConversationCard(
                  convName: 'Health',
                  imageName: 'health',
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => GamePage(
                                  subCollectionPath: "Health",
                                  subCollectionID: "o4J9fdRiR2JtBWH6OHqf",
                                )));
                  },
                ),
                // SizedBox(height: 20),
                ConversationCard(
                  convName: 'Shopping',
                  imageName: 'shopping',
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => GamePage(
                                  subCollectionPath: "Shopping",
                                  subCollectionID: "vFjiakI6szq0qEoMfkqw",
                                )));
                  },
                ),
                ConversationCard(
                  convName: 'Good Manners',
                  imageName: 'goodmanners',
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => GamePage(
                                  subCollectionPath: "Good Manners",
                                  subCollectionID: "9YFHAkNcZFn7rnLdRLAr",
                                )));
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class ConversationCard extends StatelessWidget {
  const ConversationCard({
    Key? key,
    required this.imageName,
    required this.convName,
    required this.ontap,
  }) : super(key: key);
  final String imageName, convName;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 200,
          // color: Colors.white,
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.blue.shade100, width: 0.2),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              // color: Colors.white, //background color of box
              BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5, // soften the shadow
                  spreadRadius: 1.5, //extend the shadow
                  offset: Offset.zero)
            ],
          ),

          child: Column(
            children: [
              Flexible(child: Image.asset('assets/$imageName.png')),
              Container(
                height: 40,
                width: Size.infinite.width,
                decoration: BoxDecoration(
                  // color: Color(0xffFF725E).withOpacity(0.7),
                  gradient: LinearGradient(colors: [
                    Color(0xff3296F2),
                    Color(0xff1A69DE),
                    Color(0xff3296F2)
                  ]),
                  // color: Color(0xff0088F7),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        '$convName',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            letterSpacing: 1,
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Text(
                      'Tap to play',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        // fontStyle: FontStyle.italic,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
