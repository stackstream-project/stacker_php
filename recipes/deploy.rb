project_files = "#{Chef::Config[:file_cache_path]}/#{node[:project][:name]}_#{node[:project][:version]}.tar.gz"

stacker_file project_files do
  remote_source "projects/#{node[:project][:name]}/#{project_files}"
  action :create_if_missing
end

directory "#{node[:project][:directory]}/#{node[:project][:name]}/versions/#{node[:project][:version]}" do
  owner "apache"
  group "apache"
  mode 00700
  recursive true
  action :create
end

execute "extracting project files" do
  cwd "#{node[:project][:directory]}/#{node[:project][:name]}/versions/#{node[:project][:version]}"
  command "tar -zxf #{project_files}"
  action :run
  only_if "test -f #{project_files}"
end

execute "fix ownership for project files" do
  cwd "#{node[:project][:directory]}/#{node[:project][:name]}"
  command "chown -R apache. . && chmod -R 700 ."
  action :run
end

link "remove current version" do
  target_file "#{node[:project][:directory]}/#{node[:project][:name]}/current"
  only_if "test -L #{node[:project][:directory]}/#{node[:project][:name]}/current"
  not_if "readlink #{node[:project][:directory]}/#{node[:project][:name]}/current | grep #{node[:project][:version]}"
  action :delete
end

link "link current version" do
  target_file "#{node[:project][:directory]}/#{node[:project][:name]}/current"
  to "#{node[:project][:directory]}/#{node[:project][:name]}/versions/#{node[:project][:version]}"
  owner "apache"
  group "apache"
  action :create
  only_if "test -d #{node[:project][:directory]}/#{node[:project][:name]}/versions/#{node[:project][:version]}"
  not_if "readlink #{node[:project][:directory]}/#{node[:project][:name]}/current | grep #{node[:project][:version]}"
  notifies :restart, "service[httpd]", :delayed
end

%w(php-mysql mysql-devel).each do |pkg|
  package pkg
end

template "#{node[:project][:directory]}/#{node[:project][:name]}/current/database_config.php" do
  source "database_config.php.erb"
  mode "0644"
  owner "apache"
  group "apache"
  variables(
    :database_endpoint => node[:database][:endpoint],
    :database_port => node[:database][:port],
    :database_name => node[:database][:name],
    :database_username => node[:database][:username],
    :database_password => node[:database][:password]
  )
  notifies :restart, "service[httpd]", :delayed
end

template "/etc/httpd/conf.d/#{node[:project][:name]}.conf" do
  source "project.conf.erb"
  mode "0644"
  owner "root"
  group "root"
  variables(
    :document_root => "#{node[:project][:directory]}/#{node[:project][:name]}/current",
    :ssl_enable => (node[:ssl][:enable] == "true" ? true : false),
    :ssl_redirect => (node[:ssl][:redirect] == "" ? false : node[:ssl][:redirect]),
  )
  notifies :restart, "service[httpd]", :delayed
end

ruby_block "check for older project versions" do
  block do
    version_directories = ::Dir.glob("#{node[:project][:directory]}/#{node[:project][:name]}/versions/*").sort
    
    to_keep_counter = version_directories.count

    return if node[:project][:versions_to_keep] > to_keep_counter

    version_directories.each do |directory|
      version = directory.gsub("#{node[:project][:directory]}/#{node[:project][:name]}/versions/",'').to_i
      
      next if version == node[:project][:version]

      begin
        ::FileUtils.rm_rf(directory)
      rescue Errno::ENOENT
        Chef::Log.warn "Missing directory: #{directory}"
      end

      to_keep_counter-= 1

      break if to_keep_counter == node[:project][:versions_to_keep]
    end
  end
  action :create
end
