package "vsftpd"

template "/etc/vsftpd/vsftpd.conf" do
  source "vsftpd.conf.erb"
  mode "0644"
  owner "root"
  group "root"
  notifies :restart, "service[vsftpd]", :delayed
end

template "/etc/vsftpd/user_list" do
  source "user_list.erb"
  mode "0644"
  owner "root"
  group "root"
  variables(:user => node[:ftp][:username])
  notifies :restart, "service[vsftpd]", :delayed
end

group node[:ftp][:username]

user node[:ftp][:username] do
  comment "User for FTP"
  gid node[:ftp][:username]
  supports :manage_home => true
  home "/home/#{node[:ftp][:username]}"
  shell "/bin/bash"
  action :create
end

execute "create ftp user's password" do
  command <<-EOF
    password=`perl -e 'print crypt("#{node[:ftp][:password]}", "password")'`
    usermod -p "$password" #{node[:ftp][:username]}
  EOF
  action :run
  not_if "grep #{node[:ftp][:password]} /etc/shadow"
end

# link "link ftp user to project directory" do
#   target_file "/#{node[:project][:directory]}/projects/#{node[:project][:name]}/current"
#   to "/#{node[:project][:directory]}/projects/#{node[:project][:name]}/versions/#{node[:project][:version]}"
#   owner node[:ftp][:username]
#   group node[:ftp][:username]
#   action :create
# end

service "vsftpd" do
  action :nothing
end
