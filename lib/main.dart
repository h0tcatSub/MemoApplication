import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:memo_application/EditMemoListForm.dart';
import 'package:memo_application/Memo.dart';
import 'package:memo_application/MemoManager.dart';

import 'ShowMemoListForm.dart';

late MemoManager _memoManager;
MemoManager get getMemoManager => _memoManager;

void main() async {
  runApp(MaterialApp(
    //ロケールの設定をする
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const[
      Locale("ja", "JP"),
    ],
    routes: <String, WidgetBuilder>{
      "/": (_) => AddMemoApplication(),
      "/ShowMemo": (_) => const ShowMemoListForm(),
      "/ManagementMemo": (_) => const EditMemoListForm(),
    },
  ));
}

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<MainMenu> createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: GoogleFonts.lato()),
      ),
    );
  }
}

class AddMemoApplication extends StatelessWidget {
  AddMemoApplication({Key? key}) : super(key: key);
  final memoDataController = TextEditingController();

  void _addMemo(){
    if(memoDataController.text == ""){
      Fluttertoast.showToast(msg: "メモがまだ未入力のようです。");
    }else {
      Memo newMemo = Memo(memoDataController.text);
      _memoManager.addMemo(newMemo);

      memoDataController.text = "";
      Fluttertoast.showToast(msg: "メモを追加しました!");
    }
  }
  @override
  Widget build(BuildContext context) {
    _memoManager = MemoManager();

    return Scaffold(
      appBar: AppBar(
        title: Text('メモ記録帳',style: GoogleFonts.lato()),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "メモを入力してください。",
                    ),
                    style: GoogleFonts.lato(),
                    keyboardType: TextInputType.multiline,
                    maxLines: 100,
                    controller: memoDataController,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(32),
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  child: ElevatedButton(
                    child: Text("メモを追加する",style: GoogleFonts.lato()),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      onPrimary: Colors.white,
                    ),
                    onPressed: _addMemo,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(64),
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  child: ElevatedButton(
                    child: Text("登録されているメモの一覧を表示する",style: GoogleFonts.lato()),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrange,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () async {
                      await getMemoManager.syncMemoWithCalender(
                        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString());
                      getMemoManager.setSelectedDay(DateTime.now());
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const ShowMemoListForm()
                      ));
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  child: ElevatedButton(
                    child: Text("登録済みのメモを管理する",style: GoogleFonts.lato()),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrange,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/ManagementMemo");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
