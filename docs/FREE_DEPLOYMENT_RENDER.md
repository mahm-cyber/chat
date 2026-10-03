# 100% Free Server Deployment via Render.com

This guide explains how to deploy the Serverpod backend and PostgreSQL database on **Render.com** at **$0.00 / month** with zero credit card required.

---

## Architecture on Render

```
GitHub (mahm-cyber/chat)
  │
  ├──► render.yaml (Blueprint)
        │
        ├──► Web Service (Free Tier)
        │     └── Serverpod Docker Container (`server/chat_server/Dockerfile`)
        │     └── Auto-applies database migrations on startup (`SERVERPOD_APPLY_MIGRATIONS=true`)
        │
        └──► PostgreSQL Database (Free Tier)
              └── Internal secure private network connection
```

---

## 3-Minute Deployment Instructions

### 1. Create a Free Render Account
1. Open [https://render.com](https://render.com).
2. Click **Sign Up** and choose **GitHub** (sign in with your GitHub account: `mahm-cyber`).

---

### 2. Deploy with Blueprint (1-Click)
1. In your Render Dashboard, click the **New +** button in the top right.
2. Select **Blueprint**.
3. Choose your repository: **`mahm-cyber/chat`** (click "Connect").
4. Render will automatically read [`render.yaml`](../render.yaml) and display:
   - **`chat-server`** (Web Service, Free Docker)
   - **`chat-db`** (PostgreSQL Database, Free Tier)
5. Click **Apply**.

---

### 3. That's It!
Render will now:
1. Provision the free PostgreSQL database.
2. Build the Serverpod Docker container from your GitHub repository.
3. Automatically execute all database migrations.
4. Give you a public HTTPS URL (e.g. `https://chat-server-xxxx.onrender.com`).

---

## Connecting the Clients

Once your Render web service is live, update your client apps with your Render URL:
- **Mobile app (`apps/chat_flutter`)**: Pass `--dart-define=SERVER_URL=https://chat-server-xxxx.onrender.com/`
- **Web app (`apps/chat_web`)**: Connect to your Render backend endpoint.
