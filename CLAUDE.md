# CLAUDE.md

This file provides guidance to Claude Code and AI assistants when working with code in this repository.

## Repository Overview

This repository is a fullstack, multi-platform chat application monorepo managed with **Melos** and **Dart Pub Workspaces**. It adheres strictly to **Clean Architecture** and **Domain-Driven Design (DDD)**.

### Target Platforms & Technology Stack:
- **Backend:** Serverpod (Latest, Fullstack Dart + PostgreSQL + Real-Time WebSockets)
- **Mobile & Desktop (Android, iOS, macOS):** Flutter (Latest, Riverpod, GoRouter)
- **Web:** Jaspr (Latest, Dart SSR/Client web framework) + Tailwind CSS
- **Local Storage:** Hive / cross-platform key-value cache
- **Monorepo Tooling:** Melos 8.x + Dart 3.x workspaces

---

## Architecture: Packaging by Layer & Convenience

Dependencies flow **strictly one-way** downward. Higher layers may depend on lower layers, NEVER the reverse, and NEVER sideways within the same tier:

```
apps/chat_flutter (Android, iOS, macOS)      apps/chat_web (Jaspr Web + Tailwind)
                  │                                         │
                  ▼                                         ▼
         packages/features/*                     packages/web_component_library
                  │                                         │
                  ▼                                         ▼
         packages/repositories/* ◄──────────────────────────┘
                  │
                  ▼
   server/chat_client    packages/key_value_storage
                  │                  │
                  ▼                  ▼
              packages/domain_models (Pure Dart — ZERO external dependencies)
```

### The Inviolable Commandments:
1. **Isolated Features:** Every feature lives in its own package under `packages/features/<name>`. Features must NEVER import one another.
2. **Navigation Callbacks:** Features do not invoke `context.go()` or import GoRouter directly; all navigation is passed as constructor callbacks from `app_router.dart`.
3. **Domain Isolation:** `packages/domain_models` is pure Dart. No Flutter, Jaspr, or Serverpod dependencies are allowed here.
4. **Data Encapsulation:** Repositories NEVER expose remote models (RM) or cache models (CM) to upper layers. All data is mapped to domain entities in `lib/src/mappers/`.
5. **UI Widget Guards:**
   - ❌ No raw `Text(...)` ➔ Use `ChatText(...)`
   - ❌ No raw `Icon(...)` ➔ Use `ChatIcon(...)`
   - ❌ No raw `GestureDetector` / `InkWell` ➔ Use `ChatTappable(testId: '...', ...)`

---

## Core Commands

All Melos commands run from the monorepo root:

```bash
# Workspace setup & dependency resolution
melos bootstrap            # or: melos bs
melos run get              # Run pub get across all packages

# Code generation (Riverpod, Freezed, Serverpod)
melos run build            # dart run build_runner build --delete-conflicting-outputs
melos run build:watch      # Watch mode for rapid development
melos run server:generate  # Generate Serverpod client & models

# Quality assurance & verification
melos run analyze          # dart analyze across all packages
melos run test             # Run all unit, widget, and integration tests
melos run fix              # Run dart fix --apply

# Custom design-system AST lint scanners
melos run lint:text        # Scan for forbidden raw Text widgets
melos run lint:icon        # Scan for forbidden raw Icon widgets
melos run lint:tappable    # Scan for clickables missing semantic testIds

# Platform Launchers
# Flutter (Mobile/macOS)
cd apps/chat_flutter && flutter run -d macos
cd apps/chat_flutter && flutter run -d chrome

# Serverpod Backend
cd server/chat_server && dart bin/main.dart --mode development

# Jaspr Web + Tailwind
cd apps/chat_web && jaspr serve
```

---

## DDD & Testing Workflow

When implementing any feature, follow this test-first order:
1. **Domain Definition:** Define Value Objects and Entities in `packages/domain_models`.
2. **Domain Unit Tests:** Write tests in `packages/domain_models/test/` asserting domain invariants and validation logic.
3. **Application Use Cases:** Write use cases in `packages/domain_models/lib/src/use_cases/` and test with repository mocks (`mocktail`).
4. **Repository Implementation:** Implement in `packages/repositories/<name>_repository/` with cache-first streams and mappers. Write unit/integration tests for mappers and caching.
5. **Serverpod Endpoint & Migrations:** Implement Serverpod endpoint and write integration tests using Serverpod's test harness.
6. **UI Presentation:**
   - For Flutter: implement feature in `packages/features/<name>` using `ChatText`, `ChatIcon`, `ChatTappable` with semantic test IDs.
   - For Web: implement Jaspr components in `apps/chat_web` or `packages/web_component_library` using Tailwind CSS classes.
