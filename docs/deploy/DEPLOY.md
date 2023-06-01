
# Deploy
**Its assumed that you already have a configured server with PostgreSQL & Redis, Nginx, Node.js & Yarn, Sphinx and of course RVM.**  
*And also system libraries such as libpq-dev, libmysqlclient-dev / libmariadb-dev and so on.*  
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

### Node.js
The app was tested on versions: 16, 18 and 19, but on newer versions you need to add to `~/.bash_profile`:
```
export NODE_OPTIONS=--openssl-legacy-provider
```
Otherwise you might get an error when compiling packs: `ERR_OSSL_EVP_UNSUPPORTED`  
if you run the command directly on the app server.

## Directly deploy in capistrano:
1. Suppose you already have a locally cloned project and installed gems.
2. `cp config/deploy/deploy_production.env.sample config/deploy/deploy_production.env` or the staging environment file of the same name.
3. fill deploy_production.env with actual data
4. `cap production deploy` and follow the instructions
5. The following files (if not present) will automatically be copied to the capistrano shared folder on deploy server:
    - `config/database.yml`
    - `config/mailer.yml`
    - `config/sidekiq.yml`
    - `.env`
6. and you will need to edit them, such as `database.yml` and `.env`  
   For example, you need to set the domain in APP_HOST for the mailing, the sitemap and action_cable w https.
7. if all is successful, the application will be deployed and the necessary services will be restarted, like: sphinx/puma/sidekiq.
8. `cap production rake[db:seed]` if needed
9. enjoy!

## After deploy:
- You can run any rake command via capistrano:
    ```
    # rebuild real-time indexes sphinx
    cap production rake[ts:rt:rebuild]
    # list rake tasks
    cap production rake[-T]
    ```
  *limit: one rake command at a time*
- Or you can connect to a production server and run it directly there:
    ```
    # sitemap generation
    RAILS_ENV=production bundle exec rake sitemap:generate
    # rails console
    RAILS_ENV=production bundle exec rails c
    ```
- If you ever need to run rails with the log in the terminal:
    ```
    RAILS_LOG_TO_STDOUT=true RAILS_ENV=production bundle exec rails s
    ```
    *Will not forget to stop Puma.*
- 