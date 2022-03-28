import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods{

  getUserByUsername(String userName) async {
  return await  Firestore.instance.collection("users").where("name", isEqualTo: userName ).getDocuments();
  }
getUserByEmail(String userEmail) async {
  return await  Firestore.instance.collection("users").where("email", isEqualTo: userEmail ).getDocuments();
  }
  uplaodUserInfo(userMap){
    Firestore.instance.collection("users").add(userMap);
  }

  createChatRoom( chatroomid, chatRoomMap){
    Firestore.instance.collection("chatRoom").document(chatroomid).setData(chatRoomMap);
  }

  addConversationMessages(String chatRoomId, messageMap){
    Firestore.instance.collection("chatRoom").document(chatRoomId).collection("chats").add(messageMap);
  }
  getConversationMessages(String chatRoomId) async{
   return await Firestore.instance.collection("chatRoom").document(chatRoomId).collection("chats").
   orderBy("time",descending: false)
   .snapshots();
  }


  getChatRooms(String userName) async{

    return await Firestore.instance.collection("chatRoom").where("users", arrayContains: userName).snapshots();

  }
}