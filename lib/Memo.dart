import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Memo{
  String _uuid = "";
  String _textData = "";
  String _createAt = "";
  static const String _memoFormat = "yyyy-MM-dd";

  static String get getMemoFormat => _memoFormat;
  String get getUuid => _uuid;
  String get getTextData => _textData;
  String get getCreateAt => _createAt;
  set setUuid(String uuid) => _uuid = uuid;
  set setTextData(String textData) => _textData = textData;
  set setCreateAt(String createAt) => _createAt = createAt;

  Memo(String textData){
    _textData = textData;
    _uuid     = const Uuid().v1();
    _createAt = DateFormat(_memoFormat).format(DateTime.now()).toString();
  }
}