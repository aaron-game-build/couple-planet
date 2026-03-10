CREATE TABLE IF NOT EXISTS relation_invites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(32) NOT NULL,
    inviter_user_id UUID NOT NULL REFERENCES users (id),
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    expires_at TIMESTAMPTZ NOT NULL,
    consumed_by_user_id UUID NULL REFERENCES users (id),
    consumed_at TIMESTAMPTZ NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT ck_relation_invites_status CHECK (status IN ('active', 'consumed', 'expired'))
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_relation_invites_code
    ON relation_invites (code);

CREATE UNIQUE INDEX IF NOT EXISTS uq_relation_invites_inviter_active
    ON relation_invites (inviter_user_id)
    WHERE status = 'active';
