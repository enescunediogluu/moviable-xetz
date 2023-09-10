import 'package:flutter/material.dart';

Future<void> showDeleteConfirmationDialog(
    BuildContext context, int index, Function onDelete) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Item'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete this item?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              // Call the onDelete callback function
              onDelete(index);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
