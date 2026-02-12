import 'ball.dart';
import 'player_stats.dart';

/// Full match state for persistence and display.
class MatchModel {
  final String id;
  final String teamOneName;
  final String teamTwoName;
  final String battingTeamName;
  final String bowlingTeamName;
  final int oversLimit;
  final DateTime createdAt;
  final DateTime? completedAt;

  int totalRuns;
  int totalWickets;
  int currentOverIndex; // 0-based over number (e.g. 5.2 = over 5, ball 2)
  int ballsInCurrentOver;

  final List<String>
  battingOrder; // player ids in order (first two are openers)
  final List<String> bowlingOrder;
  final Map<String, PlayerStats> battingStats;
  final Map<String, BowlerStats> bowlingStats;

  final List<List<Ball>> overs; // overs[0] = first over list of balls
  final List<String>
  overBowlers; // bowler who bowled each over (same index as overs)
  final List<Ball> currentOverBalls;

  int strikerIndex; // index in battingOrder
  int nonStrikerIndex;
  int currentBowlerIndex;

  int? target; // set in second innings (run chase)
  bool isSecondInnings;

  MatchModel({
    required this.id,
    required this.teamOneName,
    required this.teamTwoName,
    required this.battingTeamName,
    required this.bowlingTeamName,
    required this.oversLimit,
    DateTime? createdAt,
    this.completedAt,
    this.totalRuns = 0,
    this.totalWickets = 0,
    this.currentOverIndex = 0,
    this.ballsInCurrentOver = 0,
    List<String>? battingOrder,
    List<String>? bowlingOrder,
    Map<String, PlayerStats>? battingStats,
    Map<String, BowlerStats>? bowlingStats,
    List<List<Ball>>? overs,
    List<String>? overBowlers,
    List<Ball>? currentOverBalls,
    this.strikerIndex = 0,
    this.nonStrikerIndex = 1,
    this.currentBowlerIndex = 0,
    this.target,
    this.isSecondInnings = false,
  }) : createdAt = createdAt ?? DateTime.now(),
       battingOrder = battingOrder ?? [],
       bowlingOrder = bowlingOrder ?? [],
       battingStats = battingStats ?? {},
       bowlingStats = bowlingStats ?? {},
       overs = overs ?? [],
       overBowlers = overBowlers ?? [],
       currentOverBalls = currentOverBalls ?? [];

  bool get isCompleted => completedAt != null;

  /// Total balls bowled (excluding wides/noballs that don't count as ball)
  int get totalBallsBowled {
    int count = 0;
    for (final over in overs) {
      for (final b in over) {
        if (!b.isWide && !b.isNoBall) count++;
      }
    }
    for (final b in currentOverBalls) {
      if (!b.isWide && !b.isNoBall) count++;
    }
    return count;
  }

  /// Current run rate (runs per over)
  double get currentRunRate {
    final oversBowled = totalBallsBowled / 6.0;
    return oversBowled > 0 ? totalRuns / oversBowled : 0.0;
  }

  /// Required run rate (for second innings)
  double? get requiredRunRate {
    if (target == null || !isSecondInnings) return null;
    final remaining = target! - totalRuns;
    if (remaining <= 0) return null;
    final remainingOvers = oversLimit - (totalBallsBowled / 6.0);
    if (remainingOvers <= 0) return null;
    return remaining / remainingOvers;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'teamOneName': teamOneName,
    'teamTwoName': teamTwoName,
    'battingTeamName': battingTeamName,
    'bowlingTeamName': bowlingTeamName,
    'oversLimit': oversLimit,
    'createdAt': createdAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'totalRuns': totalRuns,
    'totalWickets': totalWickets,
    'currentOverIndex': currentOverIndex,
    'ballsInCurrentOver': ballsInCurrentOver,
    'battingOrder': battingOrder,
    'bowlingOrder': bowlingOrder,
    'battingStats': battingStats.map((k, v) => MapEntry(k, v.toJson())),
    'bowlingStats': bowlingStats.map((k, v) => MapEntry(k, v.toJson())),
    'overs': overs.map((o) => o.map((b) => b.toJson()).toList()).toList(),
    'overBowlers': overBowlers,
    'currentOverBalls': currentOverBalls.map((b) => b.toJson()).toList(),
    'strikerIndex': strikerIndex,
    'nonStrikerIndex': nonStrikerIndex,
    'currentBowlerIndex': currentBowlerIndex,
    'target': target,
    'isSecondInnings': isSecondInnings,
  };

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    final oversList =
        (json['overs'] as List<dynamic>?)
            ?.map(
              (o) => (o as List<dynamic>)
                  .map((b) => Ball.fromJson(b as Map<String, dynamic>))
                  .toList(),
            )
            .toList() ??
        [];
    final currentOverBallsList =
        (json['currentOverBalls'] as List<dynamic>?)
            ?.map((b) => Ball.fromJson(b as Map<String, dynamic>))
            .toList() ??
        [];
    final battingStatsMap =
        (json['battingStats'] as Map<String, dynamic>?)?.map(
          (k, v) =>
              MapEntry(k, PlayerStats.fromJson(v as Map<String, dynamic>)),
        ) ??
        {};
    final bowlingStatsMap =
        (json['bowlingStats'] as Map<String, dynamic>?)?.map(
          (k, v) =>
              MapEntry(k, BowlerStats.fromJson(v as Map<String, dynamic>)),
        ) ??
        {};
    return MatchModel(
      id: json['id'] as String,
      teamOneName: json['teamOneName'] as String,
      teamTwoName: json['teamTwoName'] as String,
      battingTeamName: json['battingTeamName'] as String,
      bowlingTeamName: json['bowlingTeamName'] as String,
      oversLimit: json['oversLimit'] as int,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      totalRuns: json['totalRuns'] as int? ?? 0,
      totalWickets: json['totalWickets'] as int? ?? 0,
      currentOverIndex: json['currentOverIndex'] as int? ?? 0,
      ballsInCurrentOver: json['ballsInCurrentOver'] as int? ?? 0,
      battingOrder: List<String>.from(
        json['battingOrder'] as List<dynamic>? ?? [],
      ),
      bowlingOrder: List<String>.from(
        json['bowlingOrder'] as List<dynamic>? ?? [],
      ),
      battingStats: battingStatsMap,
      bowlingStats: bowlingStatsMap,
      overs: oversList,
      overBowlers: List<String>.from(
        json['overBowlers'] as List<dynamic>? ?? [],
      ),
      currentOverBalls: currentOverBallsList,
      strikerIndex: json['strikerIndex'] as int? ?? 0,
      nonStrikerIndex: json['nonStrikerIndex'] as int? ?? 1,
      currentBowlerIndex: json['currentBowlerIndex'] as int? ?? 0,
      target: json['target'] as int?,
      isSecondInnings: json['isSecondInnings'] as bool? ?? false,
    );
  }
}
