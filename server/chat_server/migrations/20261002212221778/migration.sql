BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_translation" (
    "id" bigserial PRIMARY KEY,
    "locale" text NOT NULL,
    "key" text NOT NULL,
    "value" text NOT NULL,
    "version" bigint NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "app_translation_locale_key_idx" ON "app_translation" USING btree ("locale", "key");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_user" (
    "id" bigserial PRIMARY KEY,
    "firebaseUid" text NOT NULL,
    "phoneNumber" text NOT NULL,
    "displayName" text NOT NULL,
    "bio" text,
    "photoUrl" text,
    "notificationsEnabled" boolean NOT NULL,
    "lastSeenAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "app_user_phone_idx" ON "app_user" USING btree ("phoneNumber");
CREATE UNIQUE INDEX "app_user_uid_idx" ON "app_user" USING btree ("firebaseUid");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "conversation" (
    "id" bigserial PRIMARY KEY,
    "user1Id" bigint NOT NULL,
    "user2Id" bigint NOT NULL,
    "lastMessageText" text,
    "lastMessageSentAt" timestamp without time zone,
    "unreadCountUser1" bigint NOT NULL,
    "unreadCountUser2" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "conversation_users_idx" ON "conversation" USING btree ("user1Id", "user2Id");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "message" (
    "id" bigserial PRIMARY KEY,
    "conversationId" bigint NOT NULL,
    "senderId" bigint NOT NULL,
    "recipientId" bigint NOT NULL,
    "content" text NOT NULL,
    "attachmentUrls" json,
    "status" text NOT NULL,
    "sentAt" timestamp without time zone NOT NULL,
    "deliveredAt" timestamp without time zone,
    "readAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "message_conversation_idx" ON "message" USING btree ("conversationId");
CREATE INDEX "message_recipient_idx" ON "message" USING btree ("recipientId", "status");


--
-- MIGRATION VERSION FOR chat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('chat', '20261002212221778', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261002212221778', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
