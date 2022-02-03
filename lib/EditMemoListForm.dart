import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memo_application/main.dart';
import 'package:table_calendar/table_calendar.dart';

import 'MemoManager.dart';

class EditMemoListForm extends StatefulWidget{
  const EditMemoListForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditMemoListForm();
}

class _EditMemoListForm extends State<EditMemoListForm>{

  editMemo(BuildContext context, String uuid, String memo)
  {
    //編集内容を入力するダイアログを表示する
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
                child: Text("キャンセル", style: GoogleFonts.lato()),
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

                    //メモテーブルを更新してメモリストを更新する
                    await MainMenu.getMemoDataManager.updateMemo(
                        uuid,
                        newMemoTextController.text);
                    await MainMenu.getMemoDataManager.syncMemo();
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
      body : Center(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Container(
                width: double.infinity,
                height: 100,
                child: TableCalendar(
                  focusedDay: MemoManager.getNowDateTime,
                  calendarFormat: MemoManager.getCalenderViewFormat,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2099, 12, 31),
                  onFormatChanged: (format){
                    //現在のフォーマットと異なっていたら変更を適用する
                    if(MemoManager.getCalenderViewFormat != format){
                      setState(() => MemoManager.setCalenderViewFormat(format));
                    }
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(MemoManager.getSelectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay){
                    if(!isSameDay(MemoManager.getSelectedDay, selectedDay)){
                      setState(() {
                        MemoManager.setSelectedDay(selectedDay);
                        MemoManager.setNowDateTimeDay(focusedDay);

                        MainMenu.getMemoDataManager.syncMemo(focusedDay.now().toUtc());
                      });
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
              ),
              Container(
                width: double.infinity,
                height: 100,
                child: ListView.builder(
                  itemCount: MainMenu.getMemoDataManager.getMemoList.length,
                  itemBuilder: (BuildContext listViewContext, index){
                  return Dismissible(
                    key: UniqueKey(),
                    child: Card(
                    child: ListTile(
                    onTap: () async {
                      await editMemo(
                        listViewContext,
                        MainMenu.getMemoDataManager.getMemoList[index]["uuid"],
                        MainMenu.getMemoDataManager.getMemoList[index]["text_data"]);

                        },
                        title: Text(MainMenu.getMemoDataManager.getMemoList[index]["text_data"],style: GoogleFonts.lato()),
                        subtitle: Text("作成日: ${MainMenu.getMemoDataManager.getMemoList[index]["create_at"]}",style: GoogleFonts.lato()),
                        ),
                        ),

                        //メモが横にスワイプされたらメモテーブルからデータを削除してリストを更新する
                        onDismissed: (direction){
                        MainMenu.getMemoDataManager.deleteMemo(MainMenu.getMemoDataManager.getMemoList[index]["uuid"]);
                        },
                        background: Container(
                        color: Colors.red,
                      ),
                    );
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
