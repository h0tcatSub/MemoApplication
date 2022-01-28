import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:memo_application/EditMemoListForm.dart';
import 'package:memo_application/Memo.dart';
import 'package:memo_application/MemoManager.dart';

import 'ShowMemoListForm.dart';


void main() async {
  runApp(
    const AddMemoApplication(),
  );
}

class AddMemoApplication extends StatelessWidget {
  const  AddMemoApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'メモ記録帳',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainMenu(title: 'メモ記録帳'),
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
  final memoDataController = TextEditingController();
  void _addMemo(){
    if(memoDataController.text == ""){
      Fluttertoast.showToast(msg: "メモがまだ未入力のようです。");
    }else {
      Memo newMemo = Memo(memoDataController.text);
      MainMenu.memoDataManager.addMemo(newMemo);
      memoDataController.text = "";
      Fluttertoast.showToast(msg: "メモを追加しました!");
      MainMenu.memoDataManager.selectAllMemo();
    }
  }
  @override
  Widget build(BuildContext context) {
    MainMenu.memoDataManager = MemoManager();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                    style: TextStyle(
                      fontSize: 16,
                    ),
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
                    child: const Text("メモを追加する"),
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
                    child: const Text("登録されているメモの一覧を表示する"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrange,
                      onPrimary: Colors.white,
                    ),
                    onPressed: (){
                      MainMenu.memoDataManager.selectAllMemo();
                      if(MainMenu.memoDataManager.getMemoList == null){
                        Fluttertoast.showToast(msg: "一件もメモが登録されていません。");
                      }else {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ShowMemoListForm()
                        ));
                      }
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
                    child: const Text("登録済みのメモを管理する"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrange,
                      onPrimary: Colors.white,
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => EditMemoListForm()
                      ));
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
