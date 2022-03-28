import 'package:ChatApp/helper/authenticate.dart';
import 'package:ChatApp/helper/constants.dart';
import 'package:ChatApp/helper/helperfunctions.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:ChatApp/signin.dart';
import 'package:ChatApp/views/conversationscreen.dart';
import 'package:ChatApp/views/search.dart';
import 'package:ChatApp/widget.dart';
import 'package:flutter/material.dart';

class chatRoom extends StatefulWidget {
  @override
  _chatRoomState createState() => _chatRoomState();
}

String _myName;

class _chatRoomState extends State<chatRoom> {

  AuthMethod authMethod =new AuthMethod();
  DataBaseMethods dataBaseMethods=new DataBaseMethods();

  Stream chatRoomsStream;
@override
void initState() { 
  GetUserInfo();
  
  
  super.initState();
  
}

Widget chatRoomList(){
  return StreamBuilder(
    stream: chatRoomsStream,
    builder: (context,snapshot){
      return snapshot.hasData? ListView.builder(
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context,index){
          return ChatRoomTile(
            snapshot.data.documents[index].data["chatroomid"].toString()
            .replaceAll("_", "").replaceAll(Constants.myName, ""),
            snapshot.data.documents[index].data["chatroomid"]
          );
        }
      ):Container();
    }
    );
}


GetUserInfo() async{
  _myName=await HelperFunctions.getUserNameSharedPreference();
  dataBaseMethods.getChatRooms(Constants.myName).then((value){
    setState(() {
      chatRoomsStream=value;
    });
  });
  print(_myName+" username success.");
  Constants.myName=_myName;
  setState(() {
    
  });
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    title: Image.asset(
      "assets/images/logo.png",
      height: 40,
    ),
    elevation: 0.0,
    centerTitle: false,
    actions: [
      GestureDetector(
          onTap: () {
            authMethod.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate())
            );
          },
         child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Icon(Icons.exit_to_app))
      ),
        
    ],
    
  ),
  body: chatRoomList(),
      floatingActionButton: FloatingActionButton( 
      child: Icon(Icons.search),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()
         ));
      },
      ),
    );
  }
}


class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomID;
  ChatRoomTile(this.userName,this.chatRoomID);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder:(context) => ConversationScreen(chatRoomID) ));
      },
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}"),
            ),
            SizedBox(width: 8,),
            Text(userName,style: simpletextStyle(),)
          ],
        ),
      ),
    );
  }
}