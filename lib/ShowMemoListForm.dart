import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memo_application/main.dart';
import 'package:table_calendar/table_calendar.dart';

class ShowMemoListForm extends StatefulWidget{
  const ShowMemoListForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShowMemoListForm();
}

class _ShowMemoListForm extends State<ShowMemoListForm>{
  @override
  Widget build(BuildContext context){
    //一回目は現在の日付ででメモを取得する
    return Scaffold(
      appBar: AppBar(
          title: Text("登録したメモ一覧",style: GoogleFonts.lato())
      ),
      body : Container(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TableCalendar(
                  focusedDay: getMemoManager.getNowFocusDateTime,
                  calendarFormat: getMemoManager.getCalenderViewFormat,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2999, 12, 31),

                  onPageChanged: (focusDay){
                    getMemoManager.setNowFocusTimeDay(focusDay);
                  },
                  onFormatChanged: (format){
                    //現在のフォーマットと異なっていたら変更を適用する
                    if(getMemoManager.getCalenderViewFormat != format){
                      setState(() => getMemoManager.setCalenderViewFormat(format));
                    }
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(getMemoManager.getSelectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) async {
                    if (!isSameDay(getMemoManager.getSelectedDay, selectedDay)) {
                      await getMemoManager.setSelectedDay(selectedDay);
                      await getMemoManager.setNowFocusTimeDay(focusedDay);
                      await getMemoManager.syncListWithDate(getMemoManager.getSelectedDay);

                      setState(() {});
                    }
                  },

                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: getMemoManager.getMemoList.length ,
                  itemBuilder: (context, index){
                    return Card(
                      child: ListTile(
                        title: Text(getMemoManager.getMemoList[index]["text_data"]),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}