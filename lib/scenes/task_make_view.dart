import 'package:flutter/material.dart';
import 'package:flutter_todo_memo/scenes/todo_view.dart';

class TaskMakeView extends StatefulWidget {
  const TaskMakeView({Key? key}) : super(key: key);

  @override
  State<TaskMakeView> createState() => _TaskMakeViewState();
}

class _TaskMakeViewState extends State<TaskMakeView> {
  String _text = "";
  var now = DateTime.now();
  String _deadline = "";

  @override
  void initState() {
    super.initState();
    _deadline = "${now.month}月${now.day}日";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("新規作成"),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                "内容",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            TextFormField(
              onChanged: (String value) {
                setState(() {
                  _text = value;
                });
              },
            ),
            const Text(
              "締切",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Row(
              children: [
                Text(
                  _deadline,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                IconButton(
                    onPressed: (){
                      _selectDate(context);
                      },
                    icon: const Icon(Icons.calendar_today)
                ),
              ],
            ),
            ElevatedButton(
                onPressed: (){
                  if(_text != "") {
                    TodoView.taskList.add(
                      {
                        "id": TodoView.taskList.length + 1,
                        "done": false,
                        "text": _text,
                        "deadline": _deadline
                      }
                    );
                  }
                  Navigator.pop(context);
                },
                child: const Text("登録"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2024),
    );
    if (selected != null) {
      setState(() {
        _deadline = "${selected.month}月${selected.day}日";
      });
    }
  }
}
