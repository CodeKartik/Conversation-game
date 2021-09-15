import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:conversation_game/speech_api.dart';
import 'MessageBubble.dart';

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
  String text = 'Press mic and speak';
  bool isListening = false;
  ScrollController _scrollController = ScrollController();
  int messageIncrementCounter = 0;

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

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() => this.text = text),
        onListening: (isListening) {
          setState(() => this.isListening = isListening);
        },
      );

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
      appBar: AppBar(
        title: Text('Conversation'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 15),
            child: english != null
                ? Text(
                    "0 / ${english!.length}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                : Container(),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: conversationList == null
              ? CircularProgressIndicator()
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        physics: BouncingScrollPhysics(),
                        itemCount: english!.length,
                        itemBuilder: (context, index) {
                          if (index == english!.length) {
                            return Container(
                              height: 100,
                            );
                          }
                          return MessageBubble(
                              englishMessage: english,
                              hindiMessage: hindi,
                              index: index);

                          // return Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Text(english![index] + hindi![index]),
                          // );
                        },
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      child: Container(
                        height: 200,
                        width: Size.infinite.width,
                        color: Colors.deepOrange,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: english == null
                                    ? CircularProgressIndicator()
                                    : Text(
                                        " \" ${english![0]}  \"  बोलिये",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                            AvatarGlow(
                              animate: true,
                              glowColor: Colors.white,
                              endRadius: 50.0,
                              // duration: const Duration(milliseconds: 1000),
                              // repeatPauseDuration: const Duration(microseconds: 100),
                              repeat: isListening,
                              child: GestureDetector(
                                onLongPress: () {
                                  toggleRecording();
                                  setState(() {
                                    isListening = true;
                                  });
                                  print("onlong press and $isListening");
                                },
                                onLongPressUp: () {
                                  // setState(() {
                                  //   // items.add(text);
                                  //   isListening = false;
                                  // });
                                  _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      curve: Curves.easeOut,
                                      duration: Duration(milliseconds: 300));
                                  // toggleisMe();
                                  print(text);
                                  // if (text == "done for now") {
                                  //   print('very good');
                                  // } else {
                                  // }
                                  print("onlong press up and $isListening");
                                },
                                child: Material(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.amber,
                                    radius: 30,
                                    child: Icon(
                                      Icons.mic,
                                      // _isListening ? Icons.mic : Icons.mic_none,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'Hold to record, release to send.',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
