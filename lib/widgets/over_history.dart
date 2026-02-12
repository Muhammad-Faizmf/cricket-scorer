import 'package:flutter/material.dart';
import '../models/ball.dart';
import 'ball_display.dart';

class OverHistory extends StatelessWidget {
  final List<List<Ball>> overs;
  final List<String> overBowlers;

  const OverHistory({
    super.key,
    required this.overs,
    required this.overBowlers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Over history', style: TextStyle(color: Colors.amber.shade200)),
        const SizedBox(height: 8),
        ...List.generate(overs.length, (i) {
          final reverseIdx = overs.length - 1 - i;
          final over = overs[reverseIdx];
          final overRuns = over.fold<int>(0, (s, b) => s + b.runs);
          final cumulativeRuns = overs
              .take(reverseIdx + 1)
              .fold<int>(
                0,
                (sum, o) => sum + o.fold<int>(0, (s, b) => s + b.runs),
              );
          final overNum = reverseIdx + 1;
          final bowlerName = reverseIdx < overBowlers.length
              ? overBowlers[reverseIdx]
              : '?';
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 72,
                  child: Text(
                    '$bowlerName ($overNum)',
                    style: TextStyle(
                      color: Colors.amber.shade200,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: over
                        .map(
                          (b) => BallDisplay(ball: b, size: 24, fontSize: 10),
                        )
                        .toList(),
                  ),
                ),
                Text(
                  '$overRuns ($cumulativeRuns)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
