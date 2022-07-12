import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class TodoApp extends StatelessWidget
{
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {

    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state)
        {
          if(state is AppInsertDatabaseState)
            {
              Navigator.pop(context);
            }
        },
        builder: (context,state)
        {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.teal,
              title: Text(
                AppCubit.get(context).titles[AppCubit.get(context).currentIndex],
              ),
            ),
            body: AppCubit.get(context).screens[AppCubit.get(context).currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: ()
              {
                if (AppCubit.get(context).isBottomSheetShown)
                {
                  if (formKey.currentState!.validate())
                  {
                    AppCubit.get(context).insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                    );
                  }
                } else
                {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) =>
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  controller: titleController,
                                  labelText: 'Title Tasks',
                                  prefix: Icons.title_outlined,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Title must not be empty';
                                    }
                                    return null;
                                  },
                                  type: TextInputType.text,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                defaultFormField(
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  controller: timeController,
                                  labelText: 'Time Tasks',
                                  prefix: Icons.watch_later_outlined,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Time must not be empty';
                                    }
                                    return null;
                                  },
                                  type: TextInputType.text,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                defaultFormField(
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-08-21'),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  controller: dateController,
                                  labelText: 'Date Tasks',
                                  prefix: Icons.calendar_today,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Date must not be empty';
                                    }
                                    return null;
                                  },
                                  type: TextInputType.text,
                                ),
                              ],
                            ),
                          ),
                        ),
                  ).closed.then((value)
                  {
                    AppCubit.get(context).changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit,
                    );
                  });
                  AppCubit.get(context).changeBottomSheetState(
                    isShow: true,
                    icon: Icons.add,
                  );
                }
              },
              child: CircleAvatar(
                  backgroundColor: Colors.teal,
                  radius: 100.0,
                  child: Icon(AppCubit.get(context).fabIcon,
                    color: Colors.white,)),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index)
              {
                AppCubit.get(context).changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


