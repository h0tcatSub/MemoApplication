import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memo_application/main.dart';

class EditMemoListForm extends StatelessWidget{

  late int _memoSize;

  EditMemoListForm(){
    _memoSize = MainMenu.memoDataManager.selectAllMemo() as int;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("登録メモを管理")
      ),
      body : ListView.builder(
        itemCount: _memoSize,
        itemBuilder: (context, index){
          return Dismissible(
            key: UniqueKey(),
            child: Card(
              child: ListTile(
                title: Text(MainMenu.memoDataManager.memoList[index]["textData"]),
              ),
            ),
            onDismissed: (direction){
              MainMenu.memoDataManager.deleteMemo(MainMenu.memoDataManager.memoList[index]["uuid"]);
              MainMenu.memoDataManager.memoList.remove(MainMenu.memoDataManager.memoList[index]["uuid"]);
            },
            background: Container(
              color: Colors.red,
            ),
          );
        }
      ),
    );
  }
}