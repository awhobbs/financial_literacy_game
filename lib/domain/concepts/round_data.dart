import 'asset.dart';

/// Represents the state snapshot at a point in time
class StateSnapshot {
  final double cash;
  final double totalAssets;
  final double totalLoans;
  final double totalIncome;
  final double totalExpenses;

  StateSnapshot({
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

  factory StateSnapshot.fromMap(Map<String, dynamic> map) {
    return StateSnapshot(
      cash: (map['cash'] as num).toDouble(),
      totalAssets: (map['totalAssets'] as num).toDouble(),
      totalLoans: (map['totalLoans'] as num).toDouble(),
      totalIncome: (map['totalIncome'] as num).toDouble(),
      totalExpenses: (map['totalExpenses'] as num).toDouble(),
    );
  }
}

/// Represents the offered asset in a round
class OfferedAssetData {
  final String type;
  final double price;
  final double income;
  final double riskLevel;
  final int lifeExpectancy;

  OfferedAssetData({
    required this.type,
    required this.price,
    required this.income,
    required this.riskLevel,
    required this.lifeExpectancy,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'price': price,
      'income': income,
      'riskLevel': riskLevel,
      'lifeExpectancy': lifeExpectancy,
    };
  }

  factory OfferedAssetData.fromMap(Map<String, dynamic> map) {
    return OfferedAssetData(
      type: map['type'] as String,
      price: (map['price'] as num).toDouble(),
      income: (map['income'] as num).toDouble(),
      riskLevel: (map['riskLevel'] as num).toDouble(),
      lifeExpectancy: map['lifeExpectancy'] as int,
    );
  }

  factory OfferedAssetData.fromAsset(Asset asset) {
    return OfferedAssetData(
      type: asset.type.name,
      price: asset.price,
      income: asset.income,
      riskLevel: asset.riskLevel,
      lifeExpectancy: asset.lifeExpectancy,
    );
  }
}

/// Decision quality assessment
enum DecisionQuality {
  optimal,
  suboptimal,
  poor,
}

/// Complete round data for analytics
class RoundData {
  final String uid;
  final String sessionId;
  final int levelId;
  final int roundNumber;
  final DateTime roundStartedAt;
  final DateTime decisionMadeAt;
  final int decisionTimeMs;
  final String decision; // "buyCash" | "loan" | "dontBuy"
  final StateSnapshot stateBefore;
  final StateSnapshot stateAfter;
  final OfferedAssetData offeredAsset;
  final List<String> conceptsTested;
  final DecisionQuality decisionQuality;
  final bool assetDied;

  RoundData({
    required this.uid,
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
    required this.assetDied,
  });

  /// Convert to map for Firestore/queue storage
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'sessionId': sessionId,
      'levelId': levelId,
      'roundNumber': roundNumber,
      'roundStartedAt': roundStartedAt.toIso8601String(),
      'decisionMadeAt': decisionMadeAt.toIso8601String(),
      'decisionTimeMs': decisionTimeMs,
      'decision': decision,
      'stateBefore': stateBefore.toMap(),
      'stateAfter': stateAfter.toMap(),
      'offeredAsset': offeredAsset.toMap(),
      'conceptsTested': conceptsTested,
      'decisionQuality': decisionQuality.name,
      'assetDied': assetDied,
    };
  }

  factory RoundData.fromMap(Map<String, dynamic> map) {
    return RoundData(
      uid: map['uid'] as String,
      sessionId: map['sessionId'] as String,
      levelId: map['levelId'] as int,
      roundNumber: map['roundNumber'] as int,
      roundStartedAt: DateTime.parse(map['roundStartedAt'] as String),
      decisionMadeAt: DateTime.parse(map['decisionMadeAt'] as String),
      decisionTimeMs: map['decisionTimeMs'] as int,
      decision: map['decision'] as String,
      stateBefore: StateSnapshot.fromMap(
        map['stateBefore'] as Map<String, dynamic>,
      ),
      stateAfter: StateSnapshot.fromMap(
        map['stateAfter'] as Map<String, dynamic>,
      ),
      offeredAsset: OfferedAssetData.fromMap(
        map['offeredAsset'] as Map<String, dynamic>,
      ),
      conceptsTested: List<String>.from(map['conceptsTested'] as List),
      decisionQuality: DecisionQuality.values.firstWhere(
        (e) => e.name == map['decisionQuality'],
        orElse: () => DecisionQuality.suboptimal,
      ),
      assetDied: map['assetDied'] as bool,
    );
  }

  /// Create a queue action for offline storage
  Map<String, dynamic> toQueueAction() {
    return {
      'collection': 'roundData',
      'data': toMap(),
      'doc': null, // Will be auto-generated by Firestore
    };
  }
}

/// Helper to determine concepts tested based on level and decision
List<String> getConceptsTested({
  required int levelId,
  required String decision,
  required double assetRiskLevel,
  required double loanInterestRate,
  required bool hasSavingsRate,
}) {
  final concepts = <String>[];

  // Basic concept always tested
  concepts.add('asset_acquisition');

  // Risk assessment if there's risk involved
  if (assetRiskLevel > 0) {
    concepts.add('risk_assessment');
  }

  // Cash flow management is always relevant
  concepts.add('cash_flow_management');

  // Loan-specific concepts
  if (decision == 'loan') {
    concepts.add('debt_management');
    concepts.add('interest_calculation');
  }

  // Savings concepts if savings rate is active
  if (hasSavingsRate) {
    concepts.add('opportunity_cost');
    concepts.add('savings_vs_investment');
  }

  // Higher levels introduce more concepts
  if (levelId >= 2) {
    concepts.add('portfolio_diversification');
  }

  return concepts;
}

/// Helper to assess decision quality
DecisionQuality assessDecisionQuality({
  required String decision,
  required double cash,
  required double assetPrice,
  required double assetIncome,
  required double assetRiskLevel,
  required int assetLifeExpectancy,
  required double loanInterestRate,
  required double savingsRate,
}) {
  // Calculate expected return from asset
  final expectedAssetReturn =
      assetIncome * assetLifeExpectancy * (1 - assetRiskLevel);

  // Calculate potential savings return
  final savingsReturn = cash * savingsRate * assetLifeExpectancy;

  // Calculate loan cost
  final loanCost = assetPrice * loanInterestRate * assetLifeExpectancy;

  switch (decision) {
    case 'buyCash':
      if (cash >= assetPrice) {
        // Good if expected return > opportunity cost
        if (expectedAssetReturn > savingsReturn) {
          return DecisionQuality.optimal;
        }
        return DecisionQuality.suboptimal;
      }
      return DecisionQuality.poor; // Shouldn't happen - can't buy without cash

    case 'loan':
      // Good if net return after interest is positive
      final netReturn = expectedAssetReturn - loanCost;
      if (netReturn > 0) {
        return DecisionQuality.optimal;
      } else if (netReturn > -assetPrice * 0.1) {
        return DecisionQuality.suboptimal;
      }
      return DecisionQuality.poor;

    case 'dontBuy':
      // Good if saving was better than buying
      if (savingsReturn > expectedAssetReturn || cash < assetPrice) {
        return DecisionQuality.optimal;
      } else if (assetRiskLevel > 0.3) {
        // Risk aversion is acceptable
        return DecisionQuality.suboptimal;
      }
      return DecisionQuality.poor;

    default:
      return DecisionQuality.suboptimal;
  }
}
