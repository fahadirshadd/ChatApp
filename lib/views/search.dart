import 'package:ChatApp/helper/constants.dart';
import 'package:ChatApp/services/database.dart';
import 'package:ChatApp/views/conversationscreen.dart';
import 'package:ChatApp/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DataBaseMethods dataBaseMethods =new DataBaseMethods();

  TextEditingController searchText=new TextEditingController();
  QuerySnapshot searchSnapShot;

  Widget searchList(){
  return searchSnapShot != null ? ListView.builder(
    itemCount: searchSnapShot.documents.length,
    shrinkWrap: true,
    itemBuilder: (context, index){
      return searchTile(
        userName: searchSnapShot.documents[index].data["name"],
        userEmail: searchSnapShot.documents[index].data["email"],
      );
    }
  
  ) : Container();
}



initiateSearch(){
  dataBaseMethods.getUserByUsername(searchText.text).then((val){
                          print(val.toString());
                          setState(() {
                          searchSnapShot=val;  
                          });
                          
                      });
}


createChatRoomAndStartConversation(String userName){

  if(userName != Constants.myName){
    
    print(Constants.myName.toString()+" + "+userName.toString()+" It's working till here");
    String chatRoomId=getChatRoomId(Constants.myName,userName);
    
  List<String> users =[Constants.myName,userName];

  Map<String,dynamic> chatRoomMap={
    "users":users,
    "chatroomid":chatRoomId
  };

  dataBaseMethods.createChatRoom(chatRoomId,chatRoomMap);
  
  Navigator.push(context, MaterialPageRoute(
      builder: (context) => ConversationScreen(chatRoomId)
    ));
  }

}

Widget searchTile({final String userName,
  final String userEmail}){
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: simpletextStyle(),),
              Text(userEmail, style: simpletextStyle(),)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(
                userName
              );
            },
                      child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Message",style: simpletextStyle(),),
            ),
          )
        ],
      ),
    );
  
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(child: TextField(
                    controller: searchText,
                    style: TextStyle(
                        color: Colors.white,
                      ),
                    decoration: InputDecoration(
                      hintText: "Search Usrname...",
                      hintStyle: TextStyle(
                        color: Colors.white54,
                      ),
                      border: InputBorder.none
                    )
                  )
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                                      child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0x36FFFFFF),
                          const Color(0x0FFFFFFF)
                        ]
                        ),
                        borderRadius: BorderRadius.circular(40)
                      ),
                      padding: EdgeInsets.all(12),
                      child: Image.asset("assets/images/search_white.png")),
                  )
                ],
              ),
            )
          ,
          searchList()
          ],
        ),
      ),
    );
  }
}






 getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }