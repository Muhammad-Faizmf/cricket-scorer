import 'package:flutter/material.dart';
import '../models/ball.dart';
import '../models/match_model.dart';
import '../models/player_stats.dart';
import '../services/storage_service.dart';

class MatchProvider extends ChangeNotifier {
  MatchProvider(MatchModel match)
      : _match = MatchModel.fromJson(match.toJson()),
        _storage = StorageService();

  MatchModel _match;
  final StorageService _storage;
  final List<Map<String, dynamic>> _undoStates = [];

  MatchModel get match => _match;

  bool get isMatchOver =>
      _match.totalBallsBowled >= _match.oversLimit * 6 || _match.totalWickets >= 10;

  Future<void> loadAndSave() async {
    final states = await _storage.loadUndoStates(_match.id);
    _undoStates.clear();
    _undoStates.addAll(states);
    await _save();
  }

  Future<void> _save() async {
    await _storage.saveMatchWithUndo(_match, _undoStates);
  }

  void addBall(Ball ball) {
    if (isMatchOver) return;
    final oversBefore = _match.overs.length;
    _undoStates.add(_match.toJson());
    _applyBall(ball);
    _save();
    notifyListeners();
    if (_match.overs.length > oversBefore && !isMatchOver) {
      _pendingNewBowler = true;
    }
  }

  bool _pendingNewBowler = false;
  bool get pendingNewBowler => _pendingNewBowler;
  void clearPendingNewBowler() => _pendingNewBowler = false;

  void _applyBall(Ball ball) {
    _match.totalRuns += ball.runs;
    if (ball.isWicket) _match.totalWickets++;
    final strikerId = _match.battingOrder[_match.strikerIndex];
    final bowlerId = _match.bowlingOrder[_match.currentBowlerIndex];
    final batsmanToUpdate = ball.isWicket && ball.outBatsmanId != null
        ? ball.outBatsmanId!
        : strikerId;
    if (_match.battingStats.containsKey(batsmanToUpdate)) {
      final s = _match.battingStats[batsmanToUpdate]!;
      s.runs += ball.batsmanRuns;
      if (!ball.isWide && !ball.isNoBall) s.balls++;
      if (ball.batsmanRuns == 4) s.fours++;
      if (ball.batsmanRuns == 6) s.sixes++;
    }
    if (ball.isWicket &&
        ball.outBatsmanId != null &&
        _match.battingStats.containsKey(ball.outBatsmanId)) {
      _match.battingStats[ball.outBatsmanId]!.isOut = true;
    }
    if (_match.bowlingStats.containsKey(bowlerId)) {
      final b = _match.bowlingStats[bowlerId]!;
      b.runs += ball.runs;
      if (ball.isWicket) b.wickets++;
      if (!ball.isWide && !ball.isNoBall) b.balls++;
      b.ballsInOver.add(ball);
    }
    _match.currentOverBalls.add(ball);
    final validBallsInOver =
        _match.currentOverBalls.where((x) => !x.isWide && !x.isNoBall).length;
    if (validBallsInOver >= 6) {
      _match.overs.add(List.from(_match.currentOverBalls));
      _match.overBowlers.add(bowlerId);
      _match.currentOverBalls.clear();
      _match.currentOverIndex++;
      for (final e in _match.bowlingStats.values) {
        e.ballsInOver.clear();
      }
      _swapStrike();
    } else {
      if (ball.batsmanRuns == 1 ||
          ball.batsmanRuns == 3 ||
          ball.batsmanRuns == 5) {
        _swapStrike();
      }
    }
  }

  void _swapStrike() {
    final t = _match.strikerIndex;
    _match.strikerIndex = _match.nonStrikerIndex;
    _match.nonStrikerIndex = t;
  }

  void undo() {
    if (isMatchOver || _undoStates.isEmpty) return;
    _match = MatchModel.fromJson(Map<String, dynamic>.from(_undoStates.removeLast()));
    _save();
    notifyListeners();
  }

  void recordWicket(String nextBatsmanName) {
    if (isMatchOver) return;
    final outBatsmanId = _match.battingOrder[_match.strikerIndex];
    final survivingBatsmanIndex = _match.nonStrikerIndex;
    _undoStates.add(_match.toJson());
    final ball = Ball(
      runs: 0,
      batsmanRuns: 0,
      isWicket: true,
      outBatsmanId: outBatsmanId,
      wicketType: 'out',
    );
    _applyBall(ball);
    final name = nextBatsmanName.trim();
    if (!_match.battingOrder.any((n) => n.toLowerCase() == name.toLowerCase())) {
      _match.battingOrder.add(name);
      _match.battingStats[name] = PlayerStats(playerId: name, name: name);
    }
    final newIndex = _match.battingOrder.indexOf(name);
    _match.strikerIndex = newIndex;
    _match.nonStrikerIndex = survivingBatsmanIndex;
    _save();
    notifyListeners();
  }

  void addBowlerAndSetCurrent(String name) {
    if (_match.bowlingOrder.contains(name)) _match.bowlingOrder.remove(name);
    _match.bowlingOrder.insert(0, name);
    if (!_match.bowlingStats.containsKey(name)) {
      _match.bowlingStats[name] = BowlerStats(playerId: name, name: name);
    }
    _match.currentBowlerIndex = 0;
    for (final e in _match.bowlingStats.values) {
      e.ballsInOver.clear();
    }
    _save();
    notifyListeners();
  }

  void swapStrike() {
    if (isMatchOver) return;
    _swapStrike();
    _save();
    notifyListeners();
  }

  Future<void> saveAndPop() async {
    await _save();
  }

  List<PlayerStats> getAllBatsmen() {
    final list = <PlayerStats>[];
    for (final id in _match.battingOrder) {
      if (_match.battingStats.containsKey(id)) {
        list.add(_match.battingStats[id]!);
      }
    }
    return list;
  }
}
