import 'dart:async';
import 'dart:ui';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conversation_game/Game/ConvType.dart';
import 'package:conversation_game/provider%20model/model.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:conversation_game/speech_api.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'MessageBubble.dart';
import 'package:string_similarity/string_similarity.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    Key? key,
    required this.subCollectionPath,
    required this.subCollectionID,
  }) : super(key: key);

  final String subCollectionPath, subCollectionID;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
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
  FlutterTts flutterTts = FlutterTts();
  double accurecyPercentage = 0;

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

  @override
  void dispose() {
    super.dispose();
  }

  checkPermissions() async {
    await Permission.speech.request();
  }

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

  @override
  Widget build(BuildContext context) {
    var messageCounter =
        Provider.of<IncrementCounter>(context).getMessageCounter;
    var scoreCounter = Provider.of<IncrementCounter>(context).getScoreCounter;
    return WillPopScope(
      onWillPop: () async {
        if (scoreCounter == 0 && messageCounter == 0) {
          return true;
        }
        final dialog = await showDialog(
          barrierDismissible: false,
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
      // LinearGradient(
      //       begin: Alignment.topLeft,
      //       end: Alignment.bottomRight,
      //       // stops: [0.1, 0.5, 0.7, 0.9],
      //       colors: [Color(0xff5FFBF1), Color(0xff86A8E7), Color(0xffD16BA5)],
      //     ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
              0.1,
              // 0.4,
              0.7,
            ],
            colors: [
              // Color(0xffB2EEEA),

              Colors.white,
              Colors.blue.shade100,
              // Color(0xffB5C6E7),
              // Color(0xffCF97B7),
            ],
          ),
        ),
        child: Scaffold(
          // backgroundColor: Colors.grey.shade300,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            // backgroundColor: Colors.blue.shade600,
            backgroundColor: Colors.white,
            elevation: 1,
            title: Text(
              'Conversation',
              style: TextStyle(fontSize: 20, color: Color(0xff5250E4)),
            ),
            leading: IconButton(
                onPressed: () {
                  resetCounters(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (c) => ConversationType()));
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Color(0xff5250E4),
                )),
            // padding: const EdgeInsets.only(top: 15, right: 15),

            actions: [
              english != null
                  ? Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xffFF725E),
                            borderRadius: BorderRadius.circular(13)),
                        // height: 5,
                        width: 100,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Score : ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "$scoreCounter / ${(english!.length ~/ 2).toInt()}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
          body: SafeArea(
            child: Center(
              child: conversationList == null
                  ? Lottie.asset('assets/loading.json')

                  // CircularProgressIndicator(
                  //     strokeWidth: 6,
                  //     color: Colors.greenAccent,
                  //     backgroundColor: Colors.blueAccent,
                  //   )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            // shrinkWrap: true,
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            physics: BouncingScrollPhysics(),
                            itemCount: finalEnglishConversationList.length + 1,
                            itemBuilder: (context, index) {
                              if (index ==
                                  finalEnglishConversationList.length) {
                                return Container(
                                  height: 220,
                                );
                              }
                              // if the range error still occurs then disable the delayed display
                              //  slidingCurve: Curves.easeIn,
                              // delay: Duration(microseconds: 300),
                              return MessageBubble(
                                  englishMessage: finalEnglishConversationList,
                                  hindiMessage: finalHindiConversationList,
                                  index: index);
                            },
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: Size.infinite.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: Colors.white,
                            boxShadow: [
                              // color: Colors.white, //background color of box
                              BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 1, // soften the shadow
                                  spreadRadius: 0.0, //extend the shadow
                                  offset: Offset.zero)
                            ],
                          ),
                          // color: Colors.deepOrange,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  child: english == null
                                      ? CircularProgressIndicator()
                                      : Text(
                                          " \" ${english![messageCounter]}  \"  बोलिये",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                              ),
                              AvatarGlow(
                                animate: isListening,
                                glowColor: Colors.blue,
                                endRadius: 50.0,
                                // repeat: isListening,
                                child: GestureDetector(
                                  onLongPress: () {
                                    toggleRecording();
                                    setState(() {
                                      isListening = true;
                                    });
                                  },
                                  onLongPressUp: () {
                                    setState(() {
                                      isListening = false;
                                    });
                                    String message = english![messageCounter]
                                        .replaceAll(new RegExp(r'[^\w\s]+'), '')
                                        .toString()
                                        .toLowerCase();
                                    accurecyPercentage = text
                                        .toLowerCase()
                                        .toString()
                                        .similarityTo(message);

                                    var percent =
                                        (accurecyPercentage * 100).toInt();
                                    print(
                                        "This is a percentage acc : $percent");

                                    // if the message is last from the conversation then the if condition execute otherwise else condition will execute

                                    if (messageCounter ==
                                        (english!.length - 2)) {
                                      print("Message to compare : $message");
                                      print(
                                          "text to compare : ${text.toLowerCase().toString()}");

                                      if (percent > 70) {
                                        endSuccessDialog(
                                            context, percent, scoreCounter);
                                        // showDialog(
                                        //   context: context,
                                        //   builder: (BuildContext context) =>
                                        //       new CupertinoAlertDialog(
                                        //     title:
                                        //         new Text("$percent%  सही जवाब"),
                                        //     content: Column(
                                        //       children: [
                                        //         Text("\" $text \"",
                                        //             style: TextStyle(
                                        //               fontSize: 18,
                                        //             )),
                                        //         Text(
                                        //             "Well try, Conversation ended",
                                        //             style: TextStyle(
                                        //               fontSize: 18,
                                        //             )),
                                        //         Text(
                                        //             "Your final score is : ${scoreCounter + 1}",
                                        //             style: TextStyle(
                                        //               fontSize: 18,
                                        //             )),
                                        //       ],
                                        //     ),
                                        //     actions: [
                                        //       CupertinoDialogAction(
                                        //         isDefaultAction: true,
                                        //         child: new Text("Ok"),
                                        //         onPressed: () {
                                        //           // incrementMsgCounter(context);
                                        //           // incrementScrCounter(context);
                                        //           resetCounters(context);

                                        //           Navigator.pushReplacement(
                                        //               context,
                                        //               MaterialPageRoute(
                                        //                   builder: (c) =>
                                        //                       ConversationType()));
                                        //         },
                                        //       ),
                                        //     ],
                                        //   ),
                                        // );
                                      } else {
                                        endErrorDialog(
                                            context, percent, scoreCounter);
                                        // showDialog(
                                        //     context: context,
                                        //     builder: (c) =>
                                        //         CupertinoAlertDialog(
                                        //           title: Text("Ohh no"),
                                        //           content: Text('$text'),
                                        //           actions: [
                                        //             CupertinoDialogAction(
                                        //               child: Text("Try again"),
                                        //               onPressed: () {
                                        //                 Navigator.pop(context);
                                        //               },
                                        //             ),
                                        //             CupertinoDialogAction(
                                        //               child: Text("Skip"),
                                        //               onPressed: () {
                                        //                 showDialog(
                                        //                   context: context,
                                        //                   builder: (BuildContext
                                        //                           context) =>
                                        //                       new CupertinoAlertDialog(
                                        //                     title: new Text(
                                        //                         "$percent%  सही जवाब"),
                                        //                     content: Column(
                                        //                       children: [
                                        //                         Text(
                                        //                             "\" $text \"",
                                        //                             style:
                                        //                                 TextStyle(
                                        //                               fontSize:
                                        //                                   18,
                                        //                             )),
                                        //                         Text(
                                        //                             "Well try, Conversation ended",
                                        //                             style:
                                        //                                 TextStyle(
                                        //                               fontSize:
                                        //                                   18,
                                        //                             )),
                                        //                         Text(
                                        //                             "Your final score is : $scoreCounter",
                                        //                             style:
                                        //                                 TextStyle(
                                        //                               fontSize:
                                        //                                   18,
                                        //                             )),
                                        //                       ],
                                        //                     ),
                                        //                     actions: [
                                        //                       CupertinoDialogAction(
                                        //                         child:
                                        //                             Text("Ok"),
                                        //                         onPressed: () {
                                        //                           resetCounters(
                                        //                               context);

                                        //                           Navigator.pushReplacement(
                                        //                               context,
                                        //                               MaterialPageRoute(
                                        //                                   builder: (c) =>
                                        //                                       ConversationType()));
                                        //                         },
                                        //                       ),
                                        //                     ],
                                        //                   ),
                                        //                 );
                                        //               },
                                        //             ),
                                        //           ],
                                        //         ));
                                      }
                                    } else {
                                      // String message = english![messageCounter]
                                      //     .replaceAll(
                                      //         new RegExp(r'[^\w\s]+'), '')
                                      //     .toString()
                                      //     .toLowerCase();
                                      print("Message to compare : $message");
                                      print(
                                          "text to compare : ${text.toLowerCase().toString()}");
                                      if (percent > 70) {
                                        successDialog(
                                            context, percent, messageCounter);

                                        // showDialog(
                                        //   context: context,
                                        //   builder: (BuildContext context) =>
                                        //       new CupertinoAlertDialog(
                                        //     title:
                                        //         new Text("$percent%  सही जवाब"),
                                        //     content: new Text("\" $text \"",
                                        //         style: TextStyle(
                                        //           fontSize: 22,
                                        //         )),
                                        //     actions: [
                                        //       CupertinoDialogAction(
                                        //         isDefaultAction: true,
                                        //         child: new Text("Next"),
                                        //         onPressed: () {
                                        //           incrementMsgCounter(context);
                                        //           incrementScrCounter(context);
                                        //           finalEnglishConversationList
                                        //               .add(english![
                                        //                   messageCounter]);
                                        //           finalHindiConversationList
                                        //               .add(hindi![
                                        //                   messageCounter]);
                                        //           finalEnglishConversationList
                                        //               .add(english![
                                        //                   messageCounter + 1]);
                                        //           flutterTts.speak(english![
                                        //               messageCounter + 1]);
                                        //           finalHindiConversationList
                                        //               .add(hindi![
                                        //                   messageCounter + 1]);
                                        //           Navigator.pop(context);
                                        //         },
                                        //       ),
                                        //     ],
                                        //   ),
                                        // );
                                      } else {
                                        errorDialog(
                                            context, percent, messageCounter);
                                        // showDialog(
                                        //   context: context,
                                        //   builder: (BuildContext context) =>
                                        //       new CupertinoAlertDialog(
                                        //     title:
                                        //         new Text("$percent% सही जवाब"),
                                        //     content: new Text(
                                        //       "$text",
                                        //       style: TextStyle(
                                        //         fontSize: 18,
                                        //       ),
                                        //     ),
                                        //     actions: [
                                        //       CupertinoDialogAction(
                                        //         isDefaultAction: true,
                                        //         child: new Text("Try again"),
                                        //         onPressed: () {
                                        //           Navigator.pop(context);
                                        //         },
                                        //       ),
                                        //       CupertinoDialogAction(
                                        //         isDefaultAction: true,
                                        //         child: new Text("Skip"),
                                        //         onPressed: () {
                                        //           incrementMsgCounter(context);
                                        //           finalEnglishConversationList
                                        //               .add(english![
                                        //                   messageCounter]);
                                        //           finalHindiConversationList
                                        //               .add(hindi![
                                        //                   messageCounter]);
                                        //           finalEnglishConversationList
                                        //               .add(english![
                                        //                   messageCounter + 1]);
                                        //           flutterTts.speak(english![
                                        //               messageCounter + 1]);
                                        //           finalHindiConversationList
                                        //               .add(hindi![
                                        //                   messageCounter + 1]);
                                        //           Navigator.pop(context);
                                        //         },
                                        //       ),
                                        //     ],
                                        //   ),
                                        // );
                                      }
                                    }
                                    _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        curve: Curves.easeOut,
                                        duration: Duration(milliseconds: 300));
                                  },
                                  child: Material(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(35)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xff3296F2),
                                                Color(0xff1A69DE),
                                              ])),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 30,
                                        child: Icon(
                                          // Icons.mic,
                                          isListening
                                              ? Icons.mic_none
                                              : Icons.mic,

                                          size: 32,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'Hold to record & release to send.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  // fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  AwesomeDialog errorDialog(
      BuildContext context, int percent, int messageCounter) {
    return AwesomeDialog(
      dismissOnBackKeyPress: false,
      context: context,
      animType: AnimType.BOTTOMSLIDE,
      dialogType: DialogType.ERROR,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$percent%",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              Text("  सही जवाब",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(width: 8),
              IconButton(
                  onPressed: () {
                    flutterTts.speak(text);
                  },
                  icon: Icon(
                    Icons.volume_up_rounded,
                    color: Colors.black87,
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "\" $text \"",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
      btnOk: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Color(0xFF00CA71),
          child: Text(
            'Try again',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      btnCancel: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.red,
          child: Text(
            'Skip',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            incrementMsgCounter(context);
            finalEnglishConversationList.add(english![messageCounter]);
            finalHindiConversationList.add(hindi![messageCounter]);
            finalEnglishConversationList.add(english![messageCounter + 1]);
            flutterTts.speak(english![messageCounter + 1]);
            finalHindiConversationList.add(hindi![messageCounter + 1]);
            Navigator.pop(context);
          }),
    )..show();
  }

  AwesomeDialog successDialog(
      BuildContext context, int percent, int messageCounter) {
    return AwesomeDialog(
      context: context,
      dismissOnBackKeyPress: false,
      animType: AnimType.BOTTOMSLIDE,
      dialogType: DialogType.SUCCES,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$percent%",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00CA71)),
              ),
              Text("  सही जवाब",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(width: 8),
              IconButton(
                  onPressed: () {
                    flutterTts.speak(text);
                  },
                  icon: Icon(
                    Icons.volume_up_rounded,
                    color: Colors.black87,
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "\" $text \"",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
      btnOk: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          incrementMsgCounter(context);
          incrementScrCounter(context);
          finalEnglishConversationList.add(english![messageCounter]);
          finalHindiConversationList.add(hindi![messageCounter]);
          finalEnglishConversationList.add(english![messageCounter + 1]);
          flutterTts.speak(english![messageCounter + 1]);
          finalHindiConversationList.add(hindi![messageCounter + 1]);
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: "Point scored.", gravity: ToastGravity.CENTER);
        },
        color: Color(0xFF00CA71),
        child: Text(
          'Next',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    )..show();
  }

  AwesomeDialog endErrorDialog(
      BuildContext context, int percent, int scoreCounter) {
    return AwesomeDialog(
      context: context,
      dismissOnBackKeyPress: false,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$percent%",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              Text("  सही जवाब",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(width: 8),
              IconButton(
                  onPressed: () {
                    flutterTts.speak(text);
                  },
                  icon: Icon(
                    Icons.volume_up_rounded,
                    color: Colors.black87,
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "\" $text \"",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
      btnOk: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Color(0xFF00CA71),
          child: Text(
            'Try again',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      btnCancel: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.red,
        child: Text(
          'End Conv.',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.BOTTOMSLIDE,
            body: Column(
              children: [
                Text('Well try, Conversation has ended.'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Your final score is : '),
                    Text(
                      "$scoreCounter",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ],
            ),
            btnOk: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Color(0xFF00CA71),
              onPressed: () {
                resetCounters(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (c) => ConversationType()));
              },
              child: Text(
                'Ok',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          )..show();
        },
      ),
    )..show();
  }

  AwesomeDialog endSuccessDialog(
      BuildContext context, int percent, int scoreCounter) {
    return AwesomeDialog(
      context: context,
      dismissOnBackKeyPress: false,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      btnOk: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Color(0xFF00CA71),
        onPressed: () {
          resetCounters(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (c) => ConversationType()));
        },
        child: Text(
          'Ok',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$percent%",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00CA71)),
              ),
              Text("  सही जवाब",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(width: 8),
              IconButton(
                  onPressed: () {
                    flutterTts.speak(text);
                  },
                  icon: Icon(
                    Icons.volume_up_rounded,
                    color: Colors.black87,
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "\" $text \"",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
          Text("Well try, Conversation ended",
              style: TextStyle(
                fontSize: 14,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Your final score is : ",
                  style: TextStyle(
                    fontSize: 16,
                  )),
              Text(
                '${scoreCounter + 1}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    )..show();
  }
}
