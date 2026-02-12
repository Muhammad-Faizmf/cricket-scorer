import 'package:flutter/material.dart';
import '../models/player_stats.dart';

class BowlingCard extends StatelessWidget {
  final BowlerStats currentBowler;

  const BowlingCard({super.key, required this.currentBowler});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bowling',
              style: TextStyle(
                color: Colors.amber.shade200,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(0.8),
                3: FlexColumnWidth(0.6),
                4: FlexColumnWidth(1),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.black26),
                  children: [
                    _tableHeaderCell('Bowler'),
                    _tableHeaderCell('O'),
                    _tableHeaderCell('R'),
                    _tableHeaderCell('W'),
                    _tableHeaderCell('ER'),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Icon(Icons.sports_baseball, size: 14, color: Colors.amber.shade300),
                          ),
                          Expanded(
                            child: Text(
                              currentBowler.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _tableCell('${currentBowler.balls ~/ 6}.${currentBowler.balls % 6}'),
                    _tableCell('${currentBowler.runs}'),
                    _tableCell('${currentBowler.wickets}'),
                    _tableCell(currentBowler.economy.toStringAsFixed(1)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableHeaderCell(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.amber.shade300,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget _tableCell(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        child: Text(
          text,
          style: TextStyle(color: Colors.amber.shade200, fontSize: 14),
        ),
      );
}
