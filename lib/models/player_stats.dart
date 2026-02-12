import 'ball.dart';

/// Batting stats for a player in this match.
class PlayerStats {
  final String playerId;
  final String name;
  int runs;
  int balls;
  int fours;
  int sixes;
  bool isOut;

  PlayerStats({
    required this.playerId,
    required this.name,
    this.runs = 0,
    this.balls = 0,
    this.fours = 0,
    this.sixes = 0,
    this.isOut = false,
  });

  double get strikeRate => balls > 0 ? (runs / balls) * 100 : 0.0;

  Map<String, dynamic> toJson() => {
        'playerId': playerId,
        'name': name,
        'runs': runs,
        'balls': balls,
        'fours': fours,
        'sixes': sixes,
        'isOut': isOut,
      };

  factory PlayerStats.fromJson(Map<String, dynamic> json) => PlayerStats(
        playerId: json['playerId'] as String,
        name: json['name'] as String,
        runs: json['runs'] as int? ?? 0,
        balls: json['balls'] as int? ?? 0,
        fours: json['fours'] as int? ?? 0,
        sixes: json['sixes'] as int? ?? 0,
        isOut: json['isOut'] as bool? ?? false,
      );
}

/// Bowling stats for a bowler in this match.
class BowlerStats {
  final String playerId;
  final String name;
  int balls;
  int runs;
  int wickets;
  final List<Ball> ballsInOver; // current over being bowled

  BowlerStats({
    required this.playerId,
    required this.name,
    this.balls = 0,
    this.runs = 0,
    this.wickets = 0,
    List<Ball>? ballsInOver,
  }) : ballsInOver = ballsInOver ?? [];

  double get economy {
    final overs = balls / 6.0;
    return overs > 0 ? runs / overs : 0.0;
  }

  Map<String, dynamic> toJson() => {
        'playerId': playerId,
        'name': name,
        'balls': balls,
        'runs': runs,
        'wickets': wickets,
      };

  factory BowlerStats.fromJson(Map<String, dynamic> json) => BowlerStats(
        playerId: json['playerId'] as String,
        name: json['name'] as String,
        balls: json['balls'] as int? ?? 0,
        runs: json['runs'] as int? ?? 0,
        wickets: json['wickets'] as int? ?? 0,
      );
}
