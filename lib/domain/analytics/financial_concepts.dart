import '../concepts/asset.dart';
import '../concepts/loan.dart';
import '../concepts/level.dart';

/// Financial concepts tracked in the game for analytics
class FinancialConcepts {
  /// Core financial concepts being tested
  static const String riskAssessment = 'risk_assessment';
  static const String loanManagement = 'loan_management';
  static const String cashFlowManagement = 'cash_flow_management';
  static const String diversification = 'diversification';
  static const String opportunityCost = 'opportunity_cost';
  static const String compoundGrowth = 'compound_growth';

  /// All available concepts
  static const List<String> allConcepts = [
    riskAssessment,
    loanManagement,
    cashFlowManagement,
    diversification,
    opportunityCost,
    compoundGrowth,
  ];
}

/// Maps game situations to the financial concepts being tested
class ConceptMapper {
  /// Determine which financial concepts are being tested in the current decision
  static List<String> getTestedConcepts({
    required Level level,
    required Asset offeredAsset,
    required List<Asset> currentAssets,
    required List<Loan> currentLoans,
    required double currentCash,
  }) {
    List<String> concepts = [];

    // Risk assessment - when assets have non-zero risk levels
    if (level.assetRiskLevelActive && offeredAsset.riskLevel > 0) {
      concepts.add(FinancialConcepts.riskAssessment);
    }

    // Loan management - when loan option is available
    if (level.showLoanBorrowOption) {
      concepts.add(FinancialConcepts.loanManagement);
    }

    // Cash flow management - always relevant when making buy decisions
    if (level.showCashBuyOption || level.showLoanBorrowOption) {
      concepts.add(FinancialConcepts.cashFlowManagement);
    }

    // Diversification - when player already owns assets
    if (currentAssets.isNotEmpty) {
      // Check if player owns different asset types
      Set<AssetType> ownedTypes = currentAssets.map((a) => a.type).toSet();
      if (ownedTypes.length > 1 || offeredAsset.type != ownedTypes.first) {
        concepts.add(FinancialConcepts.diversification);
      }
    }

    // Opportunity cost - when both cash buy and loan options exist
    if (level.showCashBuyOption && level.showLoanBorrowOption) {
      concepts.add(FinancialConcepts.opportunityCost);
    }

    // Compound growth - when savings rate is active
    if (level.savingsRate > 0 || level.savingsInterestRandomized) {
      concepts.add(FinancialConcepts.compoundGrowth);
    }

    return concepts;
  }
}
