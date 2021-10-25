import 'package:minor/DB/DbNames.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class DbProvider{
  init()async{
    _infoTable = InfoTable();
    _friendsTable = FriendsTable();
    _chatRooms = ChatRooms();
    print("sdsdfaf");
    Directory dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'MinorDb.db');
    print(dir.path);
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version)async{
        await newDb.execute(
          """
          create table ${_infoTable.name}(
            ${_infoTable.uid} text primary key,
            ${_infoTable.email} text,
            ${_infoTable.phone} text,
            ${_infoTable.name} text,
            ${_infoTable.userName} text,
          );
          """
        );

        await newDb.execute(
          """
          create table ${_friendsTable.tableName}(
            ${_friendsTable.uid} text primary key,
            ${_friendsTable.index} integer,
            ${_friendsTable.name} text,
          );
          """
        );
        
        await newDb.execute(
          """
          create table ${_chatRooms.tableName}(
            ${_chatRooms.id} text primary key,
          );
          """
        );
      }
    );
    print('got db');
    print('$db in db');
    return db;
  }

  /*
    ***DECLARATION***
  */
  late final Database db;
  late final FriendsTable _friendsTable;
  late final ChatRooms _chatRooms;
  late final InfoTable _infoTable;

  /*
    ***METHODS***
  */

  void addInFriends(String tableName, List<dynamic> values){
    db.rawInsert(
      '''
      insert into ${tableName} values(${values});
      '''
    );
  }
}