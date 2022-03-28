import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:ChatApp/views/chatroom.dart';
import 'package:ChatApp/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:toast/toast.dart';

import 'helper/helperfunctions.dart';


class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  AuthMethod authMethod = new AuthMethod();
  final formkey=GlobalKey<FormState>();
  TextEditingController emailText=new TextEditingController();
  TextEditingController passwordText=new TextEditingController();
  bool isLoading=false;
  QuerySnapshot snapUserInfo;
  signIn() async {

    

    HelperFunctions.saveUserEmailSharedPreference(emailText.text);
   // HelperFunctions.saveUserNameSharedPreference(usernameText.text);
   // HelperFunctions.saveUserLoggedInSharedPreference(isUserLoggedIn)

   
        if(formkey.currentState.validate()){
        
        setState(() {

        isLoading = true;
      });
    try{
      await dataBaseMethods.getUserByEmail(emailText.text).then((val){

        snapUserInfo=val;
        
        HelperFunctions.saveUserNameSharedPreference(snapUserInfo.documents[0].data["name"]);
        

      });
    }
    catch(e){
      Fluttertoast.showToast(
        msg: "This Email Not Exist or may password is wrong. Also check Internet Connection.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    }

  authMethod.signInWithEmailAndPassword(emailText.text, passwordText.text).then((value) {
    if(value !=null){

      HelperFunctions.saveUserLoggedInSharedPreference(true);
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => chatRoom() 
      ));

    

    }
    else{

      
    }
  });
  
        }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:appBarMain(context),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
                  child: Column(
            mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: formkey,
                          child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value) ?
                          null : "Enter correct email";
                  },
              controller: emailText,
                style: simpletextStyle(),
                decoration: texFieldInputDecoration(
                  "Email"
                ),
              ),
              TextFormField(
                obscureText: true,
              validator:  (val){
                      return val.length < 6 ? "Enter Password 6+ characters" : null;
                    },
              controller: passwordText,
                style: simpletextStyle(),
                decoration: texFieldInputDecoration(
                  "Password"
                ),
              ),
                ],
              ),
            ),
            SizedBox(height: 8,),
            Container(
              alignment: Alignment.centerRight,
              child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              child: Text("Forgot Password?",style:simpletextStyle()),
            ),
            ),
            SizedBox(height: 8,),
            GestureDetector(
              onTap: () {
                signIn();
              },
                          child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xff007EF4),
                      const Color(0xff2A75BC)
                    ]
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text("Sign In", style: simpletextStyle(),),
              ),
            ),
            SizedBox(height: 16,),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text("Sign In with Google", style: TextStyle(
                color: Colors.black,
                fontSize: 16
              ),),
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? ", style: simpletextStyle(),),
                GestureDetector(
                  onTap: () {
                    widget.toggle();
                  },
                                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text("Create one",style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    decoration: TextDecoration.underline
              ),),
                  ),
                )
              ],
            ),
            SizedBox(height: 80,),
          ],
      ),
        ),
      ),
      )
    );
  }
}