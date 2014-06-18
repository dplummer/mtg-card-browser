require 'vlad/assets'

set :deploy_to, "/home/deploy/mtgbrowser"
set :repository, "git@github.com:dplummer/mtg-card-browser.git"
set :app_name,   'mtgbrowser'
set :rails_env, ENV.fetch('env', 'production')

set :revision,   ENV['branch'] ? "origin/#{ENV['branch']}" : "origin/master"
set :bundle_cmd, "/usr/local/rvm/wrappers/ruby-2.1.1/bundle"
set :bundle_flags, "--deployment"
set(:bundle_dir) { File.join("$HOME", 'bundle') }
set :bundle_gemfile, "Gemfile"
set :bundle_without, [:development, :test, :cucumber, :assets]
set(:bundle_args) do
  args = ["--gemfile #{File.join(latest_release, bundle_gemfile)}"]
  args << "--path #{bundle_dir}" unless bundle_dir.to_s.empty?
  args << bundle_flags.to_s
  args << "--without #{bundle_without.join(" ")}"
  args.join(" ")
end
set :rake_cmd, "#{bundle_cmd} exec rake"

set :shared_paths, shared_paths.merge({
  'tmp'                   => 'tmp',
  'assets'                => 'public/assets',
  'database.yml'          => 'config/database.yml'
})

if ENV['hostname']
  host "deploy@#{ENV['hostname']}", :web, :app, :db, :main, :workers
else
  host "deploy@mtgbrowser.com", :web, :app, :db, :main, :workers
end


namespace :vlad do
  remote_task :update_without_symlinks, :roles => :app do
    begin
      run [ "cd #{scm_path}",
            "#{source.checkout revision, scm_path}",
            "#{source.export revision, release_path}",
            "chmod -R g+w #{latest_release}",
            "rm -rf #{shared_paths.values.map { |p| File.join(latest_release, p) }.join(' ')}",
            "mkdir -p #{mkdirs.map { |d| File.join(latest_release, d) }.join(' ')}"
          ].join(" && ")
    rescue => e
      run "rm -rf #{release_path}"
      raise e
    end
  end

  remote_task :link_current, :roles => :app do
    run "rm -f #{current_path} && ln -s #{latest_release} #{current_path}"
  end

  remote_task :bundle_install, :roles => :app do
    args = ["--gemfile #{File.join(latest_release, bundle_gemfile)}"]
    args << "--path #{bundle_dir}" unless bundle_dir.to_s.empty?
    args << bundle_flags.to_s
    args << "--without #{bundle_without.join(" ")}"

    run "cd #{latest_release} && #{bundle_cmd} install #{args.join(' ')}"
  end

  desc "Deploy without app restart"
  remote_task :deploy_without_restart => [
    :update_without_symlinks,
    :update_symlinks,
    :bundle_install,
    :link_current,
    'vlad:assets:precompile',
    :cleanup,
    :migrate
  ]

  desc "Deploy with migrations"
  remote_task :deploy => [
    :deploy_without_restart,
    :start_app,
    ]
end
