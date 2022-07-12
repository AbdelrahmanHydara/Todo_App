import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 0.0,
  required Function() onPressed,
  required String text ,
}) => Container(
  height: 40.0,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: background,
  ),
  width: width ,
  child: MaterialButton(
    onPressed:onPressed,
    child: Text(
        isUpperCase ? text.toUpperCase() : text,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  ),
);

Widget defaultFormField({
  required TextEditingController controller,
  required String labelText,
  required IconData prefix,
  Function(String)? onChange,
  Function(String)? onSubmit,
  Function()? onTap,
  required String? Function(String?) validate,
  required TextInputType type,
  bool isPassword = false,
  Function()? suffixPressed,
  IconData? suffix,
}) => TextFormField(
  controller: controller,
  decoration: InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(
        prefix,
      ),
      suffixIcon: IconButton(
        icon: Icon(
            suffix,
        ),
        onPressed: suffixPressed ,
      ),
      border: const OutlineInputBorder(),
  ),
  obscureText: isPassword,
  onTap: onTap,
  keyboardType: type,
  onChanged: onChange,
  onFieldSubmitted: onSubmit,
  validator: validate,
);

Widget buildTaskItem(Map model , context) => Dismissible(
  key: Key (model['id'].toString()),
  child: Padding(
  
    padding: const EdgeInsets.all(20.0),
  
    child: Row(
  
      children:
  
      [
  
        CircleAvatar(
  
          backgroundColor: Colors.teal,
  
          radius: 50.0,
  
          child: Text(
  
            '${model['time']}',
  
            style: TextStyle(
  
              color: Colors.white,
  
            ),
  
          ),
  
        ),
  
        const SizedBox(
  
          width: 10.0,
  
        ),
  
        Expanded(
  
          child: Column(
  
            mainAxisSize: MainAxisSize.min,
  
            crossAxisAlignment: CrossAxisAlignment.start,
  
            children:
  
            [
  
              Text(
  
                '${model['title']}',
  
                style: TextStyle(
  
                  fontWeight: FontWeight.bold,
  
                  fontSize: 25.0,
  
                ),
  
              ),
  
              SizedBox(
  
                height: 10.0,
  
              ),
  
              Text(
  
                '${model['date']}',
  
                style: TextStyle(
  
                  color: Colors.grey,
  
                  fontSize: 15.0,
  
                ),
  
              ),
  
            ],
  
          ),
  
        ),
  
        const SizedBox(
  
          width: 10.0,
  
        ),
  
        IconButton(
  
            onPressed: ()
  
            {
  
              AppCubit.get(context).updateData(
  
                status: 'done',
  
                id: model['id'],
  
              );
  
            } ,
  
            icon: const Icon(
  
              Icons.check_circle,
  
              color: Colors.blueGrey,
  
              size: 30.0,
  
            ),
  
        ),
  
        IconButton(
  
            onPressed: ()
  
            {
  
              AppCubit.get(context).updateData(
  
                  status: 'archive',
  
                  id: model['id'],
  
              );
  
            } ,
  
            icon: const Icon(
  
                Icons.archive_outlined,
  
              color: Colors.black45,
  
              size: 30.0,
  
            ),
  
        ),
  
      ],
  
    ),
  
  ),
  onDismissed: (direction)
  {
    AppCubit.get(context).deleteData(
        id: model['id'],
    );
  },
);