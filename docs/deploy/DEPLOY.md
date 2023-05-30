
# Deploy
**Its assumed that you already have a configured server with PostgreSQL & Redis, Nginx, sphinx and of course RVM.**  
***If not, this should help you:***

### Nginx
An example of the Nginx config here: [tradescantia.conf](nginx/tradescantia.conf)  
Configured for http and App Server 3003 port, use certbot to get https.

### Docker Compose
For PostgreSQL & Redis, there is a config for Docker Compose and a makefile for easy container management.  
a little instruction here: [How to run docker services?](docker/docker.md)

### systemd
Templates systemd services: [docs/deploy/systemd](systemd/)  
You can read more [here](systemd/systemd.md).

## Directly deploy in capistrano:
1. Suppose you already have a locally cloned project and installed gems.
2. `cp config/deploy/deploy_production.env.sample config/deploy/deploy_production.env` or the staging environment file of the same name.
4. fill deploy_production.env with actual data
4. `cap production deploy` and follow the instructions
5. The following files (if not present) will automatically be copied to the capistrano shared folder on deploy server:
    - `config/database.yml`
    - `config/mailer.yml`
    - `config/sidekiq.yml`
    - `.env`
6. and you will need to edit them, such as `database.yml` and `.env`  
   For example, you need to set the domain in APP_HOST for the mailing, the sitemap and action_cable w https.
7. if all is successful, the application will be deployed and the necessary services will be restarted, like: sphinx/puma/sidekiq.
8. enjoy!
