import 'package:flutter/material.dart';
import '../models/player_stats.dart';

class BattingCard extends StatelessWidget {
  final String? strikerId;
  final String? nonStrikerId;
  final Map<String, PlayerStats> battingStats;

  const BattingCard({
    super.key,
    required this.strikerId,
    required this.nonStrikerId,
    required this.battingStats,
  });

  @override
  Widget build(BuildContext context) {
    if (battingStats.isEmpty) return const SizedBox.shrink();
    return Card(
      color: Colors.white.withOpacity(0.12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Batting',
              style: TextStyle(
                color: Colors.amber.shade200,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(0.8),
                2: FlexColumnWidth(0.8),
                3: FlexColumnWidth(0.6),
                4: FlexColumnWidth(0.6),
                5: FlexColumnWidth(1),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.black26),
                  children: [
                    _tableHeaderCell('Batsman'),
                    _tableHeaderCell('R'),
                    _tableHeaderCell('B'),
                    _tableHeaderCell('4s'),
                    _tableHeaderCell('6s'),
                    _tableHeaderCell('SR'),
                  ],
                ),
                for (final id in [
                  strikerId,
                  nonStrikerId,
                ].where((e) => e != null).cast<String>())
                  if (battingStats.containsKey(id) && !battingStats[id]!.isOut)
                    TableRow(
                      children: _buildBattingRow(
                        battingStats[id]!,
                        id == strikerId,
                        id == nonStrikerId,
                      ),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBattingRow(
    PlayerStats p,
    bool isStriker,
    bool isNonStriker,
  ) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        child: Row(
          children: [
            if (isStriker)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.sports_cricket,
                  size: 14,
                  color: Colors.amber.shade300,
                ),
              ),
            Expanded(
              child: Text(
                p.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: (isStriker || isNonStriker)
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      _tableCell('${p.runs}'),
      _tableCell('${p.balls}'),
      _tableCell('${p.fours}'),
      _tableCell('${p.sixes}'),
      _tableCell(p.strikeRate.toStringAsFixed(1)),
    ];
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
