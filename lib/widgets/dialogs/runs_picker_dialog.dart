import 'package:flutter/material.dart';

Future<int?> showRunsPickerDialog(
  BuildContext context, {
  required String title,
  required int min,
  required int max,
}) async {
  int value = min;
  return showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) => AlertDialog(
        title: Text(title),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () =>
                  setDialogState(() => value = (value - 1).clamp(min, max)),
            ),
            Text(
              '$value',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  setDialogState(() => value = (value + 1).clamp(min, max)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(value),
            child: const Text('OK'),
          ),
        ],
      ),
    ),
  );
}
