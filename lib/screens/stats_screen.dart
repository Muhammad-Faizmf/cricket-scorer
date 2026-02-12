import 'package:flutter/material.dart';
import '../models/player_stats.dart';

class StatsScreen extends StatelessWidget {
  final List<PlayerStats> allBatsmen;
  final List<BowlerStats> bowlerStats;
  final String teamName;
  final String bowlingTeamName;

  const StatsScreen({
    super.key,
    required this.allBatsmen,
    required this.bowlerStats,
    required this.teamName,
    required this.bowlingTeamName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
        backgroundColor: const Color(0xFF0D3B2C),
        foregroundColor: Colors.amber.shade100,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D3B2C), Color(0xFF1A5C42)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (allBatsmen.isNotEmpty)
                Card(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
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
                            for (final p in allBatsmen)
                              TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 6,
                                    ),
                                    child: Text(
                                      '${p.name}${p.isOut ? '' : '*'}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  _tableCell('${p.runs}'),
                                  _tableCell('${p.balls}'),
                                  _tableCell('${p.fours}'),
                                  _tableCell('${p.sixes}'),
                                  _tableCell(p.strikeRate.toStringAsFixed(1)),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              if (allBatsmen.isNotEmpty) const SizedBox(height: 16),
              if (bowlerStats.isNotEmpty)
                Card(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
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
                            for (final b in bowlerStats)
                              TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 6,
                                    ),
                                    child: Text(
                                      b.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  _tableCell('${b.balls ~/ 6}.${b.balls % 6}'),
                                  _tableCell('${b.runs}'),
                                  _tableCell('${b.wickets}'),
                                  _tableCell(b.economy.toStringAsFixed(1)),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tableHeaderCell(String text) {
    return Padding(
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
  }

  Widget _tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Text(
        text,
        style: TextStyle(color: Colors.amber.shade200, fontSize: 14),
      ),
    );
  }
}
