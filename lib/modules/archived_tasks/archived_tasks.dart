import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class ArchivedTasks extends StatelessWidget
{
  const ArchivedTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var tasks = AppCubit.get(context).archiveTasks;

        return ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsetsDirectional.only(start: 20.0),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.teal[200],
            ),
          ),
          itemCount: tasks.length,
        );
      },
    );
  }
}
