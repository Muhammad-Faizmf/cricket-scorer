import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  final int totalRuns;
  final int totalWickets;
  final int totalBallsBowled;
  final int oversLimit;
  final double currentRunRate;
  final double? requiredRunRate;
  final bool isMatchOver;

  const ScoreCard({
    super.key,
    required this.totalRuns,
    required this.totalWickets,
    required this.totalBallsBowled,
    required this.oversLimit,
    required this.currentRunRate,
    this.requiredRunRate,
    this.isMatchOver = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isMatchOver)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Match Finished',
              style: TextStyle(
                color: Colors.amber.shade300,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Card(
          color: Colors.white.withOpacity(0.12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '$totalRuns/$totalWickets',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Overs: ${totalBallsBowled ~/ 6}.${totalBallsBowled % 6} / $oversLimit',
                  style: TextStyle(color: Colors.amber.shade200),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'CRR: ${currentRunRate.toStringAsFixed(1)}',
                      style: TextStyle(color: Colors.amber.shade200),
                    ),
                    if (requiredRunRate != null) ...[
                      const SizedBox(width: 16),
                      Text(
                        'RRR: ${requiredRunRate!.toStringAsFixed(1)}',
                        style: TextStyle(color: Colors.amber.shade200),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
