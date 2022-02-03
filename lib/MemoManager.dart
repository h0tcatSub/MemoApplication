import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:table_calendar/table_calendar.dart';

import 'Memo.dart';

class MemoManager{

  static List<Map> _memoList = [];
  static late Database _memoDataBase;
  static final bool _isNotSmartPhone = Platform.isWindows || Platform.isLinux || Platform.isMacOS;

  static late DateTime _selectedDay = DateTime.now();
  static DateTime _nowDateTime = _selectedDay;
  static CalendarFormat _calenderViewFormat = CalendarFormat.month;

  static List<Map> get getMemoList => _memoList;
  static get getCalenderViewFormat => _calenderViewFormat;
  static get getNowDateTime => _nowDateTime;
  static get getSelectedDay => _selectedDay;

  static void setSelectedDay(DateTime day){
    _selectedDay = day;
  }
  static void setNowDateTimeDay(DateTime day){
    _nowDateTime = day;
  }
  static void setCalenderViewFormat(CalendarFormat format){
    _calenderViewFormat = format;
  }
  void setMemoList(List<Map> memoList){
    _memoList = memoList;
  }
  static Future<void> syncMemoWithCalender(String selectedDay) async{
    _memoList = await _memoDataBase.query("memodata", orderBy: "create_at DESC", where: "create_at=?", whereArgs: [selectedDay]);
  }

  static Future<void> syncMemo() async{
    _memoList = await _memoDataBase.query("memodata", orderBy: "create_at DESC");
  }
  static void addMemo(Memo newMemo){
    var memoData = <String, dynamic>{
      "uuid": newMemo.getUuid,
      "text_data": newMemo.getTextData,
      "create_at": newMemo.getCreateAt
    };
    _memoDataBase.insert("memodata", memoData);
  }

  static void deleteMemo(String uuid) async{
    await _memoDataBase.delete("memodata", where: "uuid=?", whereArgs: [uuid]);
  }

  static Future<void> updateMemo(String uuid, String newMemo) async{
    var updateValue = <String, dynamic>{
      "text_data": newMemo,
    };
    _memoDataBase.update("memodata", updateValue, where: "uuid=?", whereArgs: [uuid]);
  }

  static initDatabase() async {
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
      _memoDataBase = await databaseFactory.openDatabase(path);
      await _memoDataBase.execute(makeTableSql);
    }else{ //プラットフォームがスマートフォン系の場合、Ffiのバージョンは使用しない。
      var databasePath = await getApplicationDocumentsDirectory();
      var path = join(databasePath.path, "memoData.db");
      _memoDataBase = await openDatabase(path);
      await _memoDataBase.execute(makeTableSql);
    }
    return _memoDataBase;
  }

}