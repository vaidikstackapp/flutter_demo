
import 'package:flutter/material.dart';

dialog(BuildContext context)
{
  return showDialog(context: context, builder: (context) {
    return const SimpleDialog(
      title: Text("Delete Dialog"),
    );
  },);
}