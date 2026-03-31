import 'asset.dart';
import 'loan.dart';

/// Represents the full saved game state for persistence
class SavedGameState {
  final String? uid;
  final int levelId;
  final int period;
  final double cash;
  final List<SavedAsset> assets;
  final List<SavedLoan> loans;
  final String locale;
  final DateTime savedAt;

  SavedGameState({
    this.uid,
    required this.levelId,
    required this.period,
    required this.cash,
    required this.assets,
    required this.loans,
    required this.locale,
    required this.savedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'levelId': levelId,
      'period': period,
      'cash': cash,
      'assets': assets.map((a) => a.toMap()).toList(),
      'loans': loans.map((l) => l.toMap()).toList(),
      'locale': locale,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory SavedGameState.fromMap(Map<String, dynamic> map) {
    return SavedGameState(
      uid: map['uid'] as String?,
      levelId: map['levelId'] as int,
      period: map['period'] as int,
      cash: (map['cash'] as num).toDouble(),
      assets: (map['assets'] as List<dynamic>)
          .map((a) => SavedAsset.fromMap(a as Map<String, dynamic>))
          .toList(),
      loans: (map['loans'] as List<dynamic>)
          .map((l) => SavedLoan.fromMap(l as Map<String, dynamic>))
          .toList(),
      locale: map['locale'] as String,
      savedAt: DateTime.parse(map['savedAt'] as String),
    );
  }
}

/// Saved representation of an Asset for persistence
class SavedAsset {
  final String type;
  final int numberOfAnimals;
  final String imagePath;
  final double price;
  final double income;
  final double riskLevel;
  final int lifeExpectancy;
  final int age;

  SavedAsset({
    required this.type,
    required this.numberOfAnimals,
    required this.imagePath,
    required this.price,
    required this.income,
    required this.riskLevel,
    required this.lifeExpectancy,
    required this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'numberOfAnimals': numberOfAnimals,
      'imagePath': imagePath,
      'price': price,
      'income': income,
      'riskLevel': riskLevel,
      'lifeExpectancy': lifeExpectancy,
      'age': age,
    };
  }

  factory SavedAsset.fromMap(Map<String, dynamic> map) {
    return SavedAsset(
      type: map['type'] as String,
      numberOfAnimals: map['numberOfAnimals'] as int,
      imagePath: map['imagePath'] as String,
      price: (map['price'] as num).toDouble(),
      income: (map['income'] as num).toDouble(),
      riskLevel: (map['riskLevel'] as num).toDouble(),
      lifeExpectancy: map['lifeExpectancy'] as int,
      age: map['age'] as int,
    );
  }

  /// Convert from Asset to SavedAsset
  factory SavedAsset.fromAsset(Asset asset) {
    return SavedAsset(
      type: asset.type.name,
      numberOfAnimals: asset.numberOfAnimals,
      imagePath: asset.imagePath,
      price: asset.price,
      income: asset.income,
      riskLevel: asset.riskLevel,
      lifeExpectancy: asset.lifeExpectancy,
      age: asset.age,
    );
  }

  /// Convert SavedAsset back to Asset
  Asset toAsset() {
    return Asset(
      type: AssetType.values.firstWhere((t) => t.name == type),
      numberOfAnimals: numberOfAnimals,
      imagePath: imagePath,
      price: price,
      income: income,
      riskLevel: riskLevel,
      lifeExpectancy: lifeExpectancy,
      age: age,
    );
  }
}

/// Saved representation of a Loan for persistence
class SavedLoan {
  final double interestRate;
  final SavedAsset asset;
  final int termInPeriods;
  final int age;

  SavedLoan({
    required this.interestRate,
    required this.asset,
    required this.termInPeriods,
    required this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'interestRate': interestRate,
      'asset': asset.toMap(),
      'termInPeriods': termInPeriods,
      'age': age,
    };
  }

  factory SavedLoan.fromMap(Map<String, dynamic> map) {
    return SavedLoan(
      interestRate: (map['interestRate'] as num).toDouble(),
      asset: SavedAsset.fromMap(map['asset'] as Map<String, dynamic>),
      termInPeriods: map['termInPeriods'] as int,
      age: map['age'] as int,
    );
  }

  /// Convert from Loan to SavedLoan
  factory SavedLoan.fromLoan(Loan loan) {
    return SavedLoan(
      interestRate: loan.interestRate,
      asset: SavedAsset.fromAsset(loan.asset),
      termInPeriods: loan.termInPeriods,
      age: loan.age,
    );
  }

  /// Convert SavedLoan back to Loan
  Loan toLoan() {
    return Loan(
      interestRate: interestRate,
      asset: asset.toAsset(),
      termInPeriods: termInPeriods,
      age: age,
    );
  }
}
