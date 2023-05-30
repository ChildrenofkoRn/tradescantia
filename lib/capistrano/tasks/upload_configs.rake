namespace :uploads do

  set :ups_count, { samples: 0 }

  desc 'Uploading sample configs to the deploy server, eg: sidekiq.yml.sample => sidekiq.yml'
  task :samples do
    on roles(:app) do
      unless test("[ -d #{shared_path} ]")
        raise Errno::ENOENT, "Shared path doesn't exist: #{shared_path}."
      end

      if fetch(:samples).nil?
        raise ArgumentError, "You need to 'set :samples, %w(file.env.sample config/another.yml.sample)' before call of this task"
      end

      within shared_path do
        fetch(:samples).each do |file_local|
          file_remote = shared_path.join(file_local.delete_suffix(".sample"))

          # Capistrano tasks may only be invoked once.
          # use invoke!
          # https://github.com/capistrano/capistrano/issues/1686
          invoke!("uploads:file", file_local, file_remote)
          # If you want to overwrite files
          # invoke!("uploads:file", file_local, file_remote, true)
        end

        # if at least one file was loaded, give the user time to edit.
        if fetch(:ups_count)[:samples].nonzero?
          info "Edit the uploaded files to #{host.hostname} with the actual data if needed."
          ask(:continue, 'Continue deploying? (press Enter)', 'yes')
          fetch(:continue)
        end

        fetch(:ups_count)[:samples] = 0
      end
    end
  end

  desc 'Upload master.key if not exists'
  task :master_key do
    on roles(:app) do
      local = "config/master.key"
      remote = shared_path.join(local)

      invoke("uploads:file", local, remote)
    end
  end

  # upload file on deploy App server
  task :file, [:local, :remote, :replace] do |_task, args|
    local, remote, replace = args.values_at(:local, :remote, :replace)
    on roles(:app) do

      if !replace && test("[ -f #{remote} ]")
        info remote
        info "File already exists. Skip."
        next
      elsif replace && test("[ -f #{remote} ]")
        info remote
        warn "File already exists and will be overwritten!"
      end

      # You could make it prettier, but at this stage it's fine
      fetch(:ups_count)[:samples] += 1

      # create dir with subdirs
      execute "mkdir -p #{remote.dirname}" unless test("[ -d #{remote.dirname} ]")
      upload! local, remote
    end
  end

end
