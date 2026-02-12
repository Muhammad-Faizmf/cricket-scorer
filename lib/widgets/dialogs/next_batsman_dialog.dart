import 'package:flutter/material.dart';

/// [getBattingOrder] is called at validation time to ensure current state (correct after undo).
Future<String?> showNextBatsmanDialog(
  BuildContext context, {
  required List<String> Function() getBattingOrder,
}) async {
  final controller = TextEditingController();
  String? errorMessage;
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('Wicket! Enter next batsman'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 280),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Player name'),
                autofocus: true,
                onChanged: (_) => setState(() => errorMessage = null),
                onSubmitted: (v) => _validate(ctx, v, getBattingOrder, setState, (e) => errorMessage = e),
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  errorMessage!,
                  style: TextStyle(color: Theme.of(ctx).colorScheme.error, fontSize: 12),
                  softWrap: true,
                ),
              ],
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: controller.text.trim().isEmpty
                ? null
                : () => _validate(ctx, controller.text, getBattingOrder, setState, (e) => errorMessage = e),
            child: const Text('OK'),
          ),
        ],
      ),
    ),
  );
}

void _validate(
  BuildContext ctx,
  String value,
  List<String> Function() getBattingOrder,
  StateSetter setState,
  void Function(String?) setError,
) {
  final name = value.trim();
  if (name.isEmpty) return;
  final battingOrder = getBattingOrder();
  if (battingOrder.any((n) => n.toLowerCase() == name.toLowerCase())) {
    setState(() => setError('This player has already batted, enter another one'));
  } else {
    Navigator.of(ctx).pop(name);
  }
}
