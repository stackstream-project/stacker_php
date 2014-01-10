package "mod_ssl"

certificates = "#{Chef::Config[:file_cache_path]}/#{node[:ssl][:file]}"

stacker_file certificates do
  remote_source "projects/#{node[:project][:name]}/#{node[:ssl][:file]}"
  action :create_if_missing
end

directory "/etc/httpd/.ssl" do
  owner "root"
  group "root"
  mode 00644
  action :create
end

execute "extract certificates" do
  cwd "/etc/httpd/.ssl"
  command "tar -zxf #{certificates}"
  action :run
  only_if "test -f #{certificates}"
end

execute "change ownership" do
  command "chown -R root. /etc/httpd/.ssl/; chmod 644 /etc/httpd/.ssl/*"
  action :run
end
