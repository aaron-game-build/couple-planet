-- Allow rebind for the same pair after relation is unbound/cancelled.
-- Keep uniqueness only for active relation pairs.

DROP INDEX IF EXISTS uq_relations_pair_unique;

CREATE UNIQUE INDEX IF NOT EXISTS uq_relations_pair_active
    ON relations (LEAST(user_a_id, user_b_id), GREATEST(user_a_id, user_b_id))
    WHERE status = 'active';
