#!/bin/bash
# Build and deploy the PRODUCTION (main) version to ofinsen-dc06d
set -e  # stop on any error

echo "🔨  Building production flavor (ofinsen-dc06d)..."
flutter build web --release
# No --dart-define=FLAVOR needed; defaultValue='production' → ofinsen-dc06d

echo ""
echo "🚀  Deploying to ofinsen-dc06d (main)..."
firebase deploy --only hosting --project ofinsen-dc06d

echo ""
echo "✅  Done. Live at https://ofinsen-dc06d.web.app"
echo ""
echo "⚠️  NOTE: If you previously ran deploy_tester.sh, the build/web directory"
echo "   was overwritten with tester code. This script rebuilt it as production"
echo "   before deploying. Always run a deploy script from scratch — never deploy"
echo "   without rebuilding first."