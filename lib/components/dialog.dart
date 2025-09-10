import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<DialogAction> actions;
  final Color? backgroundColor;

  const CustomDialog({
    super.key,
    required this.title,
    required this.message,
    this.actions = const [],
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> dialogActions = [];

    for (var action in actions) {
      dialogActions.add(
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(action.value);
          },
          child: Text(action.title),
        ),
      );
    }

    if (dialogActions.isEmpty) {
      dialogActions.add(
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OKAY'),
        ),
      );
    }

    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: dialogActions,
      backgroundColor: backgroundColor,
    );
  }

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String message,
    List<DialogAction<T>> actions = const [],
    Color? backgroundColor,
  }) async {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(title: title, message: message, actions: actions, backgroundColor: backgroundColor);
      },
    );
  }
}

class DialogAction<T> {
  final String title;
  final T value;

  DialogAction({required this.title, required this.value});
}
