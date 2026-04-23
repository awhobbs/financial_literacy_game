#!/bin/bash
# Build and deploy SITE 2 (finlitsim) — second country production build
set -e  # stop on any error

echo "🔨  Building Site 2 (finlitsim)..."
flutter build web --release --dart-define=FLAVOR=site2

echo ""
echo "🚀  Deploying to finlitsim (Site 2)..."
firebase deploy --only hosting --project finlitsim

echo ""
echo "✅  Done. Live at https://finlitsim.web.app"
echo ""
echo "⚠️  NOTE: build/web now contains Site 2 code."
echo "   Run scripts/deploy_main.sh to rebuild and deploy Site 1."
