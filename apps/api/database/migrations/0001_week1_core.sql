-- Week1 core schema migration
-- Source of truth: docs/couple-planet/week1-ddl.sql

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account VARCHAR(128) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    nickname VARCHAR(20) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_users_account UNIQUE (account)
);

CREATE TABLE IF NOT EXISTS relations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_a_id UUID NOT NULL REFERENCES users (id),
    user_b_id UUID NOT NULL REFERENCES users (id),
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    invite_code VARCHAR(32),
    invite_code_expires_at TIMESTAMPTZ,
    bound_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT ck_relations_not_self CHECK (user_a_id <> user_b_id),
    CONSTRAINT ck_relations_status CHECK (status IN ('active', 'pending', 'cancelled'))
);

CREATE TABLE IF NOT EXISTS messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    relation_id UUID NOT NULL REFERENCES relations (id),
    sender_id UUID NOT NULL REFERENCES users (id),
    client_msg_id VARCHAR(64) NOT NULL,
    content TEXT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'sent',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    read_at TIMESTAMPTZ NULL,
    CONSTRAINT ck_messages_status CHECK (status IN ('sent', 'failed')),
    CONSTRAINT ck_messages_content_not_empty CHECK (LENGTH(TRIM(content)) > 0)
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_relations_invite_code
    ON relations (invite_code)
    WHERE invite_code IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_relations_pair_unique
    ON relations (LEAST(user_a_id, user_b_id), GREATEST(user_a_id, user_b_id));

CREATE UNIQUE INDEX IF NOT EXISTS uq_relations_user_a_active
    ON relations (user_a_id)
    WHERE status = 'active';

CREATE UNIQUE INDEX IF NOT EXISTS uq_relations_user_b_active
    ON relations (user_b_id)
    WHERE status = 'active';

CREATE UNIQUE INDEX IF NOT EXISTS uq_messages_sender_client_msg
    ON messages (sender_id, client_msg_id);

CREATE INDEX IF NOT EXISTS idx_messages_relation_created
    ON messages (relation_id, created_at DESC);
