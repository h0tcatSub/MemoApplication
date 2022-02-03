import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:table_calendar/table_calendar.dart';

import 'Memo.dart';

class MemoManager{

  List<Map> _memoList = [];
  late Database _memoDataBase;
  final bool _isNotSmartPhone = Platform.isWindows || Platform.isLinux || Platform.isMacOS;

  DateTime _selectedDay = DateTime.now();
  DateTime _nowDateTime = DateTime.now();
  CalendarFormat _calenderViewFormat = CalendarFormat.month;

  List get getMemoList => _memoList;
  get getCalenderViewFormat => _calenderViewFormat;
  get getNowFocusDateTime => _nowDateTime;
  get getSelectedDay => _selectedDay;

  MemoManager(){
    initDatabase();
  }

  Future<void> syncListWithDate(DateTime selectedDay) async {
    syncMemoWithCalender(
        DateFormat("yyyy-MM-dd").format(selectedDay).toString());
  }

  Future<void> setSelectedDay(DateTime day) async {
    _selectedDay = day;
  }
  Future<void> setNowFocusTimeDay(DateTime day) async{
    _nowDateTime = day;
  }
  void setCalenderViewFormat(CalendarFormat format){
    _calenderViewFormat = format;
  }
  void setMemoList(List<Map> memoList){
    _memoList = memoList;
  }
  Future<void> syncMemoWithCalender(String selectedDay) async{
    _memoList = await _memoDataBase.query("memodata", orderBy: "create_at DESC", where: "create_at=?", whereArgs: [selectedDay]);
  }

  Future<void> syncMemo() async{
    _memoList = await _memoDataBase.query("memodata", orderBy: "create_at DESC");
  }
  Future<void> addMemo(Memo newMemo) async {
    var memoData = <String, dynamic>{
      "uuid": newMemo.getUuid,
      "text_data": newMemo.getTextData,
      "create_at": newMemo.getCreateAt
    };
    await _memoDataBase.insert("memodata", memoData);
  }

  Future<void> deleteMemo(String uuid) async{
    await _memoDataBase.delete("memodata", where: "uuid=?", whereArgs: [uuid]);
  }

  Future<void> updateMemo(String uuid, String newMemo) async{
    var updateValue = <String, dynamic>{
      "text_data": newMemo,
    };
    _memoDataBase.update("memodata", updateValue, where: "uuid=?", whereArgs: [uuid]);
  }

  initDatabase() async {
    String makeTableSql =
    """
        CREATE TABLE memodata (
            uuid CHAR(36) PRIMARY KEY NOT NULL,
            text_data TEXT NOT NULL,
            create_at TEXT NOT NULL
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