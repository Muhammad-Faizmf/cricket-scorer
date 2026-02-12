import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/match_model.dart';

/// Saves and loads match data to local storage.
class StorageService {
  static const String _matchesFileName = 'cricket_matches.json';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _matchesFile async {
    final path = await _localPath;
    return File('$path/$_matchesFileName');
  }

  Future<List<MatchModel>> loadMatches() async {
    try {
      final file = await _matchesFile;
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final list = jsonDecode(contents) as List<dynamic>;
      return list
          .map((e) => MatchModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveMatches(List<MatchModel> matches) async {
    final file = await _matchesFile;
    final list = matches.map((m) => m.toJson()).toList();
    await file.writeAsString(jsonEncode(list));
  }

  Future<void> saveMatch(MatchModel match) async {
    await saveMatchWithUndo(match, []);
  }

  Future<void> saveMatchWithUndo(MatchModel match, List<Map<String, dynamic>> undoStates) async {
    final file = await _matchesFile;
    List<dynamic> list = [];
    if (await file.exists()) {
      final contents = await file.readAsString();
      list = jsonDecode(contents) as List<dynamic>;
    }
    final matchJson = match.toJson();
    matchJson['undoStates'] = undoStates.length > 50 ? undoStates.sublist(undoStates.length - 50) : undoStates;
    final index = list.indexWhere((e) => (e as Map)['id'] == match.id);
    if (index >= 0) {
      list[index] = matchJson;
    } else {
      list.insert(0, matchJson);
    }
    await file.writeAsString(jsonEncode(list));
  }

  Future<List<Map<String, dynamic>>> loadUndoStates(String matchId) async {
    try {
      final file = await _matchesFile;
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final list = jsonDecode(contents) as List<dynamic>;
      for (final e in list) {
        final m = e as Map<String, dynamic>;
        if (m['id'] == matchId) {
          final states = m['undoStates'] as List<dynamic>?;
          return states?.map((s) => Map<String, dynamic>.from(s as Map)).toList() ?? [];
        }
      }
    } catch (_) {}
    return [];
  }

  Future<MatchModel?> loadMatchById(String id) async {
    final matches = await loadMatches();
    try {
      return matches.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteMatch(String id) async {
    final matches = await loadMatches();
    matches.removeWhere((m) => m.id == id);
    await saveMatches(matches);
  }
}
