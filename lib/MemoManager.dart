import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'Memo.dart';

class MemoManager{

  late Database _memoDatabase;
  late List<Map<String, Object?>> memoList;

  MemoManager(){
    initDatabase();
  }

  void selectAllMemo() async{

    final String sql = """SELECT *
                             FROM memodata
                                ORDER BY create_at DESC"""; //最後に記録したメモを先頭にデータを取得する
    final memoDataRows = await _memoDatabase.rawQuery(sql);
    if(memoDataRows.isEmpty){
      return null;
    }
    memoList = memoDataRows;
  }

  void addMemo(Memo newMemo) async{
    final String sql = """INSERT INTO memodata
                            VALUES(
                               ${newMemo.getUuid},
                               ${newMemo.getTextData},
                               ${newMemo.getCreateAt}
                            )
                       """;
    await _memoDatabase.execute(sql);
  }

  initDatabase() async {
    String makeTableSql =
      """
        CREATE TABLE memodata (
            uuid CHAR(36) PRIMARY KEY NOT NULL,
            textData TEXT NOT NULL,
            create_at DATETIME
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
}