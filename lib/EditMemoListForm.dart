import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:memo_application/main.dart';

class EditMemoListForm extends StatefulWidget{
  const EditMemoListForm({Key? key}) : super(key: key);

  @override
  _EditMemoListForm createState() => _EditMemoListForm();
}

class _EditMemoListForm extends State<EditMemoListForm>{

  editMemo(BuildContext context, String uuid, String memo)
  {
    //編集内容を入力するダイアログ
    final newMemoTextController = TextEditingController(text: memo);
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("メモを編集"),
            content: TextField(
              controller: newMemoTextController,
              decoration: InputDecoration(hintText: "メモを入力してください"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.white,
                textColor: Colors.red,
                child: Text("キャンセル"),
                onPressed: (){
                  newMemoTextController.text = "";
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                color: Colors.white,
                textColor: Colors.black,
                child: Text("適用"),
                onPressed: () {
                  if(newMemoTextController.text == ""){
                    Fluttertoast.showToast(msg: "メモの内容が未入力です。");
                  }else {
                    MainMenu.memoDataManager.updateMemo(
                        uuid,
                        newMemoTextController.text);
                    MainMenu.memoDataManager.syncMemo();
                    Navigator.pop(context, MainMenu.memoDataManager.getMemoList);
                  }
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          title: Text("登録メモを管理"),
      ),
      body : ListView.builder(
          itemCount: MainMenu.memoDataManager.getMemoList.length,
          itemBuilder: (context, index){
            return Dismissible(
              key: UniqueKey(),
              child: Card(
                child: ListTile(
                  onTap: () async {
                    await editMemo(
                        context,
                        MainMenu.memoDataManager.getMemoList[index]["uuid"],
                        MainMenu.memoDataManager.getMemoList[index]["text_data"]);
                    MainMenu.memoDataManager.syncMemo();
                  },
                  title: Text(MainMenu.memoDataManager.getMemoList[index]["text_data"]),
                  subtitle: Text(MainMenu.memoDataManager.getMemoList[index]["create_at"]),
                ),
              ),
              onDismissed: (direction){
                MainMenu.memoDataManager.deleteMemo(MainMenu.memoDataManager.getMemoList[index]["uuid"]);
                MainMenu.memoDataManager.syncMemo();
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