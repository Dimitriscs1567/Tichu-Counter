import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tichucounter/pages/home_page.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).whenComplete((){
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tichu Counter',
      home: HomePage(),
    );
  }
}