import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset(
      "assets/images/logo.png",
      height: 40,
    ),
    elevation: 0.0,
    centerTitle: false,
  );
}

InputDecoration texFieldInputDecoration(String hintText){
  return InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.white
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color:Colors.white)
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color:Colors.white)
              )
            );
}
TextStyle simpletextStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 16
  );

}