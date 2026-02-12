/// Represents a single delivery in the match.
class Ball {
  final int runs; // total runs from this ball (including extras)
  final int batsmanRuns; // runs to batsman (0 for wide/nb if no run taken)
  final bool isWicket;
  final bool isWide;
  final bool isNoBall;
  final String? outBatsmanId; // which batsman got out (striker id)
  final String? wicketType; // bowled, caught, run out, etc.

  const Ball({
    required this.runs,
    required this.batsmanRuns,
    this.isWicket = false,
    this.isWide = false,
    this.isNoBall = false,
    this.outBatsmanId,
    this.wicketType,
  });

  Map<String, dynamic> toJson() => {
    'runs': runs,
    'batsmanRuns': batsmanRuns,
    'isWicket': isWicket,
    'isWide': isWide,
    'isNoBall': isNoBall,
    'outBatsmanId': outBatsmanId,
    'wicketType': wicketType,
  };

  factory Ball.fromJson(Map<String, dynamic> json) => Ball(
    runs: json['runs'] as int? ?? 0,
    batsmanRuns: json['batsmanRuns'] as int? ?? 0,
    isWicket: json['isWicket'] as bool? ?? false,
    isWide: json['isWide'] as bool? ?? false,
    isNoBall: json['isNoBall'] as bool? ?? false,
    outBatsmanId: json['outBatsmanId'] as String?,
    wicketType: json['wicketType'] as String?,
  );

  /// Display symbol for over summary: 1,2,3,4,5,6, W, Wd, Wd5, Nb, Nb4
  String get displaySymbol {
    if (isWicket) return 'W';
    if (isWide) return runs > 1 ? 'Wd$runs' : 'Wd';
    if (isNoBall) return runs > 1 ? 'Nb$runs' : 'Nb';
    return runs.toString();
  }
}
