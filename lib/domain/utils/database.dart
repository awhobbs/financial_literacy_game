// ----------------------------------------------------------
//  FINAL UPDATED DATABASE.DART (NULL-SAFE)
//  Fixes String? → String errors and UID-restore
// ----------------------------------------------------------

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_literacy_game/config/constants.dart';
import 'package:flutter/material.dart';

import '../concepts/asset.dart';
import '../concepts/person.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// USERS collection
CollectionReference userCollectionRef = db.collection('users');

// UID LISTS (UGPC, UGPN, UGPE, UGPW)
CollectionReference uidListsCollectionRef = db.collection('uidLists');

// CURRENT GAME SESSION POINTERS
DocumentReference? currentGameSessionRef;
DocumentReference? currentLevelDataRef;

// ----------------------------------------------------------
//  CLEAR SESSION STATE (important when switching users)
// ----------------------------------------------------------
void clearSessionState() {
  currentGameSessionRef = null;
  currentLevelDataRef = null;
}

// ----------------------------------------------------------
//  LOOKUP USER BY UID
// ----------------------------------------------------------
Future<QuerySnapshot> _findUserInFirestoreByUID({required String uid}) async {
  return await userCollectionRef.where("uid", isEqualTo: uid).get();
}

// ----------------------------------------------------------
//  GET LATEST GAME SESSION FOR THIS USER
// ----------------------------------------------------------
Future<DocumentReference?> _findLatestGameSessionRef(
    {required Person person}) async {
  QuerySnapshot userSnap =
  await userCollectionRef.where("uid", isEqualTo: person.uid ?? "").get();

  if (userSnap.docs.isEmpty) return null;

  final userDoc = userSnap.docs.first;
  final sessions = userDoc.reference.collection("gameSessions");

  final sessionSnap = await sessions
      .orderBy("startedOn", descending: true)
      .limit(1)
      .get();

  if (sessionSnap.docs.isEmpty) return null;

  return sessionSnap.docs.first.reference;
}

// ----------------------------------------------------------
//  CREATE NEW LEVEL
// ----------------------------------------------------------
void _createNewLevel({
  required int level,
  required double startingCash,
}) async {
  if (currentGameSessionRef == null) return;

  final data = {
    "level": level,
    "startedOn": DateTime.now(),
    "levelStatus": Status.active.name,
    "periods": 0,
    "cash": [startingCash],
    "decisions": [],
    "offeredAssets": [],
    "advanceTimes": [],
  };

  final levels = currentGameSessionRef!.collection("levelData");
  currentLevelDataRef = await levels.add(data);
}

// ----------------------------------------------------------
//  RESTART LEVEL
// ----------------------------------------------------------
void restartLevelFirebase({
  required int level,
  required double startingCash,
}) async {
  if (currentLevelDataRef == null) return;

  await currentLevelDataRef!.set({
    "levelStatus": Status.lost.name,
    "completedOn": DateTime.now(),
  }, SetOptions(merge: true));

  _createNewLevel(level: level, startingCash: startingCash);
}

// ----------------------------------------------------------
//  RESTORE LAST SESSION (UID-BASED)
// ----------------------------------------------------------
Future<bool> reconnectToGameSession({required Person person}) async {
  clearSessionState();

  currentGameSessionRef =
  await _findLatestGameSessionRef(person: person);

  if (currentGameSessionRef == null) return false;

  final levelSnap = await currentGameSessionRef!
      .collection("levelData")
      .orderBy("startedOn", descending: true)
      .limit(1)
      .get();

  if (levelSnap.docs.isEmpty) return false;

  currentLevelDataRef = levelSnap.docs.first.reference;
  return true;
}

// ----------------------------------------------------------
//  PRIMARY UID LOOKUP
// ----------------------------------------------------------
Future<Person?> searchUserbyUIDInFirestore(String uid) async {
  // 1) Try USERS collection
  QuerySnapshot userSnap =
  await _findUserInFirestoreByUID(uid: uid);

  if (userSnap.docs.isNotEmpty) {
    final doc = userSnap.docs.first;
    return Person(
      firstName: doc.get("firstName") ?? "",
      lastName: doc.get("lastName") ?? "",
      uid: uid,
    );
  }

  // 2) Try UID LISTS collection
  QuerySnapshot uidSnap = await uidListsCollectionRef.get();
  for (var doc in uidSnap.docs) {
    List<dynamic> list = doc.get("uids");
    for (var entry in list) {
      if (entry["uid"] == uid) {
        return Person(
          firstName: entry["firstName"] ?? "",
          lastName: entry["lastName"] ?? "",
          uid: entry["uid"] ?? "",
        );
      }
    }
  }

  return null;
}

// ----------------------------------------------------------
//  SAVE USER (ONCE PER UID)
// ----------------------------------------------------------
Future<void> saveUserInFirestore(Person person) async {
  QuerySnapshot snap =
  await _findUserInFirestoreByUID(uid: person.uid ?? "");

  if (snap.docs.isEmpty) {
    await userCollectionRef.add({
      "firstName": person.firstName ?? "",
      "lastName": person.lastName ?? "",
      "uid": person.uid ?? "",
      "createdOn": DateTime.now(),
    });
  } else {
    await endCurrentGameSession(
        status: Status.abandoned, person: person);
  }
}

// ----------------------------------------------------------
//  START NEW GAME SESSION
// ----------------------------------------------------------
Future<void> startGameSession({
  required Person person,
  required double startingCash,
}) async {
  QuerySnapshot snap =
  await _findUserInFirestoreByUID(uid: person.uid ?? "");

  if (snap.docs.isEmpty) return;

  final userDoc = snap.docs.first;
  final sessions = userDoc.reference.collection("gameSessions");

  currentGameSessionRef = await sessions.add({
    "startedOn": DateTime.now(),
    "sessionStatus": Status.active.name,
  });

  _createNewLevel(level: 1, startingCash: startingCash);
}

// ----------------------------------------------------------
//  END SESSION
// ----------------------------------------------------------
Future<void> endCurrentGameSession({
  required Status status,
  Person? person,
}) async {
  if (currentGameSessionRef == null) {
    if (person == null) return;
    bool ok = await reconnectToGameSession(person: person);
    if (!ok) return;
  }

  await currentLevelDataRef!.set({
    "levelStatus": status.name,
    "completedOn": DateTime.now(),
  }, SetOptions(merge: true));

  await currentGameSessionRef!.set({
    "sessionStatus": status.name,
    "completedOn": DateTime.now(),
  }, SetOptions(merge: true));
}

// ----------------------------------------------------------
//  NEXT LEVEL
// ----------------------------------------------------------
void newLevelFirestore({
  required int levelID,
  required double startingCash,
}) async {
  await currentLevelDataRef!.set({
    "levelStatus": Status.won.name,
    "completedOn": DateTime.now(),
  }, SetOptions(merge: true));

  _createNewLevel(level: levelID + 1, startingCash: startingCash);
}

// ----------------------------------------------------------
//  ADVANCE PERIOD
// ----------------------------------------------------------
void advancePeriodFirestore({
  required double newCashValue,
  required BuyDecision buyDecision,
  required Asset offeredAsset,
}) async {
  DocumentSnapshot snap = await currentLevelDataRef!.get();

  List<double> cash = List.from(snap.get("cash"));
  List<String> decisions = List.from(snap.get("decisions"));
  List<String> times = List<String>.from(snap.get("advanceTimes"));
  List offered = List.from(snap.get("offeredAssets"));

  cash.add(double.parse(newCashValue.toStringAsFixed(2)));
  decisions.add(buyDecision.name);
  times.add(DateTime.now().toIso8601String());

  offered.add({
    "type": offeredAsset.type.name,
    "price": offeredAsset.price,
    "income": offeredAsset.income,
    "riskLevel": offeredAsset.riskLevel,
    "lifeExpectancy": offeredAsset.lifeExpectancy,
  });

  snap.reference.set({
    "periods": FieldValue.increment(1),
    "cash": cash,
    "decisions": decisions,
    "offeredAssets": offered,
    "advanceTimes": times,
  }, SetOptions(merge: true));
}

// ----------------------------------------------------------
enum Status { active, won, lost, abandoned }
// ----------------------------------------------------------
