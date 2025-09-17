import 'package:flutter/material.dart';

void showNotImplementedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Coming soon'),
          content: const Text('This feature is still in development'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
  );
}
