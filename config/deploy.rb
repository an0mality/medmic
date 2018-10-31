require 'mina/bundler'
require 'mina/multistage'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina/whenever'

set :port, '100'           # SSH port number.

# set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/vpch_database.yml', 'config/lsd_database.yml',
#                                                  'config/mse_database.yml', 'config/feed_database.yml', 'config/fifa_database.yml',
#                                                  'config/secrets.yml', 'public/AHD.pdf',
#                                                  'public/favicon.ico', 'public/robots.txt')



set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/vpch_database.yml', 'config/lsd_database.yml',
                                                 'config/mse_database.yml', 'config/feed_database.yml', 'config/fifa_database.yml',
                                                 'config/frmr_database.yml','config/secrets.yml', 'public/AHD.pdf', 'public/favicon.ico', 'public/robots.txt')


set :shared_dirs, fetch(:shared_dirs, []).push('public/mse','public/fifa', 'public/vpch', 'public/feed', 'public/ahd','public/frmr','public/employee',
                                               'public/send_spid_registry', 'log')




# set :shared_paths, ['public/mse','public/fifa', 'log','public/vpch', 'public/feed', 'log']
set :whenever_name # default: "#{domain}_#{rails_env}"
 set :whenever_environment, 'production'

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  # invoke :'rbenv:load'
  command 'source ~/.zshrc'
  #
   if fetch(:current_path).match('production')
     command 'crontab -r'
   end



  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use', 'ruby-2.3.1@medstat'
end


# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup => :environment do
  # command %[mkdir -p "log"]
  command %[chmod g+rx,u+rwx "log"]

  command %[mkdir -p "config"]
  command %[chmod g+rx,u+rwx "config"]

  command %[touch "config/database.yml"]
  command %[touch "config/vpch_database.yml"]
  command %[touch "config/mse_database.yml"]
  command %[touch "config/feed_database.yml"]
  command %[touch "config/lsd_database.yml"]
  command %[touch "config/fifa_database.yml"]
  command %[touch "config/frmr_database.yml"]
  command %[touch "config/secrets.yml"]
  command %[touch "config/schedule.rb"]
  # queue! %[touch "#{deploy_to}/#{shared_path}/config/secrets.yml"]
  command  %[echo "-----> Be sure to edit 'config/database.yml' and 'secrets.yml'."]

end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'rvm:use', 'ruby-2.3.1@medstat'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
     invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'


    on :launch do
      in_path(fetch(:current_path)) do
        command "mkdir -p tmp/"
        command "touch tmp/restart.txt"

        # command "ln -s #{fetch(:deploy_to)}/shared/public/feed  #{fetch(:current_path)}/public/feed"
        # command "ln -s #{fetch(:deploy_to)}/shared/public/ahd  #{fetch(:current_path)}/public/ahd"
        # command "ln -s #{fetch(:deploy_to)}/shared/public/vpch  #{fetch(:current_path)}/public/vpch"
        # command "ln -s #{fetch(:deploy_to)}/shared/public/fifa  #{fetch(:current_path)}/public/fifa"
        # command "ln -s #{fetch(:deploy_to)}/shared/public/mse  #{fetch(:current_path)}/public/mse"
        # command "ln -s #{fetch(:deploy_to)}/shared/public/send_spid_registry  #{fetch(:current_path)}/public/send_spid_registry"


        if fetch(:current_path).match('production')
           invoke :'whenever:update'
        end

      end
    end
  end

  desc "Precompiles assets (skips if nothing has changed since the last release)."
  task :assets_precompiles => :environment do
    if ENV['force_assets']
      invoke :'rails:assets_precompile:force'
    else
      message = verbose_mode? ?
          '$((count)) changes found, precompiling asset files' :
          'Precompiling asset files'

      queue check_for_changes_script \
        :check => compiled_asset_path,
        :at => [*asset_paths],
        :skip => %[
          echo "-----> Skipping asset precompilation"
          #{echo_cmd %[mkdir -p "$build_path/#{compiled_asset_path}"]}
          # 'echo_cmd %[cp -R "#{compiled_asset_path}/." "$build_path/#{compiled_asset_path}"]}'
        ],
        :changed => %[
          echo "-----> #{message}"
          #{echo_cmd %[#{rake_assets_precompile}]}
        ],
        :default => %[
          echo "-----> Precompiling asset files"
          #{echo_cmd %[#{rake_assets_precompile}]}
        ]
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs