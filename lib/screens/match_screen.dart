import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ball.dart';
import '../models/match_model.dart';
import '../providers/match_provider.dart';
import '../widgets/ball_display.dart';
import '../widgets/batting_card.dart';
import '../widgets/bowling_card.dart';
import '../widgets/dialogs/leave_match_dialog.dart';
import '../widgets/dialogs/next_batsman_dialog.dart';
import '../widgets/dialogs/required_bowler_dialog.dart';
import '../widgets/dialogs/runs_picker_dialog.dart';
import '../widgets/over_history.dart';
import '../widgets/scoring_buttons.dart';
import '../widgets/score_card.dart';
import 'stats_screen.dart';

class MatchScreen extends StatefulWidget {
  final MatchModel match;

  const MatchScreen({super.key, required this.match});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MatchProvider(widget.match),
      child: const _MatchScreenContent(),
    );
  }
}

class _MatchScreenContent extends StatefulWidget {
  const _MatchScreenContent();

  @override
  State<_MatchScreenContent> createState() => _MatchScreenContentState();
}

class _MatchScreenContentState extends State<_MatchScreenContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MatchProvider>().loadAndSave();
    });
  }

  Future<void> _showNewBowlerDialog(
    BuildContext context,
    MatchProvider provider,
  ) async {
    if (!mounted || provider.isMatchOver) return;
    String name;
    do {
      name = await showRequiredBowlerDialog(
        context,
        title: 'Over complete. Enter new bowler',
      );
      if (!mounted) return;
    } while (name.trim().isEmpty);
    if (!mounted) return;
    provider.addBowlerAndSetCurrent(name.trim());
  }

  Future<void> _onWicket(BuildContext context, MatchProvider provider) async {
    if (provider.isMatchOver) return;
    final next = await showNextBatsmanDialog(
      context,
      getBattingOrder: () => provider.match.battingOrder,
    );
    if (!mounted || next == null) return;
    provider.recordWicket(next.trim());
  }

  Future<void> _onWide(BuildContext context, MatchProvider provider) async {
    if (provider.isMatchOver) return;
    final runs = await showRunsPickerDialog(
      context,
      title: 'Wide - total runs?',
      min: 1,
      max: 8,
    );
    if (runs == null || !mounted) return;
    provider.addBall(Ball(runs: runs, batsmanRuns: 0, isWide: true));
  }

  Future<void> _onNoBall(BuildContext context, MatchProvider provider) async {
    if (provider.isMatchOver) return;
    final runs = await showRunsPickerDialog(
      context,
      title: 'No ball - total runs (1 + batsman)?',
      min: 1,
      max: 8,
    );
    if (runs == null || !mounted) return;
    provider.addBall(Ball(runs: runs, batsmanRuns: runs - 1, isNoBall: true));
  }

  void _openStats(BuildContext context, MatchProvider provider) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StatsScreen(
          allBatsmen: provider.getAllBatsmen(),
          bowlerStats: provider.match.bowlingStats.values.toList(),
          teamName: provider.match.battingTeamName,
          bowlingTeamName: provider.match.bowlingTeamName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(
      builder: (context, provider, _) {
        return PopScope(
          canPop: provider.isMatchOver,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            if (provider.isMatchOver) return;
            final shouldPop = await showLeaveMatchDialog(context);
            if (shouldPop == true && context.mounted) {
              await provider.saveAndPop();
              if (context.mounted) Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                '${provider.match.teamOneName} vs ${provider.match.teamTwoName}',
              ),
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
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ScoreCard(
                              totalRuns: provider.match.totalRuns,
                              totalWickets: provider.match.totalWickets,
                              totalBallsBowled: provider.match.totalBallsBowled,
                              oversLimit: provider.match.oversLimit,
                              currentRunRate: provider.match.currentRunRate,
                              requiredRunRate: provider.match.requiredRunRate,
                              isMatchOver: provider.isMatchOver,
                            ),
                            const SizedBox(height: 12),
                            if (provider.match.battingOrder.isNotEmpty)
                              BattingCard(
                                strikerId:
                                    provider.match.battingOrder.isNotEmpty
                                    ? provider.match.battingOrder[provider
                                          .match
                                          .strikerIndex]
                                    : null,
                                nonStrikerId:
                                    provider.match.battingOrder.length > 1
                                    ? provider.match.battingOrder[provider
                                          .match
                                          .nonStrikerIndex]
                                    : null,
                                battingStats: provider.match.battingStats,
                              ),
                            if (provider.match.bowlingOrder.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Builder(
                                builder: (context) {
                                  final order = provider.match.bowlingOrder;
                                  final currentBowlerId =
                                      order[provider.match.currentBowlerIndex];
                                  final bowler = provider
                                      .match
                                      .bowlingStats[currentBowlerId];
                                  if (bowler == null) {
                                    return const SizedBox.shrink();
                                  }
                                  return BowlingCard(currentBowler: bowler);
                                },
                              ),
                            ],
                            const SizedBox(height: 12),
                            _CurrentOverSection(
                              balls: provider.match.currentOverBalls,
                            ),
                            const SizedBox(height: 16),
                            OverHistory(
                              overs: provider.match.overs,
                              overBowlers: provider.match.overBowlers,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _ScoringSection(
                      onWicket: () => _onWicket(context, provider),
                      onWide: () => _onWide(context, provider),
                      onNoBall: () => _onNoBall(context, provider),
                      onStats: () => _openStats(context, provider),
                      onNewBowlerNeeded: () =>
                          _showNewBowlerDialog(context, provider),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CurrentOverSection extends StatelessWidget {
  final List<Ball> balls;

  const _CurrentOverSection({required this.balls});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('This over', style: TextStyle(color: Colors.amber.shade200)),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: balls
              .map((b) => BallDisplay(ball: b, withBorder: true))
              .toList(),
        ),
      ],
    );
  }
}

class _ScoringSection extends StatelessWidget {
  final VoidCallback onWicket;
  final VoidCallback onWide;
  final VoidCallback onNoBall;
  final VoidCallback onStats;
  final VoidCallback onNewBowlerNeeded;

  const _ScoringSection({
    required this.onWicket,
    required this.onWide,
    required this.onNoBall,
    required this.onStats,
    required this.onNewBowlerNeeded,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(
      builder: (context, provider, _) {
        return ScoringButtons(
          isMatchOver: provider.isMatchOver,
          onAddBall: (ball) {
            provider.addBall(ball);
            if (provider.pendingNewBowler) {
              provider.clearPendingNewBowler();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) onNewBowlerNeeded();
              });
            }
          },
          onWicket: onWicket,
          onWide: onWide,
          onNoBall: onNoBall,
          onUndo: provider.undo,
          onSwipe: provider.swapStrike,
          onStats: onStats,
        );
      },
    );
  }
}
