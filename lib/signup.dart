import 'package:ChatApp/helper/helperfunctions.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:ChatApp/views/chatroom.dart';
import 'package:ChatApp/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final formkey=GlobalKey<FormState>();
  bool isLoading=false;
  TextEditingController usernameText=new TextEditingController();
  TextEditingController emailText=new TextEditingController();
  TextEditingController passwordText=new TextEditingController();

  FirebaseAuth firebaseAuth= FirebaseAuth.instance;
  AuthMethod authMethod = new AuthMethod();
  DataBaseMethods dataBaseMethods=new DataBaseMethods();

  signMeUp(){
    if (formkey.currentState.validate()){
      Map<String,String> userInfoMap={
      "name" : usernameText.text,
      "email" : emailText.text

      
    };

    HelperFunctions.saveUserEmailSharedPreference(emailText.text);
    HelperFunctions.saveUserNameSharedPreference(usernameText.text);
   // HelperFunctions.saveUserLoggedInSharedPreference(isUserLoggedIn)
        setState(() {

        isLoading = true;
      });

    authMethod.signUpWithEmailAndPassword(emailText.text, passwordText.text).then((value) { 
      //print("");

    

    dataBaseMethods.uplaodUserInfo(userInfoMap);
    HelperFunctions.saveUserLoggedInSharedPreference(true);
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => chatRoom() ));

    });

    

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:appBarMain(context),
      body: isLoading ? Container(child: Center(child: CircularProgressIndicator()),): SingleChildScrollView(
        child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: formkey,
                      child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    return value.isEmpty || value.length < 2 ? "Field is Empty." : null;
                  },
              controller: usernameText,
              style: simpletextStyle(),
              decoration: texFieldInputDecoration(
                "Username"
              ),
            ),
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
              signMeUp();
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
              child: Text("Sign Up", style: simpletextStyle(),),
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
            child: Text("Sign Up with Google", style: TextStyle(
              color: Colors.black,
              fontSize: 16
            ),),
          ),
          SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account? ", style: simpletextStyle(),),
              GestureDetector(
                onTap: () {
                  widget.toggle();
                },
                              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text("Sign In",style: TextStyle(
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
      )
      );
    
  }
}