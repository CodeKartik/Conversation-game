import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conversation_game/Game/ConvType.dart';
import 'package:conversation_game/provider%20model/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:conversation_game/speech_api.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
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
  List finalEnglishConversationList = [];
  List finalHindiConversationList = [];
  static String subCollectionPath = "";
  static String subCollectionID = "";
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String text = 'Press mic and speak';
  bool isListening = false;
  ScrollController _scrollController = ScrollController();
  // int messageIncrementCounter = 0;
  FlutterTts flutterTts = FlutterTts();
  // String speaktext = "";

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
    checkPermissions();
  }

  checkPermissions() async {
    await Permission.speech.request();
  }

  // speak() async {
  //   if (this.mounted) {
  //     await flutterTts.speak(speaktext);
  //   }
  // }

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() => this.text = text
            .replaceAll(new RegExp(r'[^\w\s]+'), '')
            .toString()
            .toLowerCase()),
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

  incrementMsgCounter(BuildContext context) {
    Provider.of<IncrementCounter>(context, listen: false)
        .incrementMessageCounter();
  }

  incrementScrCounter(BuildContext context) {
    Provider.of<IncrementCounter>(context, listen: false)
        .incrementScoreCounter();
  }

  resetCounters(BuildContext context) {
    Provider.of<IncrementCounter>(context, listen: false).resetCounters();
  }

  // Future<bool> _onBackPressed() {}

  @override
  Widget build(BuildContext context) {
    var messageCounter =
        Provider.of<IncrementCounter>(context).getMessageCounter;
    var scoreCounter = Provider.of<IncrementCounter>(context).getScoreCounter;
    return WillPopScope(
      onWillPop: () async {
        if (scoreCounter == 0) {
          return true;
        }
        final dialog = await showDialog(
          context: context,
          builder: (BuildContext context) => new CupertinoAlertDialog(
            title: new Text("Are you sure?"),
            content: new Text("Do you want to end the conversation."),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: new Text("No"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: new Text("Yes"),
                onPressed: () {
                  resetCounters(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (c) => ConversationType()));
                },
              ),
            ],
          ),
        );
        return dialog;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Conversation'),
          leading: IconButton(
              onPressed: () {
                resetCounters(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (c) => ConversationType()));
              },
              icon: Icon(Icons.arrow_back)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 15),
              child: english != null
                  ? Text(
                      "$scoreCounter / ${(english!.length ~/ 2).toInt()}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          itemCount: finalEnglishConversationList.length + 1,
                          itemBuilder: (context, index) {
                            if (index == finalEnglishConversationList.length) {
                              return Container(
                                height: 200,
                              );
                            }
                            return MessageBubble(
                                englishMessage: finalEnglishConversationList,
                                hindiMessage: finalHindiConversationList,
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
                                          " \" ${english![messageCounter]}  \"  बोलिये",
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
                                repeat: isListening,
                                child: GestureDetector(
                                  onLongPress: () {
                                    toggleRecording();

                                    // if (this.mounted) {
                                    //   setState(() {
                                    //     isListening = true;
                                    //   });
                                    // }
                                    // print("onlong press and $isListening");
                                  },
                                  onLongPressUp: () {
                                    print(messageCounter);
                                    print(english!.length);
                                    // print(
                                    //     "This is it :${(english!.length / 2) + 1}");
                                    // print(
                                    //     "This is it :${(english!.length ~/ 2) + 1}");
                                    if (messageCounter ==
                                        (english!.length - 2)) {
                                      print(
                                          "This is message counter : $messageCounter");
                                      String message = english![messageCounter]
                                          .replaceAll(
                                              new RegExp(r'[^\w\s]+'), '')
                                          .toString()
                                          .toLowerCase();
                                      print("Message to compare : $message");
                                      print(
                                          "text to compare : ${text.toLowerCase().toString()}");
                                      if (text.toLowerCase().toString() ==
                                          message) {
                                        incrementScrCounter(context);
                                        finalEnglishConversationList
                                            .add(english![messageCounter]);
                                        finalHindiConversationList
                                            .add(hindi![messageCounter]);
                                        finalEnglishConversationList
                                            .add(english![scoreCounter + 1]);
                                        flutterTts.speak(
                                            english![messageCounter + 1]);
                                        finalHindiConversationList
                                            .add(hindi![scoreCounter + 1]);
                                      }

                                      Fluttertoast.showToast(
                                          msg:
                                              "Conversation ended. Your final score is $scoreCounter");
                                      Future.delayed(Duration(seconds: 2), () {
                                        Navigator.pop(context);
                                        resetCounters(context);
                                      });
                                    } else {
                                      String message = english![messageCounter]
                                          .replaceAll(
                                              new RegExp(r'[^\w\s]+'), '')
                                          .toString()
                                          .toLowerCase();
                                      print("Message to compare : $message");
                                      print(
                                          "text to compare : ${text.toLowerCase().toString()}");

                                      if (text.toLowerCase().toString() ==
                                          message) {
                                        incrementMsgCounter(context);
                                        incrementScrCounter(context);
                                        finalEnglishConversationList
                                            .add(english![messageCounter]);
                                        finalHindiConversationList
                                            .add(hindi![messageCounter]);
                                        finalEnglishConversationList
                                            .add(english![messageCounter + 1]);
                                        flutterTts.speak(
                                            english![messageCounter + 1]);
                                        finalHindiConversationList
                                            .add(hindi![messageCounter + 1]);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Please Try again");
                                      }
                                    }

                                    // incrementMsgCounter(context);
                                    // incrementScrCounter(context);
                                    // Provider.of<IncrementMessageCounter>(context,
                                    //         listen: false)
                                    //     .incrementCounter();
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
                                        borderRadius:
                                            BorderRadius.circular(30)),
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
