class DbNames{
  final InfoTable infoTable = InfoTable();
  final FriendsTable friendsTable = FriendsTable();
  final ChatRooms chatRooms = ChatRooms();
  Chat chat(String table){
    return Chat(table);
  }
  final Index index = Index();
}

class Index{
  String tablename = 'index';
  String index = 'index';
}

class InfoTable{
  final String tableName = 'info';
  final String email = 'email';
  final String name = 'name';
  final String userName = 'uname';
  final String uid = 'uid';
  final String phone = 'phno';
}

class Indexes{
  final String friends= 'friends';
}

class FriendsTable{
  final String tableName = 'friendsList';
  final String uid = 'uid';
  final String index = 'index';
  final String name = 'name';
}

class ChatRooms{
  final String tableName = 'chatRooms';
  final String id = 'roomId';
}

class Chat{
  Chat(String table){
    tableName = table;
  }

  late final String tableName;
  final String message = 'message';
  final String senderId = 'senderId';
  final String timeStamp = 'timeStamp';
}