import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'Memo.dart';

class MemoManager{

  late Database _memoDatabase;
  late List<Map> _memoList = [];
  final bool _isNotSmartPhone = Platform.isWindows || Platform.isLinux || Platform.isMacOS;

  MemoManager(){
    initDatabase();
  }

  List<Map> get getMemoList{
    syncMemo();
    return _memoList;
  }
  void setMemoList(List<Map> memoList){
    _memoList = memoList;
  }
  Future<void> syncMemo() async{
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

  void deleteMemo(String uuid) async{
    await _memoDatabase.delete("memodata", where: "uuid=?", whereArgs: [uuid]);
  }

  Future<void> updateMemo(String uuid, String newMemo) async{
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
    if(_isNotSmartPhone) {
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

}