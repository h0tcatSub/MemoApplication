import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memo_application/main.dart';

class EditMemoListForm extends StatelessWidget{
  const EditMemoListForm({Key? key}) : super(key: key);

  editMemo(BuildContext context, String uuid, String memo)
  {
    //編集内容を入力するダイアログ
    final newMemoTextController = TextEditingController(text: memo);
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("メモを編集", style: GoogleFonts.lato()),
            content: TextField(
              controller: newMemoTextController,
              decoration: InputDecoration(hintText: "メモを入力してください"),
              style: GoogleFonts.lato(),
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
                child: Text("適用",style: GoogleFonts.lato()),
                onPressed: () async {
                  if(newMemoTextController.text == ""){
                    Fluttertoast.showToast(msg: "メモの内容が未入力です。");
                  }else {

                    //メモテーブルを更新してリスト表示も最新の物にする
                    await MainMenu.memoDataManager.updateMemo(
                        uuid,
                        newMemoTextController.text);
                    await MainMenu.memoDataManager.syncMemo();
                    Navigator.pushNamedAndRemoveUntil(context, "/ManagementMemo", ModalRoute.withName("/"));
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
        title: Text(
          "登録メモを管理",
          style: GoogleFonts.lato()),
      ),
      body : ListView.builder(
          itemCount: MainMenu.memoDataManager.getMemoList.length,
          itemBuilder: (BuildContext listViewContext, index){
            return Dismissible(
              key: UniqueKey(),
              child: Card(
                child: ListTile(
                  onTap: () async {
                    await editMemo(
                        listViewContext,
                        MainMenu.memoDataManager.getMemoList[index]["uuid"],
                        MainMenu.memoDataManager.getMemoList[index]["text_data"]);

                    debugPrint(MainMenu.memoDataManager.getMemoList[0]["text_data"]);
                  },
                  title: Text(MainMenu.memoDataManager.getMemoList[index]["text_data"],style: GoogleFonts.lato()),
                  subtitle: Text(MainMenu.memoDataManager.getMemoList[index]["create_at"],style: GoogleFonts.lato()),
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