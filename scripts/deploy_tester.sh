#!/bin/bash
# Build and deploy the TESTER version to ofinsen-dc06d
echo "Building tester flavor..."
flutter build web --release --dart-define=FLAVOR=tester
echo "Deploying to ofinsen-dc06d..."
firebase deploy --only hosting --project ofinsen-dc06d
echo "Done. Live at https://ofinsen-dc06d.web.app"
