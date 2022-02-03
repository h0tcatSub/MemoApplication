import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

import 'MemoManager.dart';

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
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TableCalendar(
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
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(MemoManager.getSelectedDay, selectedDay)) {
                    setState(() {
                      MemoManager.setSelectedDay(selectedDay);
                      MemoManager.setNowDateTimeDay(focusedDay);

                      MemoManager.syncMemo();
                    });
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.all(16),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: MemoManager.getMemoList.length,
                itemBuilder: (context, index){
                  return Card(
                    child: ListTile(
                      title: Text(MemoManager.getMemoList[index]["text_data"],style: GoogleFonts.lato()),
                      subtitle: Text(MemoManager.getMemoList[index]["create_at"],style: GoogleFonts.lato()),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}