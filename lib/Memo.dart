import 'package:uuid/uuid.dart';

class Memo{
  late String _uuid;
  late String _textData;
  late DateTime _createAt;

  String get getUuid => _uuid;
  String get getTextData => _textData;
  DateTime  get getCreateAt => _createAt;

  set setUuid(String uuid) => _uuid = uuid;
  set setTextData(String textData) => _textData = textData;
  set setCreateAt(DateTime createAt) => _createAt = createAt;

  Memo(String textData){
    _textData = textData;
    _uuid     = Uuid().v1();
    _createAt = DateTime.now();
  }

}
