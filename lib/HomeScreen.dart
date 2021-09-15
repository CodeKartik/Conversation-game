import 'package:conversation_game/Game2.dart';
import 'package:conversation_game/GameScreen.dart';
import 'package:conversation_game/speech_api.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String text = 'Press mic and speak';
  bool isListening = false;

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => {
          if (this.mounted)
            {
              setState(() => this.text = text),
            }
        },
        onListening: (isListening) {
          if (this.mounted) {
            setState(() => this.isListening = isListening);
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xffFE834A),
        appBar: AppBar(
          title: Text(
            "Conversation Game",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: AvatarGlow(
        //   animate: isListening,
        //   endRadius: 100,
        //   glowColor: Theme.of(context).primaryColor,
        //   child: FloatingActionButton(
        //     child: Icon(
        //       isListening ? Icons.mic : Icons.mic_none,
        //       size: 46,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       toggleRecording();
        //     },
        //   ),
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => GameScreen(
                                convType: "Good Manners",
                              )));
                },
                minWidth: size.width,
                height: 50,
                child: Text('Good Manners'),
              ),
              SizedBox(height: 20),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => Game2(
                                convType: "Out of Home",
                              )));
                },
                minWidth: size.width,
                height: 50,
                child: Text('Out of Home'),
              ),
            ],
          ),
        ));
  }
}
