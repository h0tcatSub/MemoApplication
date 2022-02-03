import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:memo_application/main.dart';
import 'package:table_calendar/table_calendar.dart';

List _syncList(DateTime selectedDay) {
  getMemoManager.syncMemoWithCalender(
      DateFormat("yyyy-MM-dd").format(selectedDay).toString());
  return getMemoManager.getMemoList;
}
class ShowMemoListForm extends StatefulWidget{
  const ShowMemoListForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShowMemoListForm();
}

class _ShowMemoListForm extends State<ShowMemoListForm>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          title: Text("登録したメモ一覧",style: GoogleFonts.lato())
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
                  onDaySelected: (selectedDay, focusedDay){
                    if (!isSameDay(getMemoManager.getSelectedDay, selectedDay)) {
                      setState(() {
                        getMemoManager.setSelectedDay(selectedDay);
                        getMemoManager.setNowDateTimeDay(focusedDay);
                      });
                    }
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: getMemoManager.getMemoList.length,
                  itemBuilder: (context, index){
                    return Card(
                      child: ListTile(
                        title: _syncList(getMemoManager.getSelectedDay)
                            .map((syncMemo) => Text(syncMemo["text_data"].toString())).toList()[index],
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