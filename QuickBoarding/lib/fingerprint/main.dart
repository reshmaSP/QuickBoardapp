import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import 'finger_print_auth.dart';

// void main()=> runApp(MyApp());

class App2 extends StatelessWidget {
  const App2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fingerprint Auth",
      home: FingerprintAuth(),
    );
  }
}
