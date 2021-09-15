import 'package:avatar_glow/avatar_glow.dart';
import 'package:conversation_game/HomeScreen.dart';
import 'package:conversation_game/speech_api.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

const Color kcolor = Color(0xffFE834A);

class UserCommands {
  final String englishCommand;
  final String hindiCommand;

  UserCommands(
    this.englishCommand,
    this.hindiCommand,
  );
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key, required this.convType}) : super(key: key);
  final convType;

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  int index = 0;
  bool isCorrect1 = false;
  bool isCorrect2 = false;
  bool isCorrect3 = false;
  bool isListening = false;
  String _text = "";
  String speakText = '';
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => {
          if (this.mounted)
            {
              setState(() => this._text = text),
            }
        },
        onListening: (isListening) {
          if (this.mounted) {
            setState(() => this.isListening = isListening);
          }
        },
      );

  speak() async {
    if (this.mounted) {
      await flutterTts.speak(speakText);
    }
  }

  List<bool> answers = [false, false, false];

  List<UserCommands> rinasCommands = [
    UserCommands('Thank you', 'धन्यवाद '),
    UserCommands('Please be kind', 'कृपया दयालु बनें '),
    UserCommands('Don\'t shout', 'चिल्लाओ मत '),
  ];

  List<UserCommands> ravisCommands = [
    UserCommands('you are welcome', 'आपका स्वागत है'),
    UserCommands('yes', 'हां'),
    UserCommands('sorry', 'माफ़ करना'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              '$score / 3',
              style: TextStyle(
                  color: Colors.lightGreen.shade300,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
        title: Text(
          widget.convType,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    RinasMessages(
                      answers: answers,
                      messageIndex: 0,
                      rinasCommands: rinasCommands,
                    ),
                    RavisMessages(
                      answers: answers,
                      messageIndex: 0,
                      ravisCommands: ravisCommands,
                    ),
                    RinasMessages(
                      answers: answers,
                      messageIndex: 1,
                      rinasCommands: rinasCommands,
                    ),
                    RavisMessages(
                      answers: answers,
                      messageIndex: 1,
                      ravisCommands: ravisCommands,
                    ),
                    RinasMessages(
                      answers: answers,
                      messageIndex: 2,
                      rinasCommands: rinasCommands,
                    ),
                    RavisMessages(
                      answers: answers,
                      messageIndex: 2,
                      ravisCommands: ravisCommands,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: Container(
              height: 200,
              width: Size.infinite.width,
              color: Colors.deepOrangeAccent.shade200,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      " \" ${rinasCommands[index].englishCommand} \"  बोलिये",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " Press Mic and Speak",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        endRadius: 80,
        glowColor: Colors.white,
        child: FloatingActionButton(
          child: Icon(
            isListening ? Icons.mic : Icons.mic_none,
            size: 35,
            color: Colors.white,
          ),
          onPressed: () {
            toggleRecording();
            Future.delayed(Duration(milliseconds: 5000), () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: _text.toLowerCase() ==
                              rinasCommands[index].englishCommand.toLowerCase()
                          ? Text(
                              'Points Scored',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Text(
                              'Well Tried',
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold),
                            ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            rinasCommands[index].englishCommand,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _text,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _text.toLowerCase() ==
                                        rinasCommands[index]
                                            .englishCommand
                                            .toLowerCase()
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ],
                      ),
                      actions: [
                        Visibility(
                            visible: _text.toLowerCase() !=
                                    rinasCommands[index]
                                        .englishCommand
                                        .toLowerCase()
                                ? true
                                : false,
                            child: MaterialButton(
                                color: kcolor,
                                onPressed: () {
                                  setState(() {
                                    if (this.mounted) {
                                      _text = "";
                                    }
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Try again',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ))),
                        MaterialButton(
                            color: kcolor,
                            onPressed: () {
                              setState(() {
                                if (_text.toLowerCase() ==
                                    rinasCommands[index]
                                        .englishCommand
                                        .toLowerCase()) {
                                  score++;
                                }
                                _text = "";
                                answers[index] = true;
                                speakText = ravisCommands[index].englishCommand;
                                if (index < rinasCommands.length - 1) {
                                  index++;

                                  print('This is index from btn $index');
                                } else {
                                  print('index overflow');
                                }
                              });

                              Future.delayed(Duration(milliseconds: 1000), () {
                                speak();
                              });
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ))
                      ],
                    );
                  });
            });
            if (index == 2) {
              Future.delayed(Duration(milliseconds: 10000), () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          "Great Effrorts",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          'Score : $score / 3',
                          style: TextStyle(
                            color: Colors.deepPurple.shade900,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        actions: [
                          MaterialButton(
                              color: Colors.green,
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => HomePage()));
                              },
                              child: Text(
                                'Ok',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                        ],
                      );
                    });
              });
            }
          },
        ),
      ),
    );
  }
}

class RavisMessages extends StatelessWidget {
  const RavisMessages({
    Key? key,
    required this.answers,
    required this.ravisCommands,
    required this.messageIndex,
  }) : super(key: key);

  final List<bool> answers;
  final List<UserCommands> ravisCommands;
  final int messageIndex;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: answers[messageIndex] ? true : false,
      child: DelayedDisplay(
        delay: Duration(milliseconds: 1000),
        child: RavisMessageTemplate(
          ravisCommands: ravisCommands,
          messageIndex: messageIndex,
        ),
      ),
    );
  }
}

class RinasMessages extends StatelessWidget {
  const RinasMessages({
    Key? key,
    required this.answers,
    required this.rinasCommands,
    required this.messageIndex,
  }) : super(key: key);

  final List<bool> answers;
  final List<UserCommands> rinasCommands;
  final int messageIndex;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: answers[messageIndex] ? true : false,
      child: DelayedDisplay(
        delay: Duration(milliseconds: 500),
        child: RinasMessageTemplate(
            rinasCommands: rinasCommands, messageIndex: messageIndex),
      ),
    );
  }
}

class RavisMessageTemplate extends StatelessWidget {
  const RavisMessageTemplate({
    Key? key,
    required this.ravisCommands,
    required this.messageIndex,
  }) : super(key: key);

  final List<UserCommands> ravisCommands;
  final int messageIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Color(0xffE3F696),
            radius: 30,
            backgroundImage: AssetImage('assets/boy.png'),
          ),
          SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12)),
            child: Container(
              height: 62.5,
              color: Color(0xffE3F696),
              width: 160,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ravisCommands[messageIndex].englishCommand),
                    Text(ravisCommands[messageIndex].hindiCommand),
                    // speak(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RinasMessageTemplate extends StatelessWidget {
  const RinasMessageTemplate({
    Key? key,
    required this.rinasCommands,
    required this.messageIndex,
  }) : super(key: key);

  final List<UserCommands> rinasCommands;
  final int messageIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12)),
            child: Container(
              height: 62.5,
              color: Color(0xffA7DEF5),
              width: 160,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(rinasCommands[messageIndex].englishCommand),
                    Text(rinasCommands[messageIndex].hindiCommand),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/girl.png'),
          ),
        ],
      ),
    );
  }
}
