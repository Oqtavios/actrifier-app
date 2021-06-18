import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data.dart';
import 'actors_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  var app = App(child: MyApp());
  await app.initialize();

  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.brown.shade800,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'Actrifier',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        accentColor: Colors.brown.shade300,
        brightness: Brightness.dark,
        canvasColor: Colors.brown.shade900,
        cardColor: Colors.brown.shade700,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.brown.shade900,
        ),
        bottomAppBarColor: Colors.brown.shade800,
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xff9e9e9e).withOpacity(0.9),
          contentTextStyle: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      home: ActorsView(),
    );
  }
}
