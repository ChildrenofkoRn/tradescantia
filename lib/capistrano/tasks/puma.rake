namespace :puma do

  desc 'Reload Puma via tmp/restart.txt'
  task :reload do
    on roles(:web) do
      if test("[ -f #{shared_path}/tmp/pids/server.pid ]")
        within current_path do
          with rails_env: fetch(:rails_env) do
            execute :touch, 'tmp/restart.txt'
          end
        end
      else
        info "Puma is probably not running, because the PID file is not found."
        info "So instead of puma:reload we will try to run puma:restart"
        invoke 'puma:restart'
      end
    end
  end

  desc 'Restart Puma via systemd service'
  task :restart do
    on roles(:web) do
      execute :systemctl, ' --user restart puma'
    end
  end

  desc 'Start Puma via systemd service'
  task :start do
    on roles(:web) do
      execute :systemctl, ' --user start puma'
    end
  end

  desc 'Stop Puma via systemd service'
  task :stop do
    on roles(:web) do
      execute :systemctl, ' --user stop puma'
    end
  end

end
