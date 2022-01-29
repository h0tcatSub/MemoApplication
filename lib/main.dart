import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memo_application/EditMemoListForm.dart';
import 'package:memo_application/Memo.dart';
import 'package:memo_application/MemoManager.dart';

import 'ShowMemoListForm.dart';


void main() async {
  runApp(new MaterialApp(

    routes: <String, WidgetBuilder>{
      "/": (_) => new AddMemoApplication(),
      "/ShowMemo": (_) => new ShowMemoListForm(),
      "/ManagementMemo": (_) => new EditMemoListForm(),
    },
  ));
}

class AddMemoApplication extends StatelessWidget {
  AddMemoApplication({Key? key}) : super(key: key);
  final memoDataController = TextEditingController();

  void _addMemo(){
    if(memoDataController.text == ""){
      Fluttertoast.showToast(msg: "メモがまだ未入力のようです。");
    }else {
      Memo newMemo = Memo(memoDataController.text);
      MainMenu.memoDataManager.addMemo(newMemo);

      MainMenu.memoDataManager.syncMemo();
      memoDataController.text = "";
      Fluttertoast.showToast(msg: "メモを追加しました!");
    }
  }
  @override
  Widget build(BuildContext context) {
    MainMenu.memoDataManager = MemoManager();
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
                    onPressed: (){
                      MainMenu.memoDataManager.syncMemo();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ShowMemoListForm()
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
                    onPressed: (){
                      MainMenu.memoDataManager.syncMemo();
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

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key, required this.title}) : super(key: key);

  final String title;
  static late MemoManager memoDataManager;

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
