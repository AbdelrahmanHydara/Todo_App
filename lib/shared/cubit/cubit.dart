import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_tasks/archived_tasks.dart';
import 'package:todo/modules/done_tasks/done_tasks.dart';
import 'package:todo/modules/new_tasks/new_tasks.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  List<Widget> screens =
  [
    const NewTasks(),
    const DoneTasks(),
    const ArchivedTasks(),
  ];
  List<String> titles =
  [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
     openDatabase(
      'Todo.db',
      version: 1,
      onCreate: (database, version)
      {
        print('Database Created');
        database.execute(
            'CREATE TABLE Tasks (id INTEGER PRIMARY KEY,date TEXT,time TEXT,title TEXT,status TEXT)')
            .then((value) {
          print('Table Created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database)
      {
        getDataFromDatabase(database);
        print('Database Opened');
      },
    ).then((value)
     {
       database = value;
       emit(AppCreateDatabaseState());
     });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async
  {
    await database.transaction((txn)
    {
      txn.rawInsert(
          'INSERT INTO Tasks (date,time,title,status) VALUES ("$date","$time","$title","new")')
          .then((value)
      {
        print('$value Insert Successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      }).catchError((error)
      {
        print('Error When Inserting New Record ${error.toString()}');
      });
      return Future(() {});
    });
  }

  void getDataFromDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(AppGetDatabaseState());

    database.rawQuery('SELECT * FROM Tasks').then((value)
    {
      emit(AppGetDatabaseState());
      value.forEach((element)
      {
        if(element['status'] == 'new')
        {
          newTasks.add(element);
        } else if(element['status'] == 'done')
        {
          doneTasks.add(element);
        } else
        {
          archiveTasks.add(element);
        }
      });
    });
  }

  void changeBottomSheetState({
  required bool isShow,
  required IconData icon,
}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void updateData({
  required String status,
  required int id ,
}) async
  {
    database.rawUpdate(
        'UPDATE Tasks SET status = ?WHERE id = ?',
      ['$status', id],
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id ,
  }) async
  {
    database.rawDelete(
      'DELETE FROM Tasks WHERE id = ?',
      [id],
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }
}
