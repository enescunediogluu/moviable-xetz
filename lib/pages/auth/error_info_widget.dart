import 'package:flutter/material.dart';

class ErrorFeedbackWidget extends StatelessWidget {
  final String message;

  const ErrorFeedbackWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
  }
}
