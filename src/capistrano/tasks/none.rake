namespace :none do

    desc 'Check if local "repo" exists & is a directory'
    task :check do
        unless File.directory?(repo_url)
            raise "none.rake: #{repo_url} must be a directory!"
        end
    end

    # replace git:create_release by none:create_release
    desc 'Upload files'
    task :create_release do

        on roles :all do
            info 'Uploading files for release'
            info "repo_url : #{repo_url}"
            info "release_path : #{release_path}"

            execute "mkdir -p #{release_path}"

            system "cd #{repo_url}; tar czf ../build/release.tgz *"

            upload! "build/release.tgz", release_path

            execute "cd #{release_path}; tar xzf release.tgz"
            #upload! repo_url, release_path, recursive: true
            execute "cd #{release_path}; rm -f release.tgz"
            # stuff handled by deploy:symlink:create
            # execute "cd #{release_path}; cd ../..; rm -f ./current; ln -sf #{release_path} ./current;"
        end
    end

    # on fail !!!!

    desc 'Determine the revision that will be deployed'
    task :set_current_revision do
    end

end