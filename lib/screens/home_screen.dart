import 'package:flutter/material.dart';
import '../models/match_model.dart';
import '../services/storage_service.dart';
import 'new_match_setup_screen.dart';
import 'match_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storage = StorageService();
  List<MatchModel> _matches = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    setState(() => _loading = true);
    final list = await _storage.loadMatches();
    setState(() {
      _matches = list;
      _loading = false;
    });
  }

  void _openNewMatch() async {
    final result = await Navigator.of(context).push<MatchModel>(
      MaterialPageRoute(
        builder: (context) => const NewMatchSetupScreen(),
      ),
    );
    if (result != null && mounted) {
      await _storage.saveMatch(result);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MatchScreen(match: result),
        ),
      ).then((_) { if (mounted) _loadMatches(); });
    }
  }

  void _openMatch(MatchModel match) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MatchScreen(match: match),
      ),
    ).then((_) { if (mounted) _loadMatches(); });
  }

  Future<void> _deleteMatch(MatchModel match, BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete match?'),
        content: Text(
          'Remove "${match.teamOneName} vs ${match.teamTwoName}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red[900]),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await _storage.deleteMatch(match.id);
      if (mounted) _loadMatches();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D3B2C),
              Color(0xFF1A5C42),
              Color(0xFF0D3B2C),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                'Cricket Scorer',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.amber.shade100,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _openNewMatch,
                    icon: const Icon(Icons.add_circle_outline, size: 28),
                    label: const Text('New Match', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text(
                      'Previous Matches',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.amber.shade100,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                    : _matches.isEmpty
                        ? Center(
                            child: Text(
                              'No matches yet.\nStart a new match!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.amber.shade200,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadMatches,
                            color: Colors.amber,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: _matches.length,
                              itemBuilder: (context, index) {
                                final m = _matches[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  color: Colors.white.withOpacity(0.12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    title: Text(
                                      '${m.teamOneName} vs ${m.teamTwoName}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${m.totalRuns}/${m.totalWickets} • ${m.totalBallsBowled ~/ 6}.${m.totalBallsBowled % 6} overs'
                                      '${m.isCompleted ? ' • Completed' : ''}',
                                      style: TextStyle(
                                        color: Colors.amber.shade200,
                                        fontSize: 13,
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete_outline, color: Colors.red[400], size: 22),
                                          onPressed: () => _deleteMatch(m, context),
                                          tooltip: 'Delete match',
                                        ),
                                        const Icon(Icons.chevron_right, color: Colors.amber),
                                      ],
                                    ),
                                    onTap: () => _openMatch(m),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
