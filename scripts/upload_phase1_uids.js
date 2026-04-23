// Run with: node scripts/upload_phase1_uids.js
//
// Uploads ALL phase 1 participant UIDs to BOTH Firebase projects:
//   - finlitsim       (production)
//   - ofinsen-dc06d   (tester)
//
// Writes to three places per project:
//   1. uidLists/phase1        — array used by app sign-in lookup
//   2. gamePlay/{uid}         — stub doc with phase tag (for analysis)
//   3. phase1Players/{uid}    — dedicated phase 1 collection for easy export

const admin = require("firebase-admin");
const fs    = require("fs");
const path  = require("path");

const PROJECTS   = ["finlitsim", "ofinsen-dc06d"];
const CSV_PATH   = path.join(__dirname, "../uids/uids_phase1.csv");
const BATCH_SIZE = 490; // Firestore max is 500 ops/batch — stay safely under

// ─── Parse CSV ────────────────────────────────────────────────────────────────
function parseCSV(filePath) {
  let content = fs.readFileSync(filePath, "utf8");

  // Strip BOM if present
  if (content.charCodeAt(0) === 0xFEFF) content = content.slice(1);

  const lines = content
    .split("\n")
    .map(l => l.replace(/\r/g, "").trim())
    .filter(l => l.length > 0);

  // Skip header row
  const records = [];
  const seen    = new Set();

  for (let i = 1; i < lines.length; i++) {
    const parts = lines[i].split(",").map(p => p.trim());
    const uid   = parts[0];
    if (!uid || seen.has(uid)) continue; // skip blank / duplicate rows
    seen.add(uid);
    records.push({
      uid,
      firstName: parts[1] || "",
      lastName:  parts[2] || "",
    });
  }
  return records;
}

// ─── Upload to one Firebase project ───────────────────────────────────────────
async function uploadToProject(projectId, participants) {
  console.log(`\n📤  Project: ${projectId}  (${participants.length} unique participants)`);

  const app = admin.initializeApp({ projectId }, projectId);
  const db  = admin.firestore(app);

  // 1. uidLists/phase1 — single document, uids array ─────────────────────────
  await db.collection("uidLists").doc("phase1").set({
    uids: participants.map(p => ({
      uid:       p.uid,
      firstName: p.firstName,
      lastName:  p.lastName,
    })),
  });
  console.log(`   ✅  uidLists/phase1: ${participants.length} entries`);

  // 2. gamePlay/{uid} stubs — batched ────────────────────────────────────────
  let gamePlayCount = 0;
  for (let i = 0; i < participants.length; i += BATCH_SIZE) {
    const chunk = participants.slice(i, i + BATCH_SIZE);
    const batch = db.batch();
    for (const p of chunk) {
      batch.set(
        db.collection("gamePlay").doc(p.uid),
        {
          uid:       p.uid,
          firstName: p.firstName,
          lastName:  p.lastName,
          phase:     "phase1",
          createdOn: new Date(),
        },
        { merge: true }
      );
    }
    await batch.commit();
    gamePlayCount += chunk.length;
    console.log(`   ✅  gamePlay stubs: ${gamePlayCount}/${participants.length}`);
  }

  // 3. phase1Players/{uid} — dedicated phase 1 collection ────────────────────
  let phase1Count = 0;
  for (let i = 0; i < participants.length; i += BATCH_SIZE) {
    const chunk = participants.slice(i, i + BATCH_SIZE);
    const batch = db.batch();
    for (const p of chunk) {
      batch.set(
        db.collection("phase1Players").doc(p.uid),
        {
          uid:       p.uid,
          firstName: p.firstName,
          lastName:  p.lastName,
          phase:     "phase1",
          createdOn: new Date(),
        },
        { merge: true }
      );
    }
    await batch.commit();
    phase1Count += chunk.length;
    console.log(`   ✅  phase1Players: ${phase1Count}/${participants.length}`);
  }

  // 4. participants/{uid} — app summary collection (new structure) ─────────────
  //    Stub ensures the document exists in Firebase console before gameplay.
  //    The app merges aggregate stats here during sync.
  let participantsCount = 0;
  for (let i = 0; i < participants.length; i += BATCH_SIZE) {
    const chunk = participants.slice(i, i + BATCH_SIZE);
    const batch = db.batch();
    for (const p of chunk) {
      batch.set(
        db.collection("participants").doc(p.uid),
        {
          uid:          p.uid,
          firstName:    p.firstName,
          lastName:     p.lastName,
          phase:        "phase1",
          createdOn:    new Date(),
          totalRounds:  0,
          levelReached: 0,
        },
        { merge: true }
      );
    }
    await batch.commit();
    participantsCount += chunk.length;
    console.log(`   ✅  participants stubs: ${participantsCount}/${participants.length}`);
  }

  // 5. participantDecisions/{uid} — app flat decision map (new structure) ───────
  //    Stub ensures the document exists so researchers can find it even before
  //    the first decision is synced.  The app adds round keys here during sync.
  let decisionsCount = 0;
  for (let i = 0; i < participants.length; i += BATCH_SIZE) {
    const chunk = participants.slice(i, i + BATCH_SIZE);
    const batch = db.batch();
    for (const p of chunk) {
      batch.set(
        db.collection("participantDecisions").doc(p.uid),
        {
          uid:       p.uid,
          firstName: p.firstName,
          lastName:  p.lastName,
          phase:     "phase1",
          createdOn: new Date(),
        },
        { merge: true }
      );
    }
    await batch.commit();
    decisionsCount += chunk.length;
    console.log(`   ✅  participantDecisions stubs: ${decisionsCount}/${participants.length}`);
  }

  await app.delete();
}

// ─── Main ─────────────────────────────────────────────────────────────────────
async function main() {
  const participants = parseCSV(CSV_PATH);
  console.log(`📋  Parsed ${participants.length} unique phase 1 participants`);

  for (const projectId of PROJECTS) {
    await uploadToProject(projectId, participants);
  }

  console.log("\n✅  Done! Phase 1 UIDs uploaded to all Firebase projects.");
  process.exit(0);
}

main().catch(err => {
  console.error("❌  Upload failed:", err);
  process.exit(1);
});