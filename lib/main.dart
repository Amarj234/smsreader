import 'package:flutter/material.dart';
import 'load.dart';






void main() async{
  runApp(MyApp());



}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
debugShowCheckedModeBanner: false,
        home: Scaffold(

          body: loadPage(),
        ),
    );

  }
}



