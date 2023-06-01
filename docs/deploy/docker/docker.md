# PostgresSQL & Redis in Docker Compose

### Run

_You need docker & compose installed._  
All commands are executed from the user:
* `cd capistrano_deploy_folder`
* copy [docker-compose.yml](docker-compose.yml) & [Makefile](Makefile) from `docs/deploy/docker/`
* edit `docker-compose.yml` to set passwords for databases
* `mkdir -p docker_data/rediska && chmod -R 700 docker_data && touch docker_data/.psql_history`
* `make up` - create & run container for PostgresSQL & Redis
* `make ps` - to check the status of services
* That's it, the services must work!

#### The data will be stored in `docker_data`, if you destroy the containers, the data remains.

#### To see all the commands, run: `make help`

### However, here are a few examples:
```bash
make psql        # terminal PostgreSQL
make redis-cli   # terminal Redis

# View logs:  
make logs/db     # PostgreSQL
make logs/redis  # Redis

# Entering the shell of containers 
make shell/db
make shell/redis

# Restart services:
make restart
# or a single:
make restart s=postgres

# Stop services:
make stop
# or
make stop s=rediska
```

### Dockerfile
Maybe later I will add a Dockerfile example for the app.

### Redis note
Image by [Bitnami](https://hub.docker.com/r/bitnami/redis/). This is non-root container uses AOF persistence by default.
> the mounted files and directories must have the proper permissions for the UID 1001.

### ENV
Instead of (or in addition to) the environment directive:
```yaml
environment:
  POSTGRES_DB: tradescantia_production
  POSTGRES_USER: deployer
```
you can use env files:
```yaml
env_file:
  - dock.env
```
*Even better, for sensitive data use [secrets](https://docs.docker.com/engine/swarm/secrets/).*
