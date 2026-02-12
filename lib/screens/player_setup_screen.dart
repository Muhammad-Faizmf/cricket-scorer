import 'package:flutter/material.dart';
import '../models/match_model.dart';
import '../models/player_stats.dart';

class PlayerSetupScreen extends StatefulWidget {
  final MatchModel match;

  const PlayerSetupScreen({super.key, required this.match});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final _batsmanOneController = TextEditingController();
  final _batsmanTwoController = TextEditingController();
  final _bowlerController = TextEditingController();

  @override
  void dispose() {
    _batsmanOneController.dispose();
    _batsmanTwoController.dispose();
    _bowlerController.dispose();
    super.dispose();
  }

  void _startMatch() {
    final p1 = _batsmanOneController.text.trim();
    final p2 = _batsmanTwoController.text.trim();
    final bowler = _bowlerController.text.trim();
    if (p1.isEmpty || p2.isEmpty || bowler.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter both batsmen and bowler names')),
      );
      return;
    }
    if (p1.toLowerCase() == p2.toLowerCase()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Batsmen must be different players')),
      );
      return;
    }

    final battingOrder = [p1, p2];
    final bowlingOrder = [bowler];
    final battingStats = <String, PlayerStats>{
      p1: PlayerStats(playerId: p1, name: p1),
      p2: PlayerStats(playerId: p2, name: p2),
    };
    final bowlingStats = <String, BowlerStats>{
      bowler: BowlerStats(playerId: bowler, name: bowler),
    };

    final match = MatchModel(
      id: widget.match.id,
      teamOneName: widget.match.teamOneName,
      teamTwoName: widget.match.teamTwoName,
      battingTeamName: widget.match.battingTeamName,
      bowlingTeamName: widget.match.bowlingTeamName,
      oversLimit: widget.match.oversLimit,
      createdAt: widget.match.createdAt,
      battingOrder: battingOrder,
      bowlingOrder: bowlingOrder,
      battingStats: battingStats,
      bowlingStats: bowlingStats,
      strikerIndex: 0,
      nonStrikerIndex: 1,
      currentBowlerIndex: 0,
    );

    Navigator.of(context).pop(match);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Players'),
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Text(
                  '${widget.match.battingTeamName} (Batting)',
                  style: TextStyle(
                    color: Colors.amber.shade200,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Batsman One', style: TextStyle(color: Colors.amber.shade100)),
                const SizedBox(height: 4),
                TextField(
                  controller: _batsmanOneController,
                  decoration: InputDecoration(
                    hintText: 'Player 1',
                    filled: true,
                    fillColor: const Color(0xFF144A38),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.amber.shade700),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text('Batsman Two', style: TextStyle(color: Colors.amber.shade100)),
                const SizedBox(height: 4),
                TextField(
                  controller: _batsmanTwoController,
                  decoration: InputDecoration(
                    hintText: 'Player 2',
                    filled: true,
                    fillColor: const Color(0xFF144A38),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.amber.shade700),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 24),
                Text(
                  '${widget.match.bowlingTeamName} (Bowling)',
                  style: TextStyle(
                    color: Colors.amber.shade200,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Bowler', style: TextStyle(color: Colors.amber.shade100)),
                const SizedBox(height: 4),
                TextField(
                  controller: _bowlerController,
                  decoration: InputDecoration(
                    hintText: 'Bowler name',
                    filled: true,
                    fillColor: const Color(0xFF144A38),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.amber.shade700),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _startMatch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Start Match'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
