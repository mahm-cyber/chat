# New System Rules — Fullstack Chat App Architecture & Conventions

A portable ruleset for building the **Fullstack Chat App** following Clean Architecture, Domain-Driven Design (DDD), and strict layer isolation across Flutter (Android, iOS, macOS), Jaspr Web + Tailwind CSS, and Serverpod backend.

Naming note: We prefix design system widgets with `Chat` (`ChatText`, `ChatIcon`, `ChatTappable`) and shared configuration with `chat_*`.

---

## 1. Foundations

- **Frameworks & Languages:**
  - Dart SDK `>=3.13.0 <4.0.0`
  - Flutter `>=3.47.0` (Mobile & Desktop)
  - Jaspr `>=0.23.0` + Tailwind CSS 3.x/4.x (Web)
  - Serverpod `>=4.0.0` (Backend API & WebSockets)
- **Monorepo:** **Melos 8** on top of **Dart pub workspaces**. There is one root `pubspec.yaml` with a `workspace:` list; member packages declare `resolution: workspace` and share a single lockfile.
- **State Management:** Riverpod (`flutter_riverpod` + `riverpod_annotation`) with code generation (`riverpod_generator`). No `setState` for business logic.
- **Routing:**
  - Flutter: `go_router` centralized in `app_router.dart`.
  - Jaspr: Jaspr Router / Declarative Web routes.
- **Serialization & DB:**
  - Serverpod `.spy.yaml` for database tables & RPC serialization.
  - Hive / Drift for client-side local caching.
  - Pure Dart Value Objects & Entities for the domain.

---

## 2. The Dependency Graph

Dependencies flow **one way only**. Higher layers may depend on lower layers, never the reverse, and never sideways within the same tier:

```
apps/chat_flutter                 apps/chat_web
       │                                 │
       ▼                                 ▼
packages/features/*           packages/web_component_library
       │                                 │
       ▼                                 ▼
packages/repositories/* ◄────────────────┘
       │
       ▼
server/chat_client         packages/key_value_storage
       │                                 │
       ▼                                 ▼
packages/domain_models (Pure Dart — depends on nothing)
```

---

## 3. Package Structure (Applies to Every Package)

- `lib/src/` — All private implementation (notifiers, data sources, internal widgets, mappers).
- `lib/<package_name>.dart` — The single public barrel file. External packages must NEVER import from `lib/src/`.
- Cross-package collaborators arrive via **constructor injection**.
- Every package declares `resolution: workspace` and uses `path:` dependencies for workspace siblings.

---

## 4. Layer Rules

### domain_models
- Pure Dart — **Zero Flutter, Jaspr, or Serverpod imports**.
- Value Objects encapsulate validation (e.g. `MessageContent`, `ConversationId`, `EmailAddress`).
- Immutable entities (`final` fields, `const` constructors).
- Extends `Equatable` (or uses `freezed`) with all fields listed in `props`.
- Contains abstract repository interfaces (`IChatRepository`, `IAuthRepository`, `IUserRepository`).
- Contains domain exceptions (`MessageNotFoundException`, `UnauthorizedParticipantException`).

### server/chat_server & server/chat_client
- Models declared in `.spy.yaml` files.
- Tables follow `snake_case` naming with explicit relational foreign keys.
- Endpoints inherit from `Endpoint` and handle authorization.
- Real-time streams use Serverpod's WebSocket message streams (`session.messages.postMessageStream`).

### key_value_storage
- Local cache models suffix: **`CM`**.
- Typed box getters; never expose raw unchecked database handles.

### repositories
- **Never expose Serverpod models (RM) or cache models (CM) to callers** — map them to pure domain entities immediately.
- Mappers reside in `lib/src/mappers/`:
  - `remote_to_domain.dart`
  - `domain_to_remote.dart`
  - `cache_to_domain.dart`
  - `domain_to_cache.dart`
- Reactive streams are **cache-first**: emit cached local state before awaiting network responses.
- Catch platform/network exceptions and rethrow as **Domain Failures / Exceptions**.

### features (Flutter)
- All UI implementation lives in `lib/src/`. Only the entry screen widget is exported from the barrel file.
- State managed through Riverpod `@riverpod` notifiers.
- **Never call `context.go()` or import `go_router` directly** inside a feature. Receive navigation callbacks via the constructor.
- Stable test IDs live in `lib/src/test_ids.dart` following `<feature>.<element>`.

### Jaspr Web & Tailwind CSS
- Web UI components built with Jaspr Dart components.
- Tailwind CSS utility classes configured via `tailwind.config.js`.
- Shared design tokens matching Flutter's typography and color palettes.

### localization (Server-Driven)
- **Zero hardcoded strings in UI:** No string literals in widgets. All user-facing text is accessed via `context.tr('dot.separated.key')` or `tr('key')`.
- Dynamic translation bundles served by Serverpod backend (`LocalizationEndpoint`) with version tracking.
- Cache-first offline storage in `key_value_storage` with fallback baseline JSON bundle.
- Updates push OTA without app store rebuilds.

---

## 5. UI & Widget Rules (Flutter & Web)

- **Never use raw `Text`** ➔ Use `ChatText` from `component_library`.
- **Never use raw `Icon`** ➔ Use `ChatIcon` from `component_library`.
- **Never use raw `GestureDetector` or `InkWell`** ➔ Use `ChatTappable` with a mandatory `testId`.
- **Never hardcode string literals** ➔ Use `context.tr('key')`. Enforced by `tools/lint_hardcoded_strings.dart`.
- Every clickable must be registered in the semantics tree (`Semantics.identifier`).
- Every UI component is a `StatelessWidget` or `StatefulWidget` class in its own file — **no helper methods returning `Widget`**.
- Extract widgets when a block exceeds ~15 lines, has distinct layout logic, or takes multiple parameters.

---

## 6. DDD Test Case Standard

1. **Unit Tests (Domain):** Invariants and validation logic of Value Objects and Entities tested in isolation.
2. **Use Case Tests:** Test business rules using mocked repository interfaces (`mocktail`).
3. **Repository Tests:** Test cache-first behavior and mappers.
4. **Serverpod Tests:** Test endpoints and database transactions using Serverpod test harness.
5. **Widget Tests:** Test user interaction and assert semantic `testId`s.
