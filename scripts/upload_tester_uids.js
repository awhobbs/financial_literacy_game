// Run with: node scripts/upload_tester_uids.js
// Uploads tester UIDs to the uidLists collection in Firestore (finlitsim project)

const admin = require("firebase-admin");

// Use application default credentials (firebase CLI login)
admin.initializeApp({
  projectId: "finlitsim",
});

const db = admin.firestore();

const testers = [
  { uid: "UGTML01", firstName: "Ester",   lastName: "Agasha",   role: "Tester-MainLead" },
  { uid: "UGTML02", firstName: "Sarah",   lastName: "Nabachwa", role: "Tester-MainLead" },
  { uid: "UGTML03", firstName: "Nathalie",lastName: "Nyanga",   role: "Tester-MainLead" },
  { uid: "UGTML04", firstName: "Lucy",    lastName: "Rono",     role: "Tester-MainLead" },
  { uid: "UGTEN01", firstName: "Doreen",  lastName: "Ninsiima", role: "Tester-Enumerator" },
  { uid: "UGTEN02", firstName: "Annet",   lastName: "Bagaaya",  role: "Tester-Enumerator" },
  { uid: "UGTEN03", firstName: "Gabriel", lastName: "Rumwaya",  role: "Tester-Enumerator" },
  { uid: "UGTEN04", firstName: "Ronnie",  lastName: "Othieno",  role: "Tester-Enumerator" },
  { uid: "UGTEN05", firstName: "Ojok",    lastName: "Polycarp", role: "Tester-Enumerator" },
  { uid: "UGTEN06", firstName: "Emmy",    lastName: "Ezaruku",  role: "Tester-Enumerator" },
  { uid: "UGTEN07", firstName: "Blessed", lastName: "Ithungu",  role: "Tester-Enumerator" },
  { uid: "UGTEN08", firstName: "Kasozi",  lastName: "Wava",     role: "Tester-Enumerator" },
];

async function upload() {
  // Store as a single doc "testers" in uidLists, matching existing structure
  await db.collection("uidLists").doc("testers").set({
    uids: testers.map((t) => ({
      uid: t.uid,
      firstName: t.firstName,
      lastName: t.lastName,
      role: t.role,
    })),
  });

  console.log(`✅ Uploaded ${testers.length} tester UIDs to uidLists/testers`);
  process.exit(0);
}

upload().catch((err) => {
  console.error("❌ Upload failed:", err);
  process.exit(1);
});