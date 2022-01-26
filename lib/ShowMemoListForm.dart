import 'package:flutter/material.dart';
import 'package:memo_application/main.dart';

class ShowMemoListForm extends StatelessWidget{
  const ShowMemoListForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          title: Text("登録したメモ一覧")
      ),
      body : ListView.builder(
          itemCount: MainMenu.memoDataManager.getMemoList.length,
          itemBuilder: (context, index){
            return Dismissible(
              key: UniqueKey(),
              child: Card(
                child: ListTile(
                  title: Text(MainMenu.memoDataManager.getMemoList[index]["text_data"]),
                  subtitle: new Text(MainMenu.memoDataManager.getMemoList[index]["create_at"]),
                ),
              ),
            );
          }
      ),
    );
  }
}
