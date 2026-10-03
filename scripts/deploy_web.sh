#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

if [ -f "${WORKSPACE_ROOT}/.env.deploy" ]; then
  # shellcheck source=/dev/null
  source "${WORKSPACE_ROOT}/.env.deploy"
fi

command -v jaspr >/dev/null 2>&1 || { echo "❌ Error: 'jaspr' CLI is required. Run 'dart pub global activate jaspr_cli'."; exit 1; }
command -v firebase >/dev/null 2>&1 || { echo "❌ Error: 'firebase' CLI is required. Run 'npm install -g firebase-tools'."; exit 1; }

echo "============================================================"
echo "🌐 Building & Deploying Jaspr Web Client to Firebase Hosting"
echo "============================================================"

# Step 1: Compile Jaspr Web Application
echo "📦 Compiling Jaspr Web application with Tailwind CSS..."
cd "${WORKSPACE_ROOT}/apps/chat_web"
jaspr clean || true
jaspr build --verbose

# Step 2: Deploy to Firebase Hosting
cd "${WORKSPACE_ROOT}"

if [ -n "${FIREBASE_PROJECT_ID:-}" ]; then
  echo "🚀 Deploying to Firebase project '${FIREBASE_PROJECT_ID}'..."
  firebase deploy --only hosting --project "${FIREBASE_PROJECT_ID}"
else
  echo "🚀 Deploying to default configured Firebase project..."
  firebase deploy --only hosting
fi

echo "============================================================"
echo "🎉 Jaspr Web client deployed successfully to Firebase Hosting!"
echo "============================================================"
