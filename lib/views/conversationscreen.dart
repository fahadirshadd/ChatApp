
import 'package:http/http.dart' as http;
import 'package:ChatApp/helper/constants.dart';
import 'package:ChatApp/services/database.dart';
import 'package:ChatApp/widget.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomID;
  ConversationScreen(this.chatRoomID);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  TextEditingController messageController=new TextEditingController();

  DataBaseMethods dataBaseMethods=new DataBaseMethods();

  Stream chatMessagesStream;
  Widget chatMessageList(){
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context,snapshot){
            return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return MessageTile(snapshot.data.documents[index].data["message"],
                snapshot.data.documents[index].data["sendBy"]==Constants.myName
                );
              },
            ):Container();
      }
      );
    
    }

  sendMessage(){
    if(messageController.text.isNotEmpty){
    Map<String,dynamic> messageMap={
      "message": messageController.text,
      "sendBy":Constants.myName,
      "time":DateTime.now().millisecondsSinceEpoch
    };
    dataBaseMethods.addConversationMessages(widget.chatRoomID, messageMap);
    messageController.text="";
    }
  }  

  @override
  void initState() {
    dataBaseMethods.getConversationMessages(widget.chatRoomID).then((value){
      setState(() {
        chatMessagesStream=value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
                          child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(child: TextField(
                      controller: messageController,
                      style: TextStyle(
                          color: Colors.white,
                        ),
                      decoration: InputDecoration(
                        hintText: "Type Message...",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none
                      )
                    )
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
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
                        child: Image.asset("assets/images/send.png")),
                    )
                  ],
                ),
              ),
            )
          
          ],
        ),
      ),
    );
  }
}
class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message,this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: isSendByMe ? 0 : 24,
          right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ?Alignment.centerRight:Alignment.bottomLeft ,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
              ],
              ),
              borderRadius: isSendByMe? 
              BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
              ):
              BorderRadius.only(

                topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
          bottomRight: Radius.circular(23)
              )
            ),
        child: Text(message, style:TextStyle(
      color: Colors.white,
      fontSize: 16
  ),),
      ),
    );
  }
}