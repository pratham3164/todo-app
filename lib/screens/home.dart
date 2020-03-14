import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseUser loggedInUser;
Firestore _firestore = Firestore.instance;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = FirebaseAuth.instance;

  void getUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2c2c2c),
      appBar: AppBar(title: Text('TO-DO')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          showDialog(
              context: context, builder: (BuildContext context) => AddDialog());
        },
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Add Task',
      ),
      body: TaskStream(),
    );
  }
}

class TaskStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('task').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final tasks = snapshot.data.documents.reversed;
        List<TaskData> taskData = [];

        for (var task in tasks) {
          final curentuser = loggedInUser.email;
          final title = task.data['title'];
          final email = task.data['email'];
          // final date = task.data['date'].toDate();

          if (curentuser == email) {
            print('hello');
            final _task = TaskData(title: title, task: task
                // , date: date
                );
            taskData.add(_task);
          }
        }
        print(taskData);
        return (taskData == null
            ? Container()
            : ListView(children: taskData, padding: EdgeInsets.all(10.0)));
      },
    );
  }
}

class TaskData extends StatelessWidget {
  final title;
  var task;

  // final date;
  TaskData({this.title, this.task
      // , this.date
      });
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.black,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              trailing: GestureDetector(
                onTap: () {
                  _firestore
                      .collection('task')
                      .document(task.documentID)
                      .delete();
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: Icon(Icons.remove, color: Colors.white)),
              ),
            )));
  }
}

class AddDialog extends StatelessWidget {
  String title;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: TextField(
          onChanged: (value) {
            title = value;
          },
          decoration: InputDecoration(hintText: 'Add Task Titile')),
      actions: <Widget>[
        RaisedButton(
          color: Colors.red,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
        RaisedButton(
          color: Colors.green,
          onPressed: () {
            _firestore.collection('task').add({
              'title': title,
              'email': loggedInUser.email,
              // 'date': DateTime.now()
            });
            Navigator.pop(context);
          },
          child: Text(
            'Add',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
