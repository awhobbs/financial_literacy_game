import csv
import firebase_admin
from firebase_admin import credentials, firestore, initialize_app
from datetime import datetime

# ----------------------------------------------------
# 1. Firebase setup
# ----------------------------------------------------
cred = credentials.Certificate('firebase_admin.json')
app = initialize_app(cred)
db = firestore.client()

# ----------------------------------------------------
# 2. Load the combined CSV file
# ----------------------------------------------------
CSV_FILE = "Uganda_Pilot_All_Regions.csv"

print(f"Loading data from: {CSV_FILE}")

uids_by_region = {}
enumerators_by_region = {}

with open(CSV_FILE) as csv_file:
    csv_reader = csv.DictReader(csv_file)

    for row in csv_reader:
        uid = row["uid"].strip()
        first_name = row["First_name"] if row["First_name"] else ""
        last_name = row["Last_name"] if row["Last_name"] else ""
        enumerator = row["Enumerator"].strip() if row["Enumerator"] else ""
        region = row["Region"].strip()

        # Initialize region if not seen yet
        if region not in uids_by_region:
            uids_by_region[region] = []
            enumerators_by_region[region] = set()

        # Add UID entry
        uids_by_region[region].append({
            "uid": uid,
            "firstName": first_name,
            "lastName": last_name,
            "usageLog": []  # <-- NEW field for logs
        })

        # Add enumerator (unique)
        if enumerator:
            enumerators_by_region[region].add(enumerator)

# ----------------------------------------------------
# 3. Upload to Firestore per region
# ----------------------------------------------------
uidLists = db.collection("uidLists")

print("\nUploading to Firestore...\n")

for region in uids_by_region.keys():

    print(f"Updating region: {region}")
    print(f"UID count: {len(uids_by_region[region])}")
    print(f"Enumerators: {list(enumerators_by_region[region])}")

    doc_ref = uidLists.document(region)

    # Upload structure
    doc_ref.set({
        "uids": uids_by_region[region],
        "enumerators": list(enumerators_by_region[region])
    })

    print(f"✔ Uploaded {region}\n")

print("🔥 All regions updated successfully!")
