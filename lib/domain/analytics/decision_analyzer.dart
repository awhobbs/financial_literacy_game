import '../concepts/asset.dart';
import '../concepts/loan.dart';
import '../concepts/level.dart';

/// Decision quality ratings
class DecisionQuality {
  static const String optimal = 'optimal';
  static const String suboptimal = 'suboptimal';
  static const String poor = 'poor';
}

/// Analyzes player decisions to determine quality for analytics
class DecisionAnalyzer {
  /// Evaluate the quality of a decision
  /// Returns: "optimal", "suboptimal", or "poor"
  static String evaluateDecision({
    required BuyDecision decision,
    required Asset offeredAsset,
    required Level level,
    required double currentCash,
    required List<Asset> currentAssets,
    required List<Loan> currentLoans,
  }) {
    // Calculate key metrics
    double assetROI = _calculateROI(offeredAsset);
    double loanCost =
        level.showLoanBorrowOption ? level.loan.interestRate : 0;
    bool canAffordCash = currentCash >= offeredAsset.price;
    double cashAfterPurchase = currentCash - offeredAsset.price;

    // Calculate current income and expenses
    double currentIncome =
        currentAssets.fold(0.0, (sum, a) => sum + a.income);
    double currentExpenses =
        currentLoans.fold(0.0, (sum, l) => sum + l.paymentPerPeriod);
    double currentNetFlow = currentIncome - currentExpenses;

    // Evaluate based on decision type
    switch (decision) {
      case BuyDecision.buyCash:
        return _evaluateBuyCash(
          offeredAsset: offeredAsset,
          canAffordCash: canAffordCash,
          cashAfterPurchase: cashAfterPurchase,
          assetROI: assetROI,
          currentNetFlow: currentNetFlow,
          level: level,
        );

      case BuyDecision.loan:
        return _evaluateLoan(
          offeredAsset: offeredAsset,
          loanCost: loanCost,
          assetROI: assetROI,
          currentLoans: currentLoans,
          currentNetFlow: currentNetFlow,
          canAffordCash: canAffordCash,
          level: level,
        );

      case BuyDecision.dontBuy:
        return _evaluateDontBuy(
          offeredAsset: offeredAsset,
          canAffordCash: canAffordCash,
          assetROI: assetROI,
          currentCash: currentCash,
          level: level,
          currentNetFlow: currentNetFlow,
        );
    }
  }

  /// Calculate simple ROI for an asset
  static double _calculateROI(Asset asset) {
    if (asset.price == 0) return 0;
    // ROI = (income * lifeExpectancy - price) / price
    double totalReturn = asset.income * asset.lifeExpectancy;
    return (totalReturn - asset.price) / asset.price;
  }

  /// Evaluate buying with cash
  static String _evaluateBuyCash({
    required Asset offeredAsset,
    required bool canAffordCash,
    required double cashAfterPurchase,
    required double assetROI,
    required double currentNetFlow,
    required Level level,
  }) {
    // Can't actually afford it - poor decision
    if (!canAffordCash) {
      return DecisionQuality.poor;
    }

    // Good ROI and maintains positive cash buffer
    if (assetROI > 0.3 && cashAfterPurchase >= 5) {
      return DecisionQuality.optimal;
    }

    // Asset has positive ROI
    if (assetROI > 0) {
      // But leaves very little cash - risky
      if (cashAfterPurchase < 3) {
        return DecisionQuality.suboptimal;
      }
      return DecisionQuality.optimal;
    }

    // Negative ROI asset - poor choice
    if (assetROI < 0) {
      return DecisionQuality.poor;
    }

    return DecisionQuality.suboptimal;
  }

  /// Evaluate taking a loan
  static String _evaluateLoan({
    required Asset offeredAsset,
    required double loanCost,
    required double assetROI,
    required List<Loan> currentLoans,
    required double currentNetFlow,
    required bool canAffordCash,
    required Level level,
  }) {
    // Calculate loan payment
    double loanPayment = offeredAsset.price * (1 + loanCost) /
        level.loan.termInPeriods;

    // Net income from asset after loan payment
    double netFromAsset = offeredAsset.income - loanPayment;

    // If asset income covers loan payment - generally good
    if (netFromAsset > 0) {
      // Could have paid cash but chose loan - suboptimal
      if (canAffordCash) {
        return DecisionQuality.suboptimal;
      }
      return DecisionQuality.optimal;
    }

    // Loan payment exceeds asset income
    if (netFromAsset < 0) {
      // But overall still positive cash flow
      if (currentNetFlow + netFromAsset > 0) {
        return DecisionQuality.suboptimal;
      }
      // Will likely cause cash flow problems
      return DecisionQuality.poor;
    }

    // Taking too many loans is risky
    if (currentLoans.length >= 2) {
      return DecisionQuality.suboptimal;
    }

    return DecisionQuality.suboptimal;
  }

  /// Evaluate choosing not to buy
  static String _evaluateDontBuy({
    required Asset offeredAsset,
    required bool canAffordCash,
    required double assetROI,
    required double currentCash,
    required Level level,
    required double currentNetFlow,
  }) {
    // High ROI asset available and can afford - missed opportunity
    if (assetROI > 0.5 && canAffordCash) {
      return DecisionQuality.poor;
    }

    // Good ROI and can afford - suboptimal
    if (assetROI > 0.2 && canAffordCash) {
      return DecisionQuality.suboptimal;
    }

    // Asset has negative or low ROI - good to skip
    if (assetROI < 0.1) {
      return DecisionQuality.optimal;
    }

    // High risk asset and chose to skip - smart
    if (offeredAsset.riskLevel > 0.25) {
      return DecisionQuality.optimal;
    }

    // Can't afford and no loan option - only choice
    if (!canAffordCash && !level.showLoanBorrowOption) {
      return DecisionQuality.optimal;
    }

    // Saving cash when low - prudent
    if (currentCash < 10 && !canAffordCash) {
      return DecisionQuality.optimal;
    }

    return DecisionQuality.suboptimal;
  }
}

/// Buy decision types (matching the game's existing enum)
enum BuyDecision { buyCash, loan, dontBuy }
