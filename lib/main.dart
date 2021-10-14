import 'package:conversation_game/provider%20model/model.dart';
import 'package:conversation_game/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(ChangeNotifierProvider(
      create: (context) => IncrementCounter(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Conversation Game",
        theme: ThemeData(
            textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        )),
        home: SplashScreen(),
      );
}
