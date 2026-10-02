# Fullstack Monorepo Architecture: Flutter, Jaspr, Tailwind & Serverpod

This document details the multi-target, unified Dart monorepo setup bridging the Serverpod backend, Flutter mobile/desktop app, and Jaspr Web app.

---

## 1. Multi-Client Fullstack Dart Architecture

```
                          ┌────────────────────────┐
                          │   Serverpod Backend    │
                          │      (PostgreSQL)      │
                          │   WebSockets / RPC     │
                          └───────────┬────────────┘
                                      │
                         ┌────────────┴────────────┐
                         │    server/chat_client   │
                         │ (Auto-generated Dart SDK│
                         └──────┬────────────┬─────┘
                                │            │
                ┌───────────────┘            └───────────────┐
                ▼                                            ▼
   ┌─────────────────────────┐                  ┌─────────────────────────┐
   │    apps/chat_flutter    │                  │      apps/chat_web      │
   │  (Android, iOS, macOS)  │                  │      (Jaspr + Web)      │
   │      Flutter 3.x        │                  │      Tailwind CSS       │
   │      Riverpod 2.x       │                  │     Jaspr Components    │
   │    Component Library    │                  │  Web Component Library  │
   └─────────────────────────┘                  └─────────────────────────┘
                ▲                                            ▲
                │         ┌────────────────────────┐         │
                └─────────┤ packages/domain_models ├─────────┘
                          │ (Pure Dart, Zero Deps) │
                          └────────────────────────┘
```

---

## 2. Serverpod Integration

### Streaming WebSockets
Serverpod provides native WebSocket streaming via its message bus.
- **Channels:**
  - `conversation:<id>`: Broadcasts messages, edits, deletions, and reactions.
  - `presence:<user_id>`: Broadcasts online status and typing status.
- **Client SDK (`server/chat_client`):**
  - Generated automatically by Serverpod (`serverpod generate`).
  - Both Flutter and Jaspr import `chat_client` directly to invoke strongly-typed endpoints and open streaming connections.

---

## 3. Jaspr Web + Tailwind CSS Integration

Jaspr is modern fullstack Dart for the web. It renders HTML components on both server and client with zero Flutter canvas overhead, delivering near-instant page load speeds and SEO friendliness.

### Tailwind CSS Setup in `apps/chat_web`:
- `tailwind.config.js` defines our design tokens (colors, spacing, typography) matching Flutter's `component_library`.
- Tailwind CLI compiles `web/styles.css` during the build step.
- Jaspr components use standard Tailwind utility classes:
  ```dart
  div(classes: 'flex h-screen bg-slate-50 dark:bg-slate-900', [
    SidebarComponent(),
    ChatAreaComponent(),
  ]);
  ```

---

## 4. Flutter Integration (Android, iOS, macOS)

- Single codebase targeting mobile (Android & iOS) and desktop (macOS).
- Riverpod state management (`@riverpod` notifiers).
- Strict design system using `ChatText`, `ChatIcon`, and `ChatTappable`.
- Navigation handled by `GoRouter` with typed constructor callbacks.
