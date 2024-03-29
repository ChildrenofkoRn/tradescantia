desc 'Executes a command on the deploy server'
task :rake, [:command] do |_task, args|
  on primary(:app) do
    if test("[ -L #{release_path} ]")
      within release_path do
        with rails_env: fetch(:rails_env) do
          rake args[:command]
        end
      end
    else
      info "Release path doesn't exist: #{release_path}"
      info "Initial release?"
      info "After a successful release you will be able to execute rake commands."
    end
  end
end
