import 'package:ChatApp/helper/authenticate.dart';
import 'package:ChatApp/helper/helperfunctions.dart';
import 'package:ChatApp/signin.dart';
import 'package:ChatApp/signup.dart';
import 'package:ChatApp/views/chatroom.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userLoggedIn=false;

  @override
  void initState() {
    // TODO: implement initState
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
     HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primaryColor:  Color(),
       scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
    
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userLoggedIn ? chatRoom() : Authenticate() ,
    );
  }
}

