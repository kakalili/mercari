# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "mercari"
set :repo_url, "git@github.com:sattsu55/mercari.git"

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :rbenv_type, :user
set :rbenv_ruby, '2.3.1'

set :ssh_options, auth_methods: ['publickey'],
                  keys: ['~/.ssh/sattsu55.pem']

set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }
set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }
set :keep_releases, 5

set :default_env,
    rbenv_root: "/usr/local/rbenv",
    path: "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH",
    AWS_ACCESS_KEY_ID: ENV["AWS_ACCESS_KEY_ID"],
    AWS_SECRET_ACCESS_KEY: ENV["AWS_SECRET_ACCESS_KEY"],
    BASIC_AUTH_USER: ENV["BASIC_AUTH_USER"],
    BASIC_AUTH_PASSWORD: ENV["BASIC_AUTH_PASSWORD"],
    RECAPTCHA_SITE_KEY: ENV['RECAPTCHA_SITE_KEY'],
    RECAPTCHA_SECRET_KEY: ENV['RECAPTCHA_SECRET_KEY'],
    APP_ID: ENV["APP_ID"],
    APP_SECRET: ENV["APP_SECRET"],
    GOOGLE_CLIENT_ID: ENV['GOOGLE_CLIENT_ID'],
    GOOGLE_CLIENT_SECRET: ENV['GOOGLE_CLIENT_SECRET'],
    PAYJP_PUBLIC_KEY: ENV["PAYJP_PUBLIC_KEY"],
    PAYJP_SECRET_KEY: ENV["PAYJP_SECRET_KEY"]

set :linked_files, %w[config/secrets.yml]

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
  desc 'db_seed'
  task :db_seed do
    on roles(:db) do |_host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end
  task :db_reset do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:migrate:reset"
        end
      end
    end
  end
  desc 'upload secrets.yml'
  task :upload do
    on roles(:app) do |_host|
      execute "mkdir -p #{shared_path}/config" if test "[ ! -d #{shared_path}/config ]"
      upload!('config/secrets.yml', "#{shared_path}/config/secrets.yml")
    end
  end
  before :starting, 'deploy:upload'
  after :finishing, 'deploy:cleanup'
end
