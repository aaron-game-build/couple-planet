-- Week1 DDL 冻结版（PostgreSQL）
-- 目标：注册/绑定/即时聊天最小闭环

-- 建议启用扩展（如果用 uuid 生成）
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================
-- users
-- =====================================
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account VARCHAR(128) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    nickname VARCHAR(20) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_users_account UNIQUE (account)
);

CREATE INDEX IF NOT EXISTS idx_users_created_at
    ON users (created_at DESC);

-- =====================================
-- relations
-- 说明：
-- 1) Week1 仅支持 active 状态
-- 2) 单用户只能出现在一个 active 关系中
-- =====================================
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

-- 邀请码唯一（可空）
CREATE UNIQUE INDEX IF NOT EXISTS uq_relations_invite_code
    ON relations (invite_code)
    WHERE invite_code IS NOT NULL;

-- 关系对唯一（无序对）：(min(user), max(user))
CREATE UNIQUE INDEX IF NOT EXISTS uq_relations_pair_unique
    ON relations (LEAST(user_a_id, user_b_id), GREATEST(user_a_id, user_b_id));

-- 单用户 active 关系唯一（两个方向都限制）
CREATE UNIQUE INDEX IF NOT EXISTS uq_relations_user_a_active
    ON relations (user_a_id)
    WHERE status = 'active';

CREATE UNIQUE INDEX IF NOT EXISTS uq_relations_user_b_active
    ON relations (user_b_id)
    WHERE status = 'active';

CREATE INDEX IF NOT EXISTS idx_relations_bound_at
    ON relations (bound_at DESC);

-- =====================================
-- messages
-- =====================================
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

-- 幂等键：同一发送者 client_msg_id 不可重复
CREATE UNIQUE INDEX IF NOT EXISTS uq_messages_sender_client_msg
    ON messages (sender_id, client_msg_id);

-- 会话历史查询主索引
CREATE INDEX IF NOT EXISTS idx_messages_relation_created
    ON messages (relation_id, created_at DESC);

-- 已读回写查询
CREATE INDEX IF NOT EXISTS idx_messages_relation_read_at
    ON messages (relation_id, read_at);

-- =====================================
-- 触发器：自动维护 updated_at（可选）
-- =====================================
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_users_updated_at ON users;
CREATE TRIGGER trg_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_relations_updated_at ON relations;
CREATE TRIGGER trg_relations_updated_at
BEFORE UPDATE ON relations
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

