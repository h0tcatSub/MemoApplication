import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'Memo.dart';

class MemoManager{

  late Database _memoDatabase;
  late List<dynamic> _memoList = [];

  MemoManager(){
    initDatabase();
  }

  List get getMemoList => _memoList;
  void selectAllMemo() async{
    _memoList = await _memoDatabase.query("memodata", orderBy: "create_at DESC");
  }

  void addMemo(Memo newMemo){
    var memoData = <String, dynamic>{
      "uuid": newMemo.getUuid,
      "text_data": newMemo.getTextData,
      "create_at": newMemo.getCreateAt
    };
    _memoDatabase.insert("memodata", memoData);
  }

  void runSQL(String sql){
    reOpenDatabase();
    _memoDatabase.execute(sql);
  }

  void deleteMemo(String uuid){
    _memoDatabase.delete("memodata", where: "uuid=?", whereArgs: [uuid]);
  }

  void updateMemo(String uuid, String newMemo) async{
    var updateValue = <String, dynamic>{
      "text_data": newMemo,
      "create_at": DateTime.now().toIso8601String(),
    };
    _memoDatabase.update("memodata", updateValue, where: "uuid=?", whereArgs: [uuid]);
  }

  initDatabase() async {
    String makeTableSql =
      """
        CREATE TABLE memodata (
            uuid CHAR(36) PRIMARY KEY NOT NULL,
            text_data TEXT NOT NULL,
            create_at TEXT
        )
      """;
    if(Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
      var databasePath = await getApplicationDocumentsDirectory();
      var path = join(databasePath.path, "memoData.db");
      _memoDatabase = await databaseFactory.openDatabase(path);
      await _memoDatabase.execute(makeTableSql);
    }else{ //プラットフォームがスマートフォン系の場合、Ffiのバージョンは使用しない。
      var databasePath = await getApplicationDocumentsDirectory();
      var path = join(databasePath.path, "memoData.db");
      _memoDatabase = await openDatabase(path);
      await _memoDatabase.execute(makeTableSql);
    }
    return _memoDatabase;
  }

  //データベースを再オープンする
  void reOpenDatabase() async{
    if(Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
      var databasePath = await getApplicationDocumentsDirectory();
      var path = join(databasePath.path, "memoData.db");
      _memoDatabase = await databaseFactory.openDatabase(path);
    }else{
      var databasePath = await getApplicationDocumentsDirectory();
      var path = join(databasePath.path, "memoData.db");
      _memoDatabase = await openDatabase(path);
    }
  }
}