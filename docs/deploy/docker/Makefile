THIS_FILE := $(lastword $(MAKEFILE_LIST))
.PHONY: help build up start restart stop down ps logs/db logs/redis psql redis-cli shell/db shell/redis health/postgres health/redis pg_dump
help:
	make -pRrq  -f $(THIS_FILE) : 2>/dev/null | awk -v RS= -F: '/^# Files/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
build:
	docker compose -f docker-compose.yml build $(s)
up:
	docker compose -f docker-compose.yml up -d $(s)
start:
	docker compose -f docker-compose.yml start $(s)
restart:
	docker compose -f docker-compose.yml restart $(s)
stop:
	docker compose -f docker-compose.yml stop $(s)
down:
	docker compose -f docker-compose.yml down $(s)
destroyall:
	docker compose -f docker-compose.yml down -v --rmi all
destroy:
	docker compose -f docker-compose.yml down -v --rmi local
ps:
	docker compose -f docker-compose.yml ps -a
logs/db:
	docker compose -f docker-compose.yml logs --tail=50 -f postgres
logs/redis:
	docker compose -f docker-compose.yml logs --tail=50 -f rediska
psql:
	docker compose -f docker-compose.yml exec postgres psql -U deployer -d tradescantia_production
redis-cli:
	docker compose -f docker-compose.yml exec rediska redis-cli
shell/db:
	docker compose -f docker-compose.yml exec postgres bash
shell/redis:
	docker compose -f docker-compose.yml exec rediska bash
health/postgres:
	docker inspect --format='{{json .State.Health}}' $$(docker compose ps -q postgres)
health/redis:
	docker inspect --format='{{json .State.Health}}' $$(docker compose ps -q rediska)
pg_dump:
	docker compose -f docker-compose.yml exec postgres pg_dump -U deployer tradescantia_production > tradescantia_prod_`date +%d-%m-%Y"_"%H_%M_%S`.sql
