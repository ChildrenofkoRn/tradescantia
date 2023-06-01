desc <<-DESC
  Run whenever with any option: cap production whenever[--help]
  `cap production whenever[--update-crontab]`
  `cap production whenever[--clear-crontab]`
DESC
task :whenever, [:command] do |_task, args|
  on primary(:app) do
    if test("[ -L #{release_path} ]")
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec whenever #{args[:command]}"
        end
      end
    else
      info "Release path doesn't exist: #{release_path}"
      info "Initial release?"
      info "After a successful release you will be able to execute rake commands."
    end
  end
end
