# Fullstack Chat App — Architecture & System Rules Handbook

Welcome to the **Fullstack Chat App** engineering guidelines. This document is the single source of truth for architecture, domain modeling, coding standards, and workflows across the entire codebase.

Adapted and evolved from the battle-tested **Polaris Max** enterprise architecture, this handbook defines our strict standards for:
- **Backend:** Serverpod (Latest, Fullstack Dart + PostgreSQL + Real-Time WebSockets)
- **Mobile & Desktop (Android, iOS, macOS):** Flutter (Latest, Riverpod, Clean Architecture)
- **Web:** Jaspr (Latest, Dart SSR/Client components) + Tailwind CSS
- **Methodology:** Domain-Driven Design (DDD), Clean Architecture, and Test-Driven Development (TDD/DDD Test Cases)
- **Monorepo Management:** Melos + Dart Pub Workspaces

---

## 1. Core Architecture: Clean Architecture & DDD

Our system strictly enforces **Clean Architecture** paired with **Domain-Driven Design (DDD)**. The domain layer sits at the absolute center, completely isolated from frameworks, databases, network libraries, and UI toolkits.

```
       ┌────────────────────────────────────────────────────────┐
       │                   Presentation Layer                   │
       │  Flutter (Android, iOS, macOS)  │  Jaspr + Tailwind    │
       └───────────────────────────┬────────────────────────────┘
                                   │ (calls Use Cases / Providers)
                                   ▼
       ┌────────────────────────────────────────────────────────┐
       │                   Application Layer                    │
       │       Use Cases / Interactors / Application Services   │
       └───────────────────────────┬────────────────────────────┘
                                   │ (operates on Domain Entities)
                                   ▼
       ┌────────────────────────────────────────────────────────┐
       │                      Domain Layer                      │
       │  Entities, Value Objects, Aggregates, Domain Events,   │
       │  Domain Exceptions, Repository Interfaces (Pure Dart)  │
       └───────────────────────────▲────────────────────────────┘
                                   │ (implements interfaces)
       ┌───────────────────────────┴────────────────────────────┐
       │                  Infrastructure Layer                  │
       │  Serverpod Client, Local Cache (Hive), Mappers,        │
       │  WebSocket Listeners, Repository Implementations       │
       └────────────────────────────────────────────────────────┘
```

### The Core Commandments (Adapted from Polaris Max)

1. **The Dependency Graph is Strictly One-Way:**
   - Higher layers depend on lower layers; never the reverse.
   - Sideways dependencies within the same layer are strictly prohibited.
   - Domain depends on **nothing** (no Flutter, no Jaspr, no Serverpod, no third-party I/O).
2. **Every Feature Gets Its Own Isolated Package:**
   - Each screen or cohesive flow lives in `packages/features/<feature_name>`.
   - **Features must never know each other:** zero cross-feature imports.
   - All cross-feature navigation and actions are injected as **constructor callbacks** wired in the application router (`app_router.dart`).
3. **Every Repository Gets Its Own Dedicated Package:**
   - One bounded domain per package (`user_repository`, `chat_repository`, `presence_repository`). Never dump repositories into a single bulk package.
   - Repositories return **Domain Entities** only. Remote Models (`RM` / Serverpod generated classes) and Cache Models (`CM`) never leak beyond the repository implementation.
4. **No "Common" or "Utils" Dumping Ground:**
   - Create specialized, bounded packages: `domain_models`, `core_foundation`, `component_library`, `monitoring`.
5. **DDD Test-First Verification:**
   - Every domain entity, value object, use case, and repository must have dedicated unit tests before features are built on top of them.

---

## 2. Monorepo Structure & Dart Pub Workspaces

The repository is organized as a unified Melos monorepo powered by Dart Pub Workspaces:

```
chat/
├── server/                             # Serverpod Backend
│   ├── chat_server/                    # Serverpod Server application (endpoints, migrations, DB)
│   ├── chat_client/                    # Generated client SDK (shared with apps & repos)
│   └── chat_shared/                    # Shared code between server & client (if needed)
├── apps/                               # Client Entry Points
│   ├── chat_flutter/                   # Flutter App (Android, iOS, macOS)
│   │   ├── lib/main.dart               # DI initialization, ProviderScope, Theme
│   │   ├── lib/app_router.dart         # Centralized GoRouter & navigation wiring
│   │   └── assets/config/              # Environment flavor configurations
│   └── chat_web/                       # Jaspr Web App
│       ├── lib/main.dart               # Jaspr web entrypoint (SSR / Client)
│       ├── web/styles.css              # Tailwind CSS output
│       └── tailwind.config.js          # Tailwind design tokens & configuration
├── packages/
│   ├── domain_models/                  # Pure Dart DDD: Entities, Value Objects, Events, Interfaces
│   ├── core_foundation/                # Result types (Either), Failure models, Network utilities
│   ├── repositories/
│   │   ├── auth_repository/            # Auth repository (Serverpod auth + token storage)
│   │   ├── chat_repository/            # Chat & messaging repository (cache-first + WebSockets)
│   │   ├── user_repository/            # User profiles & contacts
│   │   └── presence_repository/        # Online status & typing indicators
│   ├── key_value_storage/              # Local storage cache (Hive / cross-platform)
│   ├── component_library/              # Flutter Design System (ChatText, ChatIcon, ChatTappable, Tokens)
│   ├── web_component_library/          # Jaspr + Tailwind UI Components
│   └── features/                       # Independent Flutter Feature Packages
│       ├── auth/                       # Login, Signup, OTP
│       ├── conversation_list/          # Chat room list, unread badges, search
│       ├── chat_room/                  # Active messaging, attachments, voice notes
│       ├── user_profile/               # Profile management, status, settings
│       └── call/                       # WebRTC / audio-video calls (future phase)
├── tools/                              # Custom AST Lint Scanners & Melos utilities
├── melos.yaml                          # Melos monorepo configuration
├── pubspec.yaml                        # Root workspace pubspec
├── RULES.md                            # This authoritative handbook
└── CLAUDE.md                           # AI assistant quick-reference
```

---

## 3. Domain-Driven Design (DDD) Specifications

### Ubiquitous Language (Chat Domain)

| Term | Concept | Rules & Invariants |
|---|---|---|
| **User** | A registered identity within the chat system | Has a unique `UserId`, display name, avatar URL, and verified phone/email. |
| **Conversation** | A direct or group chat container (Aggregate Root) | Contains 2+ participants, unique `ConversationId`, creation timestamp, and optional group metadata. |
| **Message** | A single communication item within a conversation | Has `MessageId`, sender `UserId`, `ConversationId`, `MessageContent`, `MessageStatus`, timestamps. Cannot be empty. |
| **MessageContent** | Value object for message payload | Supports `TextContent`, `MediaContent` (image, video, document), `AudioContent`, or `SystemNotice`. |
| **MessageStatus** | Lifecycle state of a message | `sending` ➔ `sent` ➔ `delivered` ➔ `read` (or `failed`). |
| **Participant** | A user inside a conversation | Holds user role (`owner`, `admin`, `member`) and join timestamp. |
| **Presence** | Ephemeral user availability | `online`, `offline`, `away`, with `lastSeen` timestamp and `isTyping` status. |
| **Receipt** | Delivery or read confirmation | Pairs `MessageId`, recipient `UserId`, and timestamp. |

### Domain Layer Rules (`packages/domain_models`)

- **Pure Dart Only:** Must NEVER import `package:flutter`, `package:jaspr`, or `package:serverpod`.
- **Value Objects:**
  - Encapsulate validation and invariants (e.g. `Email`, `MessageText`, `ConversationTitle`).
  - Immutable (`final` fields, `const` constructors).
  - Equality based on value (`Equatable` or `freezed`).
  - Throw typed domain exceptions or return `Result<ValueObject, DomainFailure>` on invalid inputs.
- **Entities & Aggregate Roots:**
  - `Conversation` is the Aggregate Root controlling access to its `Message` and `Participant` collections.
  - Entities have unique identities (`UserId`, `ConversationId`, `MessageId`).
  - Invariants are enforced inside entity methods (e.g., `conversation.addParticipant()`, `message.markDelivered()`).
- **Domain Events:**
  - Immutable records describing events that have already occurred: `MessageSentEvent`, `MessageDeliveredEvent`, `UserStartedTypingEvent`.
- **Repository Interfaces:**
  - Abstract contracts defined strictly in terms of domain models:
    ```dart
    abstract class IChatRepository {
      Stream<List<Message>> watchMessages(ConversationId conversationId);
      Future<Result<Message, DomainFailure>> sendMessage(SendMessageParams params);
      Future<Result<void, DomainFailure>> markAsRead(MessageId messageId);
    }
    ```

---

## 4. Backend Rules: Serverpod (Latest)

The backend runs on **Serverpod**, leveraging Dart's async runtime, typed database ORM with PostgreSQL, and native WebSocket streaming.

### Database & ORM (`server/chat_server/lib/src/models/`)
- All models are defined in `.spy.yaml` files.
- Table names must use `snake_case`.
- Use relational fields with proper foreign keys (`relation(onDelete: Cascade)` where appropriate).
- Always generate migrations using `serverpod create-migration` and test rollbacks.

### Endpoints & Streaming (`server/chat_server/lib/src/endpoints/`)
- **RPC Endpoints:** Inherit from `Endpoint`. Handle request-response operations (e.g., authentication, profile update, conversation creation).
- **Streaming WebSockets:** Use Serverpod's message streaming capabilities (`session.messages.postMessageStream`) to broadcast:
  - New chat messages (`chat_room:<id>` channel)
  - Delivery and read receipts
  - Typing indicators and presence status
- **Authentication & Security:**
  - Enforce authentication via Serverpod authentication tokens on all private endpoints.
  - Always verify that the authenticated user is an active participant of the conversation before allowing read/write operations.

---

## 5. Mobile & Desktop Rules: Flutter (Android, iOS, macOS)

### UI Rules & Design System Enforcement (Adapted from Polaris Max)

1. **NO RAW `Text` WIDGETS:**
   - ❌ Never use `Text('Hello')` directly in feature screens.
   - ✅ Always use `ChatText` from `component_library` (or designated typography components).
   - Enforced by automated AST lint script `tools/lint_text_usage.dart`.
2. **NO RAW `Icon` WIDGETS:**
   - ❌ Never use `Icon(Icons.send)`.
   - ✅ Always use `ChatIcon` from `component_library` to guarantee semantic theming and sizing.
   - Enforced by `tools/lint_icon_usage.dart`.
3. **NO RAW `GestureDetector` / `InkWell`:**
   - ❌ Never use raw clickable widgets without semantic identifiers.
   - ✅ Always use `ChatTappable` with a required `testId` following `<feature>.<element>` (e.g. `chat_room.send_button`).
   - Populates `Semantics.identifier` for automated E2E testing and accessibility.
   - Enforced by `tools/lint_tappable_usage.dart`.
4. **Design Tokens Only:**
   - No raw color values (e.g. `Color(0xFF123456)`), no raw spacing doubles (`padding: EdgeInsets.all(14)`), no raw font sizes.
   - Use design tokens: `Spacing.small`, `Spacing.medium`, `Spacing.large`; `AppColors.*` or `Theme.of(context)`.
5. **Screen Architecture:**
   - Features use `BaseScreen` or `BaseScaffold` with consistent error boundary and safe-area handling.
   - State managed via **Riverpod** (`@riverpod` generators). Features do not use `setState` for domain state.
   - Cross-feature navigation is passed into the screen constructor as callbacks:
     ```dart
     class ConversationListScreen extends ConsumerWidget {
       final void Function(ConversationId id) onSelectConversation;
       final VoidCallback onOpenSettings;
       // ...
     }
     ```

---

## 6. Web Rules: Jaspr + Tailwind CSS

### Architecture & Component Structure
- **Jaspr** acts as the modern, high-performance Dart web client.
- **Tailwind CSS** handles the presentation layer with utility-first styling.
- Jaspr components in `packages/web_component_library/` mirror the design tokens of the Flutter app.
- Shared domain logic: Jaspr web app imports `domain_models`, `chat_client`, and repository implementations directly.

### Guidelines
1. **Utility-First with Tailwind:**
   - Use standard Tailwind utility classes in Jaspr `classes: '...'` attributes.
   - Define custom brand colors, spacing, and font sizes in `tailwind.config.js` to match Flutter's design tokens exactly.
2. **Real-Time WebSockets on Web:**
   - Use the shared Serverpod client configured with browser WebSocket support for instant real-time message streaming.
3. **Responsive Web Layout:**
   - Desktop and tablet web view: Split-pane layout (conversations sidebar on the left, active chat room on the right).
   - Mobile web view: Responsive single-pane navigation matching the mobile user experience.

---

## 7. Repositories & Data Flow

- **Cache-First Architecture:**
  - Query results return cached data immediately, then fetch/stream from the Serverpod backend.
  - Offline message queue: Outgoing messages are stored locally in `pending` state and automatically synchronized upon reconnection.
- **Strict Data Model Separation:**
  - `Serverpod Model (RM)` ➔ Remote request/response.
  - `Cache Model (CM)` ➔ Hive / local storage structure.
  - `Domain Model (Entity)` ➔ Pure business entity.
  - **Mappers** live in `lib/src/mappers/`:
    - `remote_to_domain.dart`
    - `domain_to_remote.dart`
    - `cache_to_domain.dart`
    - `domain_to_cache.dart`
  - Repositories **never expose `RM` or `CM`** outside their package.

---

## 8. Testing & DDD Test Case Workflow

We practice a strict **Test-First DDD Workflow**. For every capability:

```
┌────────────────────────┐
│ 1. Ubiquitous Language │ ➔ Define Entities, Value Objects, and Invariants
└───────────┬────────────┘
            ▼
┌────────────────────────┐
│ 2. Domain Unit Tests   │ ➔ Validate Value Objects & Entity Business Logic
└───────────┬────────────┘
            ▼
┌────────────────────────┐
│ 3. Use Case Tests      │ ➔ Validate Application Orchestration with Mocks
└───────────┬────────────┘
            ▼
┌────────────────────────┐
│ 4. Repo & Mapper Tests │ ➔ Validate Mappings, Cache-First & Error Handling
└───────────┬────────────┘
            ▼
┌────────────────────────┐
│ 5. Serverpod Endpoints │ ➔ Integration tests with Serverpod Test Harness
└───────────┬────────────┘
            ▼
┌────────────────────────┐
│ 6. UI Component Tests  │ ➔ Flutter Widget Tests & Jaspr Component Tests
└────────────────────────┘
```

### Testing Standards:
- **Domain Unit Tests:** `test/domain/` — 100% test coverage required for invariants (e.g. invalid message length, unauthorized participant operations).
- **Use Case Tests:** Test business flows with `mocktail` for repository mocks.
- **Repository Integration Tests:** Test offline caching, error transformations (translating network/database errors into strongly-typed `DomainFailure`).
- **Serverpod Endpoint Tests:** Run with Serverpod's official test harness (`withServerpod(...)`).
- **Flutter Widget Tests:** Must assert semantic test IDs (`find.bySemanticsIdentifier(...)`).

---

## 9. Melos Tooling & Automated Quality Gates

Every developer and CI runner must pass these checks:

```bash
# Monorepo Management
melos bootstrap            # Link all workspace packages
melos run get              # Run pub get across all packages
melos run build            # Run build_runner code generation
melos run build:watch      # Watch mode for code generation

# Quality Assurance
melos run analyze          # dart analyze across all packages
melos run test             # Run all unit and widget tests
melos run fix              # Automatically apply dart fix

# Design System & Semantic Lint Scanners (Tools)
melos run lint:text        # Detect forbidden raw Text widgets
melos run lint:icon        # Detect forbidden raw Icon widgets
melos run lint:tappable    # Detect clickables without semantic testIds

# Serverpod Commands
melos run server:generate  # serverpod generate
melos run server:migrate   # serverpod create-migration
melos run server:run       # Start local Serverpod backend with Docker Postgres

# Jaspr Web Commands
melos run web:build        # Build Jaspr client and Tailwind CSS bundle
melos run web:serve        # Start Jaspr local dev server
```

---

## 10. Summary "Do / Don't" Guide

| Area | DO ✅ | DON'T ❌ |
|---|---|---|
| **Architecture** | Pure Dart `domain_models` with zero framework dependencies | Import Flutter, Jaspr, or Serverpod into Domain |
| **Features** | Isolate each screen into `packages/features/<name>` | Import one feature from another feature |
| **Navigation** | Inject navigation callbacks from `app_router.dart` | Call `context.go()` or import GoRouter in features |
| **Data Models** | Transform RM and CM into Domain Entities via mappers | Expose Serverpod generated classes or Hive models to UI |
| **Flutter UI** | Use `ChatText`, `ChatIcon`, `ChatTappable` | Use raw `Text`, `Icon`, `GestureDetector`, `InkWell` |
| **Jaspr UI** | Use Tailwind classes aligned with app design tokens | Use arbitrary ad-hoc inline styles or hardcoded colors |
| **Testing** | Write DDD unit tests for Entities and Use Cases first | Build UI before domain validation and use cases exist |
| **Real-Time** | Use Serverpod streaming channels with typed events | Poll HTTP endpoints for new messages |
| **State** | Use Riverpod Notifiers with immutable state | Use raw `setState` for app business logic |
