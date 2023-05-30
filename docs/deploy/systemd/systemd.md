# systemd services
Templates systemd service for Puma and Sidekiq:
1. You need to copy them to /home/{YOURUSER}/.config/systemd/user
  ```bash
  cp docs/deploy/systemd/puma.service ~/.config/systemd/user/puma.service
  cp docs/deploy/systemd/sidekiq.service ~/.config/systemd/user/sidekiq.service
  ```
2. You must have lingering enabled:
  ```bash
  # check
  loginctl show-user $USER --property Linger
  # enabling
  loginctl enable-linger $USER
  ```
3. Edit the paths in the configurations if they are different and activate them:
  ```bash
  systemctl --user reenable puma 
  systemctl --user reenable sidekiq
  ```
The services are documented, the control commands can be viewed inside the files.

> **The services will run from your user, you don't need sudo.**


### Note
If you have several rails apps on the server from one user,  you will have to edit and rename the services, adding a postfix, and editing the files:  
puma rake tasks `lib/capistrano/tasks/puma.rake` lines with:
```ruby
execute :systemctl, ' --user ... puma'
```
and  `config/deploy.rb` line:
```ruby
set :service_unit_name, "sidekiq"
```
