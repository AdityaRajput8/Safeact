.PHONY: up down test migrate seed-world reset-world

up:
	docker compose up -d

down:
	docker compose down

test:
	cd backend && pytest

migrate:
	@echo "Migrations run automatically via docker-entrypoint-initdb.d or custom script."

seed-world:
	python backend/safeact/world/seed.py

reset-world:
	python backend/safeact/world/seed.py --reset