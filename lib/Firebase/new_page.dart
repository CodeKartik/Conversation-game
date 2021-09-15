import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class NewPage extends StatefulWidget {
  const NewPage({
    Key? key,
    required this.subCollectionPath,
    required this.subCollectionID,
  }) : super(key: key);

  final String subCollectionPath, subCollectionID;

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  List? english;
  List? hindi;
  List? conversationList;
  List numbersList = [];
  static String subCollectionPath = "";
  static String subCollectionID = "";
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    setState(() {
      subCollectionID = widget.subCollectionID;
      subCollectionPath = widget.subCollectionPath;
    });
    print("$subCollectionPath");
    print("$subCollectionID");
    super.initState();
    readData();
  }

  readData() async {
    final collectionReference = firestore
        .collection("Intermediate level conversations")
        .doc("uR3yADpPFd5Bom0TGG4E")
        .collection(subCollectionPath);
    final documentReference = collectionReference.doc(subCollectionID);
    var documentSnapshot = await documentReference.get();
    if (documentSnapshot.exists) {
      var data = documentSnapshot.data();
      setState(() {
        conversationList = data?['conversation'];
      });
      // print("This is conlist form newPage :$conversationList");
      setState(() {
        english = [
          for (var i = 0; i < conversationList!.length; i++)
            conversationList![i]['english']
        ];
        hindi = [
          for (var i = 0; i < conversationList!.length; i++)
            conversationList![i]['hindi']
        ];
      });

      // modified msg to compare with voice output
      print(english![0]
          .replaceAll(new RegExp(r'[^\w\s]+'), '')
          .toString()
          .toLowerCase());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: conversationList == null
                ? CircularProgressIndicator()
                : ListView.builder(
                    itemCount: english!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(english![index] + hindi![index]),
                      );
                    })),
      ),
    );
  }
}
