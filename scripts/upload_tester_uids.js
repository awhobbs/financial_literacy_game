// Run with: node scripts/upload_tester_uids.js
// Uploads tester UIDs to Firestore in TWO places:
//   1. "testers" collection — one doc per UID (visible in console)
//   2. "uidLists/testers" doc — for the app's sign-in lookup

const admin = require("firebase-admin");

const PROJECT = "ofinsen-dc06d";

admin.initializeApp({ projectId: PROJECT });
const db = admin.firestore();

const testers = [
  { uid: "UGTML01", firstName: "Ester",    lastName: "Agasha",   role: "Tester-MainLead" },
  { uid: "UGTML02", firstName: "Sarah",    lastName: "Nabachwa", role: "Tester-MainLead" },
  { uid: "UGTML03", firstName: "Nathalie", lastName: "Nyanga",   role: "Tester-MainLead" },
  { uid: "UGTML04", firstName: "Lucy",     lastName: "Rono",     role: "Tester-MainLead" },
  { uid: "UGTEN01", firstName: "Doreen",   lastName: "Ninsiima", role: "Tester-Enumerator" },
  { uid: "UGTEN02", firstName: "Annet",    lastName: "Bagaaya",  role: "Tester-Enumerator" },
  { uid: "UGTEN03", firstName: "Gabriel",  lastName: "Rumwaya",  role: "Tester-Enumerator" },
  { uid: "UGTEN04", firstName: "Ronnie",   lastName: "Othieno",  role: "Tester-Enumerator" },
  { uid: "UGTEN05", firstName: "Ojok",     lastName: "Polycarp", role: "Tester-Enumerator" },
  { uid: "UGTEN06", firstName: "Emmy",     lastName: "Ezaruku",  role: "Tester-Enumerator" },
  { uid: "UGTEN07", firstName: "Blessed",  lastName: "Ithungu",  role: "Tester-Enumerator" },
  { uid: "UGTEN08", firstName: "Kasozi",   lastName: "Wava",     role: "Tester-Enumerator" },
];

async function upload() {
  const batch = db.batch();

  // 1. "testers" collection — one doc per UID using UID as doc ID
  for (const t of testers) {
    const ref = db.collection("testers").doc(t.uid);
    batch.set(ref, {
      uid: t.uid,
      firstName: t.firstName,
      lastName: t.lastName,
      role: t.role,
      createdOn: new Date(),
    });
  }

  // 2. "uidLists/testers" doc — array used by app sign-in lookup
  const uidListRef = db.collection("uidLists").doc("testers");
  batch.set(uidListRef, {
    uids: testers.map((t) => ({
      uid: t.uid,
      firstName: t.firstName,
      lastName: t.lastName,
    })),
  });

  // 3. "gamePlay/{uid}" — one stub doc per player so the collection is
  //    pre-populated and easy to browse/download even before gameplay.
  //    The app will merge round data into these docs during sync.
  for (const t of testers) {
    const ref = db.collection("gamePlay").doc(t.uid);
    batch.set(ref, {
      uid: t.uid,
      firstName: t.firstName,
      lastName: t.lastName,
      role: t.role,
      createdOn: new Date(),
    }, { merge: true });
  }

  await batch.commit();
  console.log(`✅ Written to project: ${PROJECT}`);
  console.log(`   - testers collection: ${testers.length} documents`);
  console.log(`   - uidLists/testers: ${testers.length} entries`);
  console.log(`   - gamePlay collection: ${testers.length} stub documents`);
  process.exit(0);
}

upload().catch((err) => {
  console.error("❌ Upload failed:", err);
  process.exit(1);
});