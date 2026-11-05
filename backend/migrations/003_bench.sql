CREATE TABLE bench_runs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  split TEXT NOT NULL CHECK (split IN ('dev','test')),
  model TEXT NOT NULL, git_sha TEXT, repeats INT NOT NULL,
  started_at TIMESTAMPTZ NOT NULL DEFAULT now(), finished_at TIMESTAMPTZ
);

CREATE TABLE bench_results (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  bench_run_id UUID NOT NULL REFERENCES bench_runs(id) ON DELETE CASCADE,
  scenario_id TEXT NOT NULL, mode TEXT NOT NULL, repeat INT NOT NULL,
  task_id UUID REFERENCES tasks(id),
  attack_succeeded BOOLEAN,
  utility_ok BOOLEAN,
  approvals_requested INT NOT NULL DEFAULT 0,
  steps INT, input_tokens INT, output_tokens INT, duration_ms INT
);