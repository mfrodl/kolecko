# frozen_string_literal: true

set :application, 'kolecko'
set :repo_url, 'git@gitlab.kuca.cz:sifrovacky/kolecko.git'

set :tmp_dir, '/tmp'
set :default_env, {}

# install into "system" gems
set :bundle_path, nil
set :bundle_binstubs, nil
set :bundle_flags, '--system'

set :pty, false

set :rbenv_type, :system
set :rbenv_ruby, '2.6.1'

set :rails_env, :production
set :linked_files, %w[config/database.yml config/secrets.yml]

# Default value for linked_dirs is []
set :linked_dirs, %w[bin log tmp uploads public/assets config/secret]

namespace :deploy do
  after :finishing, 'deploy:cleanup'

  desc 'Symlink linked directories'
  task :linked_paths do
    next unless any? :symlinks

    on release_roles :all do
      linked_dir_parents(release_path).each do |parent|
        execute :mkdir, '-p', parent unless test "[ -L #{parent} ]"
      end
      fetch(:symlinks).each do |path|
        source = shared_path.join(path[:source])
        target = release_path.join(path[:link])
        next if test "[ -L #{target} ]"

        warn "Can't link #{source} to #{target}: target exists and is a directory." if test "[ -d #{target} ]"
        execute :mkdir, '-p', File.dirname(target)
        execute :ln, '-s', source, target
      end
    end
  end

  namespace :check do
    Rake::Task['linked_dirs'].clear_actions
    desc 'Check directories to be linked exist in shared'
    task :linked_dirs do
      next unless any? :linked_dirs

      on release_roles :all do
        linked_dirs(shared_path).each do |dir|
          execute :mkdir, '-p', dir unless test "[ -L #{dir} ]"
        end
      end
    end
  end

  desc 'Restart webserver'
  task :restart do
    on release_roles :all do
      execute :sudo, 'systemctl', 'restart', 'www-kolecko.service'
    end
  end

  after :publishing, 'deploy:restart'
  after :check, 'deploy:linked_paths'
end
