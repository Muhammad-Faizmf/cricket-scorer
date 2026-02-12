import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/match_model.dart';
import 'player_setup_screen.dart';

class NewMatchSetupScreen extends StatefulWidget {
  const NewMatchSetupScreen({super.key});

  @override
  State<NewMatchSetupScreen> createState() => _NewMatchSetupScreenState();
}

class _NewMatchSetupScreenState extends State<NewMatchSetupScreen> {
  final _teamOneController = TextEditingController();
  final _teamTwoController = TextEditingController();
  String? _battingTeam; // team one or team two
  int _overs = 5;
  final _oversOptions = [1, 2, 3, 4, 5, 6, 8, 10, 12, 14];

  @override
  void dispose() {
    _teamOneController.dispose();
    _teamTwoController.dispose();
    super.dispose();
  }

  void _next() {
    final t1 = _teamOneController.text.trim();
    final t2 = _teamTwoController.text.trim();
    if (t1.isEmpty || t2.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter both team names')));
      return;
    }
    if (_battingTeam == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Choose who bats first')));
      return;
    }
    final battingTeamName = _battingTeam!;
    final bowlingTeamName = _battingTeam == t1 ? t2 : t1;

    final match = MatchModel(
      id: const Uuid().v4(),
      teamOneName: t1,
      teamTwoName: t2,
      battingTeamName: battingTeamName,
      bowlingTeamName: bowlingTeamName,
      oversLimit: _overs,
    );

    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => PlayerSetupScreen(match: match),
          ),
        )
        .then((result) {
          if (result is MatchModel && mounted) {
            Navigator.of(context).pop(result);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final t1 = _teamOneController.text.trim();
    final t2 = _teamTwoController.text.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Match'),
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
                  'Team One',
                  style: TextStyle(
                    color: Colors.amber.shade200,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _teamOneController,
                  decoration: InputDecoration(
                    hintText: 'e.g. India',
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.amber.shade700),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),
                Text(
                  'Team Two',
                  style: TextStyle(
                    color: Colors.amber.shade200,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _teamTwoController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Australia',
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.amber.shade700),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 24),
                Text(
                  'Who bats first?',
                  style: TextStyle(
                    color: Colors.amber.shade200,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                if (t1.isNotEmpty)
                  // ignore: deprecated_member_use
                  RadioListTile<String>(
                    title: Text(
                      t1,
                      style: const TextStyle(color: Colors.white),
                    ),
                    value: t1,
                    groupValue: _battingTeam,
                    activeColor: Colors.amber,
                    onChanged: (v) => setState(() => _battingTeam = v),
                  ),
                if (t2.isNotEmpty)
                  // ignore: deprecated_member_use
                  RadioListTile<String>(
                    title: Text(
                      t2,
                      style: const TextStyle(color: Colors.white),
                    ),
                    value: t2,
                    groupValue: _battingTeam,
                    activeColor: Colors.amber,
                    onChanged: (v) => setState(() => _battingTeam = v),
                  ),
                const SizedBox(height: 24),
                Text(
                  'Overs',
                  style: TextStyle(
                    color: Colors.amber.shade200,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _oversOptions.map((o) {
                    final selected = _overs == o;
                    return ChoiceChip(
                      label: Text('$o'),
                      selected: selected,
                      onSelected: (v) => setState(() => _overs = o),
                      selectedColor: Colors.amber.shade700,
                      labelStyle: TextStyle(
                        color: selected ? Colors.black87 : Colors.white,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Next: Add Players'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
