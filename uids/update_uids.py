import csv
import firebase_admin
from firebase_admin import credentials, firestore, initialize_app

# ------------------------------------------
# 1. Firebase setup
# ------------------------------------------
cred = credentials.Certificate('firebase_admin.json')
app = initialize_app(cred)
db = firestore.client()

# ------------------------------------------
# 2. Load the combined CSV
# ------------------------------------------
CSV_FILE = "Uganda_Pilot_All_Regions.csv"

print(f"Loading data from: {CSV_FILE}")

uids_by_region = {}
enumerators_by_region = {}

with open(CSV_FILE, encoding="utf-8-sig") as csv_file:
    csv_reader = csv.DictReader(csv_file)

    for row in csv_reader:
        # Extract fields EXACTLY matching your CSV headers
        uid = row["uid"].strip()
        first_name = (row["First_name"] or "").strip()
        last_name = (row["Last_name"] or "").strip()

        # Enumerator column has a trailing space in your CSV
        enumerator = (row["Enumerator "] or "").strip()

        # Region exists exactly as "Region"
        region = row["Region"].strip()

        # Initialize lists for each region
        if region not in uids_by_region:
            uids_by_region[region] = []
            enumerators_by_region[region] = set()

        # Add UID entry with usageLog field
        uids_by_region[region].append({
            "uid": uid,
            "firstName": first_name,
            "lastName": last_name,
            "usageLog": []     # for game session logging
        })

        # Add enumerator to region set
        if enumerator:
            enumerators_by_region[region].add(enumerator)

# ------------------------------------------
# 3. Upload to Firestore
# ------------------------------------------
uidLists = db.collection("uidLists")

print("\n🔥 Uploading to Firestore...\n")

for region in uids_by_region.keys():

    print(f"➡ Updating region: {region}")
    print(f"   UIDs: {len(uids_by_region[region])}")
    print(f"   Enumerators: {list(enumerators_by_region[region])}")

    doc_ref = uidLists.document(region)

    # Upload structure
    doc_ref.set({
        "uids": uids_by_region[region],
        "enumerators": sorted(list(enumerators_by_region[region])),
    })

    print(f"   ✔ Uploaded {region}\n")

print("🎉 ALL REGIONS SUCCESSFULLY UPDATED!")

