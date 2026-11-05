CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE tasks (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  request       TEXT NOT NULL,
  mode          TEXT NOT NULL DEFAULT 'safeact'
                CHECK (mode IN ('safeact','naive','prompt_defense')),
  status        TEXT NOT NULL DEFAULT 'queued'
                CHECK (status IN ('queued','running','waiting_approval',
                                  'succeeded','failed','cancelled')),
  capabilities  JSONB NOT NULL DEFAULT '[]',
  step_count    INT NOT NULL DEFAULT 0,
  config        JSONB NOT NULL DEFAULT '{}',
  result_text   TEXT,
  error         TEXT,
  scenario_id   TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  finished_at   TIMESTAMPTZ
);

CREATE TABLE events (
  task_id    UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  seq        INT  NOT NULL,
  type       TEXT NOT NULL,
  payload    JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (task_id, seq)
);

CREATE TABLE variables (
  task_id    UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  name       TEXT NOT NULL,
  value      JSONB NOT NULL,
  vtype      TEXT NOT NULL,
  tainted    BOOLEAN NOT NULL,
  constrained BOOLEAN NOT NULL DEFAULT false,
  sources    JSONB NOT NULL DEFAULT '[]',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (task_id, name)
);

CREATE TABLE approvals (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id     UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  action      JSONB NOT NULL,
  reason_code TEXT NOT NULL,
  provenance  JSONB NOT NULL,
  status      TEXT NOT NULL DEFAULT 'pending'
              CHECK (status IN ('pending','granted','denied')),
  decided_by  TEXT,
  note        TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  decided_at  TIMESTAMPTZ
);

CREATE TABLE vault_secrets (
  name        TEXT PRIMARY KEY,
  nonce       BYTEA NOT NULL,
  ciphertext  BYTEA NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);