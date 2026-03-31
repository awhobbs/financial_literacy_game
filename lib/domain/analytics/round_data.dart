import '../concepts/asset.dart';

/// Represents all data collected for a single round/decision in the game
class RoundData {
  final String? uid;
  final String sessionId;
  final int levelId;
  final int roundNumber;

  // Timestamps
  final DateTime roundStartedAt;
  final DateTime decisionMadeAt;

  // Time tracking
  final int decisionTimeMs;

  // Decision made
  final String decision; // buyCash, loan, dontBuy

  // Game state snapshots
  final GameStateSnapshot stateBefore;
  final GameStateSnapshot stateAfter;

  // Offered asset details
  final Map<String, dynamic> offeredAsset;

  // Analytics
  final List<String> conceptsTested;
  final String decisionQuality; // optimal, suboptimal, poor

  // Events that occurred
  final bool assetDied;
  final String? diedAssetType;

  RoundData({
    this.uid,
    required this.sessionId,
    required this.levelId,
    required this.roundNumber,
    required this.roundStartedAt,
    required this.decisionMadeAt,
    required this.decisionTimeMs,
    required this.decision,
    required this.stateBefore,
    required this.stateAfter,
    required this.offeredAsset,
    required this.conceptsTested,
    required this.decisionQuality,
    this.assetDied = false,
    this.diedAssetType,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid ?? '',
      'sessionId': sessionId,
      'levelId': levelId,
      'roundNumber': roundNumber,
      'roundStartedAt': roundStartedAt.toIso8601String(),
      'decisionMadeAt': decisionMadeAt.toIso8601String(),
      'decisionTimeMs': decisionTimeMs,
      'decision': decision,
      'stateBefore': stateBefore.toMap(),
      'stateAfter': stateAfter.toMap(),
      'offeredAsset': offeredAsset,
      'conceptsTested': conceptsTested,
      'decisionQuality': decisionQuality,
      'assetDied': assetDied,
      'diedAssetType': diedAssetType,
    };
  }

  factory RoundData.fromMap(Map<String, dynamic> map) {
    return RoundData(
      uid: map['uid'] as String?,
      sessionId: map['sessionId'] as String,
      levelId: map['levelId'] as int,
      roundNumber: map['roundNumber'] as int,
      roundStartedAt: DateTime.parse(map['roundStartedAt'] as String),
      decisionMadeAt: DateTime.parse(map['decisionMadeAt'] as String),
      decisionTimeMs: map['decisionTimeMs'] as int,
      decision: map['decision'] as String,
      stateBefore:
          GameStateSnapshot.fromMap(map['stateBefore'] as Map<String, dynamic>),
      stateAfter:
          GameStateSnapshot.fromMap(map['stateAfter'] as Map<String, dynamic>),
      offeredAsset: Map<String, dynamic>.from(map['offeredAsset'] as Map),
      conceptsTested: List<String>.from(map['conceptsTested'] as List),
      decisionQuality: map['decisionQuality'] as String,
      assetDied: map['assetDied'] as bool? ?? false,
      diedAssetType: map['diedAssetType'] as String?,
    );
  }

  /// Create offered asset map from Asset object
  static Map<String, dynamic> assetToMap(Asset asset) {
    return {
      'type': asset.type.name,
      'price': asset.price,
      'income': asset.income,
      'riskLevel': asset.riskLevel,
      'lifeExpectancy': asset.lifeExpectancy,
    };
  }
}

/// Snapshot of game state at a point in time
class GameStateSnapshot {
  final double cash;
  final int totalAssets;
  final int totalLoans;
  final double totalIncome;
  final double totalExpenses;

  GameStateSnapshot({
    required this.cash,
    required this.totalAssets,
    required this.totalLoans,
    required this.totalIncome,
    required this.totalExpenses,
  });

  Map<String, dynamic> toMap() {
    return {
      'cash': cash,
      'totalAssets': totalAssets,
      'totalLoans': totalLoans,
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
    };
  }

  factory GameStateSnapshot.fromMap(Map<String, dynamic> map) {
    return GameStateSnapshot(
      cash: (map['cash'] as num).toDouble(),
      totalAssets: map['totalAssets'] as int,
      totalLoans: map['totalLoans'] as int,
      totalIncome: (map['totalIncome'] as num).toDouble(),
      totalExpenses: (map['totalExpenses'] as num).toDouble(),
    );
  }
}
