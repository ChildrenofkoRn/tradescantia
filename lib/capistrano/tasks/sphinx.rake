# because the output of the command ref "rake ts:start" freezes the console,
# the redirected output version works.
# but it is a messy solution, it hides errors if they occur.
# if you dont have that, you can use the tasks from thinking_sphinx/capistrano.

namespace :sphinx do

  desc 'Generate the Sphinx configuration'
  task :configure do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "ts:configure"
        end
      end
    end
  end

  desc 'Stop the Sphinx'
  task :stop do
    on roles(:app) do
      if test("[ -L #{current_path} ]")
        within current_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, "ts:stop"
          end
        end
      else
        info "Current_path doesn't exist: #{current_path}"
        info "This may be your first release, so instead of sphinx:stop, try sphinx:configure."
      end
    end
  end

  # It is better to always use restart, then there will be no error if Sphinx ( searchd ) is already running.
  desc 'Start the Sphinx (Returns an exception if already running)'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "ts:start > /dev/null 2>&1"
        end
      end
    end
  end

  desc 'Restart the Sphinx'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "ts:restart > /dev/null 2>&1"
        end
      end
    end
  end

  desc 'Rebuilding the Sphinx indices w restart'
  task :rebuild do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "ts:rt:rebuild > /dev/null 2>&1"
        end
      end
    end
  end

end
