CREATE SCHEMA IF NOT EXISTS world;

CREATE TABLE world.contacts (
  id SERIAL PRIMARY KEY, name TEXT NOT NULL, email TEXT NOT NULL UNIQUE,
  is_owner BOOLEAN NOT NULL DEFAULT false
);

CREATE TABLE world.emails (
  id SERIAL PRIMARY KEY,
  sender_name TEXT NOT NULL, sender_email TEXT NOT NULL,
  subject TEXT NOT NULL, body TEXT NOT NULL,
  received_at TIMESTAMPTZ NOT NULL, is_read BOOLEAN NOT NULL DEFAULT false
);

CREATE TABLE world.sent_emails (
  id SERIAL PRIMARY KEY,
  task_id UUID, to_addr TEXT NOT NULL, subject TEXT NOT NULL, body TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE world.calendar_events (
  id SERIAL PRIMARY KEY, task_id UUID,
  title TEXT NOT NULL, starts_at TIMESTAMPTZ NOT NULL, ends_at TIMESTAMPTZ NOT NULL,
  attendees JSONB NOT NULL DEFAULT '[]'
);

CREATE TABLE world.web_pages (
  slug TEXT PRIMARY KEY, title TEXT NOT NULL, content TEXT NOT NULL
);