package "httpd"

service "httpd" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

template "/etc/httpd/conf/httpd.conf" do
  source "httpd.conf.erb"
  mode "0644"
  owner "root"
  group "root"
  notifies :restart, "service[httpd]", :delayed
end

execute "remove default conf.d files" do
  cwd "/etc/httpd/conf.d"
  command "rm -Rf *"
  action :run
  only_if "test -f /etc/httpd/conf.d/README"
end

template "/etc/httpd/conf.d/server-status.conf" do
  source "server-status.conf.erb"
  mode "0644"
  owner "root"
  group "root"
  variables(
    :document_root => "#{node[:project][:directory]}/#{node[:project][:name]}/current"
  )
  notifies :restart, "service[httpd]", :delayed
end
