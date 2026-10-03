# Fullstack Chat App — Production Deployment Guide

This guide walks through configuring, deploying, and maintaining the Fullstack Chat Application across **Google Cloud Platform (Cloud Run & Cloud SQL)**, **Firebase Hosting**, and **GitHub Actions CI/CD**.

---

## Architecture Overview

```
                               ┌────────────────────────────────┐
                               │       Users & Clients          │
                               └───────┬────────────────┬───────┘
                                       │                │
                        Web Traffic (HTTPS)      App Traffic (WSS / HTTPS)
                                       │                │
                                       ▼                ▼
                 ┌─────────────────────────────┐  ┌───────────────────────────────────┐
                 │       Firebase Hosting      │  │        Google Cloud Run           │
                 │   (Jaspr Web + Tailwind)    │  │   (Serverpod 4.x Backend)         │
                 │  - Global Anycast CDN       │  │  - WebSockets Enabled             │
                 │  - Automatic SSL & Caching  │  │  - Session Affinity               │
                 │  - SPA Routing Rewrites     │  │  - Min 1 Instance (Zero Cold-Start)│
                 └─────────────────────────────┘  └─────────────────┬─────────────────┘
                                                                    │
                                                     Unix Domain Socket (/cloudsql/...)
                                                                    ▼
                                                  ┌───────────────────────────────────┐
                                                  │       Google Cloud SQL            │
                                                  │    (PostgreSQL 16 Engine)         │
                                                  │  - app_user, conversation,        │
                                                  │    message, app_translation       │
                                                  └───────────────────────────────────┘
```

---

## 1. Google Cloud Platform Setup

### Step 1.1: Enable Required GCP APIs
In your Google Cloud Console or using `gcloud` CLI:

```bash
gcloud services enable \
  run.googleapis.com \
  sqladmin.googleapis.com \
  artifactregistry.googleapis.com \
  secretmanager.googleapis.com
```

### Step 1.2: Create Artifact Registry Repository
```bash
gcloud artifacts repositories create chat-app \
  --repository-format=docker \
  --location=us-central1 \
  --description="Docker repository for Chat App services"
```

### Step 1.3: Provision Cloud SQL for PostgreSQL
```bash
# Create Cloud SQL Instance
gcloud sql instances create chat-postgres \
  --database-version=POSTGRES_16 \
  --tier=db-custom-1-3840 \
  --region=us-central1 \
  --root-password="YOUR_SECURE_ROOT_PASSWORD"

# Create Application Database
gcloud sql databases create chat_app --instance=chat-postgres

# Create Application User
gcloud sql users create chat_user \
  --instance=chat-postgres \
  --password="YOUR_SECURE_USER_PASSWORD"
```

To find your Cloud SQL Instance Connection Name:
```bash
gcloud sql instances describe chat-postgres --format="value(connectionName)"
# Output format: PROJECT_ID:REGION:chat-postgres
```

### Step 1.4: Create CI/CD Service Account
```bash
# Create Service Account
gcloud iam service-accounts create github-deployer \
  --display-name="GitHub Actions Deployer"

# Assign Roles
export PROJECT_ID=$(gcloud config get-value project)
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:github-deployer@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:github-deployer@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.writer"

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:github-deployer@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/cloudsql.client"

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:github-deployer@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

# Generate Key for GitHub Secrets
gcloud iam service-accounts keys create sa-key.json \
  --iam-account="github-deployer@${PROJECT_ID}.iam.gserviceaccount.com"
```

---

## 2. Firebase Hosting Setup (Jaspr Web)

### Step 2.1: Initialize Firebase Project
```bash
npm install -g firebase-tools
firebase login
firebase use --add YOUR_FIREBASE_PROJECT_ID
```

The workspace is pre-configured with [`firebase.json`](file:///Volumes/Macintosh%20HD%201/chat/firebase.json) to deploy `apps/chat_web/build/jaspr` with SPA client rewrites and cache headers.

---

## 3. Local Deployment via CLI Scripts

For fast manual or staging deployments directly from your terminal:

```bash
# 1. Copy the configuration template
cp scripts/env.deploy.example .env.deploy

# 2. Edit .env.deploy with your project ID and database details
nano .env.deploy

# 3. Deploy Serverpod Backend (Image build -> Cloud Run Job Migration -> Cloud Run Service rollout)
./scripts/deploy_backend.sh

# 4. Deploy Jaspr Web Frontend
./scripts/deploy_web.sh
```

---

## 4. Automated CI/CD with GitHub Actions

The pipeline in [`.github/workflows/deploy.yml`](file:///Volumes/Macintosh%20HD%201/chat/.github/workflows/deploy.yml) automatically triggers on pushes to `main` and release tags (`v*`).

### Required GitHub Repository Secrets

Navigate to **Settings > Secrets and variables > Actions > New repository secret**:

| Secret Name | Description / Example |
| :--- | :--- |
| `GCP_PROJECT_ID` | Your Google Cloud project ID (e.g. `my-chat-app-prod`) |
| `GCP_REGION` | Compute region (e.g. `us-central1`) |
| `GCP_SA_KEY` | Entire content of `sa-key.json` generated in Step 1.4 |
| `CLOUD_SQL_INSTANCE` | Instance connection name (`PROJECT_ID:REGION:INSTANCE`) |
| `FIREBASE_PROJECT_ID` | Your Firebase project ID |
| `FIREBASE_SERVICE_ACCOUNT` | Firebase service account credentials JSON |

### Workflow Jobs:
1. **Verification**: Executes Melos bootstrap, all 4 AST linters (`lint_text_usage`, `lint_icon_usage`, `lint_tappable_usage`, `lint_hardcoded_strings`), and all 66+ test suites.
2. **Backend Deploy**: Builds production Docker container, triggers Cloud Run Migration Job (`--apply-migrations`), and rolls out Cloud Run service with WebSocket affinity.
3. **Web Deploy**: Compiles Jaspr Web with Tailwind CSS and deploys to Firebase Hosting.
4. **Mobile Release Builds**: Produces Android App Bundle (`.aab`) and unsigned iOS archive (`.xcarchive`) as downloadable GitHub build artifacts.
