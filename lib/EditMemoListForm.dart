import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:memo_application/main.dart';
import 'package:table_calendar/table_calendar.dart';

List _syncList(DateTime selectedDay) {
  getMemoManager.syncMemoWithCalender(
      DateFormat("yyyy-MM-dd").format(selectedDay).toString());
  return getMemoManager.getMemoList;
}

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
                    //メモテーブルを更新して表示用メモリストを最新にする
                    await getMemoManager.updateMemo(
                        uuid,
                        newMemoTextController.text);
                    await getMemoManager.syncMemoWithCalender(
                        DateFormat("yyyy-mm/dd").format(DateTime.now()).toString());
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
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TableCalendar(
                  focusedDay: getMemoManager.getNowDateTime,
                  calendarFormat: getMemoManager.getCalenderViewFormat,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2999, 12, 31),
                  onFormatChanged: (format){
                    //現在のフォーマットと異なっていたら変更を適用する
                    if(getMemoManager.getCalenderViewFormat != format){
                      setState(() => getMemoManager.setCalenderViewFormat(format));
                    }
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(getMemoManager.getSelectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(getMemoManager.getSelectedDay, selectedDay)) {
                      setState(() {
                        getMemoManager.setSelectedDay(selectedDay);
                        getMemoManager.setNowDateTimeDay(focusedDay);
                      });
                      _syncList(getMemoManager.getSelectedDay);
                    }
                  },
                  eventLoader: _syncList,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: getMemoManager.getMemoList.length,
                    itemBuilder: (BuildContext listViewContext, index){
                      return Dismissible(
                        key: UniqueKey(),
                        child: Card(
                          child: ListTile(
                            onTap: () async {
                              await editMemo(
                                  listViewContext,
                                  getMemoManager.getMemoList[index]["uuid"],
                                  getMemoManager.getMemoList[index]["text_data"]);
                            },
                            title: _syncList(getMemoManager.getSelectedDay)
                                .map((syncMemo) => Text(syncMemo["text_data"].toString())).toList()[index],
                          ),
                        ),
                        //メモが横にスワイプされたらメモテーブルからデータを削除してリストを更新する
                        onDismissed: (direction){
                          getMemoManager.deleteMemo(getMemoManager.getMemoList[index]["uuid"]);
                        },
                        background: Container(
                          color: Colors.red,
                        ),
                      );
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
