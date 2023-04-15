import 'package:flutter/material.dart';
import './app_home.dart';

// void main() => runApp(MyApp());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.grey,
        scaffoldBackgroundColor: Colors.black,
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          buttonColor: Colors.purpleAccent,
        ),
      ),
      home: AppHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}
