import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_memo/scenes/task_make_view.dart';

class TodoView extends StatefulWidget {
  const TodoView({Key? key}) : super(key: key);
  static List taskList = [];

  @override
  State<TodoView> createState() => _TodoViewState();
}


class _TodoViewState extends State<TodoView> {
  bool _taskDone = false;
  // List _taskList = TodoView.taskList;
  List _todoList = [];
  List _doneList = [];
  List _viewList = [];

  @override
  void initState() {
    super.initState();
    // ローカルJSONをロード
    loadLocalJson();
  }

  @override
  Widget build(BuildContext context) {
    _viewList = (_taskDone) ? _doneList : _todoList;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text((_taskDone)? "DONE List" : "TODO List"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: (){
                setState(() {
                  _taskDone = !_taskDone;
                });
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                      (_taskDone)? "済" : "未",
                    style: const TextStyle(
                      fontSize: 28
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: ListView.builder(
          itemCount: _viewList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: Colors.blueGrey
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Checkbox(
                          value: _viewList[index]["done"],
                          onChanged: (_){
                            changeTaskList(_viewList[index]["id"]);
                          },
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _viewList[index]["text"],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Text(
                        _viewList[index]["deadline"],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context){
                    return const TaskMakeView();
                  }
              )
          ).then((value) => {
            setState(() {
              updateTaskList();
            })
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // ローカルJSONを読み込み
  Future loadLocalJson() async {
    String jsonString = await rootBundle.loadString('assets/todo.json');
    setState(() {
      final jsonResponse = json.decode(jsonString);
      TodoView.taskList = jsonResponse["data"];
      updateTaskList();
    });
  }

  // タスクの未達成、達成済みの切り替えを行う
  void changeTaskList(int id) {
    setState(() {
      for(int i = 0; i < TodoView.taskList.length; i++){
        if(TodoView.taskList[i]["id"] == id){
          TodoView.taskList[i]["done"] = !TodoView.taskList[i]["done"];
        }
      }
      updateTaskList();
      writeLocalJson(TodoView.taskList);
    });
  }

  // taskListの最新の中身に合わせて_doneList,_todoListを更新
  void updateTaskList(){
    _doneList = [];
    _todoList = [];
    TodoView.taskList.forEach((task) {
      if(task["done"]){
        _doneList.add(task);
      }else{
        _todoList.add(task);
      }
    });
  }

  // write
  Future writeLocalJson(List taskList) async {
    /// ここでjsonファイルを更新すれば完璧
    /// → Webアプでやるならクラウド上にストレージかDBを作るのが一番丸い(今回は割愛)
  }
}
