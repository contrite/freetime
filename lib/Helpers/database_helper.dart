import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:freetime/Models/task_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static late Database _db;

  String tasksTable = 'task_table';
  String colId = 'id';
  String colTitle = 'title';
  String colTime = 'time';
  String colNotes = 'notes';
  String colDate = 'date';
  String colCategories = 'categories';
  String colStarred = 'starred';
  String colImagePath = "imagePath";

  Future<Database> get db async {
    _db = await _initDb();
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + '/todo_list.db';
    final todoListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $tasksTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colTime INTEGER, $colNotes TEXT, $colDate TEXT, $colCategories TEXT, $colStarred INTEGER, $colImagePath TEXT)',
    );
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(tasksTable);
    return result;
  }

  Future<List<Task>> getFilterTaskList(String phrase) async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    for (var taskMap in taskMapList) {
      taskList.add(Task.fromMap(taskMap));
    }
    final List<Task> _newdata =
        taskList.where((x) => x.title.toLowerCase().contains(phrase)).toList();

    return _newdata;
  }

  Future<List<Task>> getTimeTaskList(String time) async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    for (var taskMap in taskMapList) {
      taskList.add(Task.fromMap(taskMap));
    }
    final List<Task> _newdata =
        taskList.where((a) => a.time.toString() == time).toList();
    return _newdata;
  }

//NEEDS HELP!!
  // Future<List<Task>> filterTaskList(String text) async {
  //   final List<Map<String, dynamic>> result = await _db
  //       .rawQuery('SELECT * FROM task_table WHERE title LIKE', [text]);
  //   final List<Task> taskList = [];
  //   for (var taskMap in result) {
  //     taskList.add(Task.fromMap(taskMap));
  //   }
  //   return taskList;
  // }

  Future<List<Task>> getTaskList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    for (var taskMap in taskMapList) {
      taskList.add(Task.fromMap(taskMap));
    }
    taskList.sort((taskA, taskB) => taskA.time.compareTo(taskB.time));
    return taskList;
  }

  Future<int> insertTask(Task task) async {
    Database db = await this.db;
    final int result = await db.insert(tasksTable, task.toMap());
    return result;
  }

  Future<int> updateTask(Task task) async {
    Database db = await this.db;
    final int result = await db.update(tasksTable, task.toMap(),
        where: '$colId = ?', whereArgs: [task.id]);
    return result;
  }

  Future<int> deleteTask(int id) async {
    Database db = await this.db;
    final int result =
        await db.delete(tasksTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }
}
