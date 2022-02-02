import 'package:uuid/uuid.dart';

class Memo{
  String _uuid = "";
  String _textData = "";
  String _createAt = "";

  String get getUuid => _uuid;
  String get getTextData => _textData;
  String  get getCreateAt => _createAt;

  set setUuid(String uuid) => _uuid = uuid;
  set setTextData(String textData) => _textData = textData;
  set setCreateAt(String createAt) => _createAt = createAt;

  Memo(String textData){
    _textData = textData;
    _uuid     = Uuid().v1();
    _createAt = DateTime.now().toIso8601String();
  }
}