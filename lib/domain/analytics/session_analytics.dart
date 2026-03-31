/// Speed thresholds for individual round decisions (milliseconds)
class SpeedFlag {
  static const String rushing    = 'rushing';    // < 5 s  — likely not reading card
  static const String quick      = 'quick';      // 5–15 s — fast but plausible
  static const String normal     = 'normal';     // 15–60 s — ideal range
  static const String deliberate = 'deliberate'; // > 60 s — thinking hard / distracted

  static String fromMs(int ms) {
    if (ms < 5000)  return rushing;
    if (ms < 15000) return quick;
    if (ms < 60000) return normal;
    return deliberate;
  }
}

/// Session duration flags (target window: 45–60 min)
class DurationFlag {
  static const String tooShort = 'too_short'; // < 20 min
  static const String short    = 'short';     // 20–44 min
  static const String normal   = 'normal';    // 45–60 min  ← target
  static const String long     = 'long';      // 61–90 min
  static const String tooLong  = 'too_long';  // > 90 min

  static String fromMinutes(double minutes) {
    if (minutes < 20) return tooShort;
    if (minutes < 45) return short;
    if (minutes <= 60) return normal;
    if (minutes <= 90) return long;
    return tooLong;
  }
}

/// Summary written to `sessionSummaries/{sessionId}` at session end.
/// Also triggers an upsert to `playerSummaries/{uid}`.
class SessionSummary {
  final String uid;
  final String sessionId;
  final DateTime startedAt;
  final DateTime endedAt;
  final int roundCount;

  // Timing
  final int durationMs;
  final String durationFlag;
  final int avgDecisionTimeMs;
  final int rushingRounds;   // speedFlag == rushing
  final int quickRounds;     // speedFlag == quick
  final int normalRounds;    // speedFlag == normal
  final int deliberateRounds;// speedFlag == deliberate
  final String overallSpeedPattern; // dominant flag

  // Decisions
  final int decisionsBuyCash;
  final int decisionsLoan;
  final int decisionsDontBuy;

  // Quality
  final int qualityOptimal;
  final int qualitySuboptimal;
  final int qualityPoor;

  // Progress
  final int levelReached;
  final List<int> levelsPlayed;

  SessionSummary({
    required this.uid,
    required this.sessionId,
    required this.startedAt,
    required this.endedAt,
    required this.roundCount,
    required this.durationMs,
    required this.durationFlag,
    required this.avgDecisionTimeMs,
    required this.rushingRounds,
    required this.quickRounds,
    required this.normalRounds,
    required this.deliberateRounds,
    required this.overallSpeedPattern,
    required this.decisionsBuyCash,
    required this.decisionsLoan,
    required this.decisionsDontBuy,
    required this.qualityOptimal,
    required this.qualitySuboptimal,
    required this.qualityPoor,
    required this.levelReached,
    required this.levelsPlayed,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'sessionId': sessionId,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt.toIso8601String(),
      'durationMs': durationMs,
      'durationMinutes': (durationMs / 60000).toStringAsFixed(1),
      'durationFlag': durationFlag,
      'roundCount': roundCount,
      'avgDecisionTimeMs': avgDecisionTimeMs,
      'avgDecisionTimeSec': (avgDecisionTimeMs / 1000).toStringAsFixed(1),
      'speedBreakdown': {
        'rushing': rushingRounds,
        'quick': quickRounds,
        'normal': normalRounds,
        'deliberate': deliberateRounds,
      },
      'overallSpeedPattern': overallSpeedPattern,
      'decisions': {
        'buyCash': decisionsBuyCash,
        'loan': decisionsLoan,
        'dontBuy': decisionsDontBuy,
      },
      'decisionQuality': {
        'optimal': qualityOptimal,
        'suboptimal': qualitySuboptimal,
        'poor': qualityPoor,
      },
      'levelReached': levelReached,
      'levelsPlayed': levelsPlayed,
    };
  }

  /// Queue action for `sessionSummaries` collection (doc = sessionId for idempotency)
  Map<String, dynamic> toQueueAction() {
    return {
      'collection': 'sessionSummaries',
      'doc': sessionId,
      'data': toMap(),
    };
  }

  /// Queue action to upsert `playerSummaries/{uid}` with this session's stats
  Map<String, dynamic> toPlayerSummaryQueueAction() {
    return {
      'collection': 'playerSummaries',
      'doc': uid,
      'merge': true,
      'data': {
        'uid': uid,
        'lastSessionId': sessionId,
        'lastPlayedAt': endedAt.toIso8601String(),
        'levelReached': levelReached,
        // These are incremented server-side via FieldValue — handled in sync
        '_incrementSessions': 1,
        '_incrementRounds': roundCount,
        '_incrementDurationMs': durationMs,
        '_incrementBuyCash': decisionsBuyCash,
        '_incrementLoan': decisionsLoan,
        '_incrementDontBuy': decisionsDontBuy,
        '_incrementOptimal': qualityOptimal,
        '_incrementSuboptimal': qualitySuboptimal,
        '_incrementPoor': qualityPoor,
        '_incrementRushing': rushingRounds,
      },
    };
  }
}

/// Accumulates per-round stats during a session so a summary can be computed.
class SessionAccumulator {
  final String uid;
  final String sessionId;
  final DateTime startedAt;

  int _roundCount = 0;
  int _totalDecisionMs = 0;
  int _rushingRounds = 0;
  int _quickRounds = 0;
  int _normalRounds = 0;
  int _deliberateRounds = 0;
  int _buyCash = 0;
  int _loan = 0;
  int _dontBuy = 0;
  int _optimal = 0;
  int _suboptimal = 0;
  int _poor = 0;
  int _levelReached = 0;
  final Set<int> _levelsPlayed = {};

  SessionAccumulator({
    required this.uid,
    required this.sessionId,
    required this.startedAt,
  });

  int get roundCount => _roundCount;

  void recordRound({
    required int decisionTimeMs,
    required String decision,
    required String decisionQuality,
    required int levelId,
  }) {
    _roundCount++;
    _totalDecisionMs += decisionTimeMs;

    final flag = SpeedFlag.fromMs(decisionTimeMs);
    switch (flag) {
      case SpeedFlag.rushing:    _rushingRounds++;    break;
      case SpeedFlag.quick:      _quickRounds++;      break;
      case SpeedFlag.normal:     _normalRounds++;     break;
      case SpeedFlag.deliberate: _deliberateRounds++; break;
    }

    switch (decision) {
      case 'buyCash': _buyCash++; break;
      case 'loan':    _loan++;    break;
      case 'dontBuy': _dontBuy++; break;
    }

    switch (decisionQuality) {
      case 'optimal':    _optimal++;    break;
      case 'suboptimal': _suboptimal++; break;
      case 'poor':       _poor++;       break;
    }

    _levelsPlayed.add(levelId);
    if (levelId > _levelReached) _levelReached = levelId;
  }

  SessionSummary build() {
    final now = DateTime.now();
    final durationMs = now.difference(startedAt).inMilliseconds;
    final durationMinutes = durationMs / 60000;
    final avgMs = _roundCount > 0 ? _totalDecisionMs ~/ _roundCount : 0;

    // Dominant speed pattern
    final counts = {
      SpeedFlag.rushing:    _rushingRounds,
      SpeedFlag.quick:      _quickRounds,
      SpeedFlag.normal:     _normalRounds,
      SpeedFlag.deliberate: _deliberateRounds,
    };
    final dominant = counts.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;

    return SessionSummary(
      uid: uid,
      sessionId: sessionId,
      startedAt: startedAt,
      endedAt: now,
      roundCount: _roundCount,
      durationMs: durationMs,
      durationFlag: DurationFlag.fromMinutes(durationMinutes),
      avgDecisionTimeMs: avgMs,
      rushingRounds: _rushingRounds,
      quickRounds: _quickRounds,
      normalRounds: _normalRounds,
      deliberateRounds: _deliberateRounds,
      overallSpeedPattern: dominant,
      decisionsBuyCash: _buyCash,
      decisionsLoan: _loan,
      decisionsDontBuy: _dontBuy,
      qualityOptimal: _optimal,
      qualitySuboptimal: _suboptimal,
      qualityPoor: _poor,
      levelReached: _levelReached,
      levelsPlayed: _levelsPlayed.toList()..sort(),
    );
  }
}