class ChatWithOtherUser {
  String chatId;
  final User otherUser;
  String otherChatId;
  final String lastMessage;

  ChatWithOtherUser(
      {this.chatId, this.otherUser, this.otherChatId, this.lastMessage});
}

class User {
  final String displayName;
  final String email;
  final String photoUrl;
  final String uid;

  User({this.displayName, this.email, this.photoUrl, this.uid});
}
