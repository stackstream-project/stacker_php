package "mysql-server"

service "mysqld" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

execute "check and drop database test" do
  command "mysql -uroot -e \"DROP DATABASE test;\""
  action :run
  only_if "mysql -uroot -e \"SHOW GLOBAL STATUS LIKE 'Uptime';\""
  notifies :run, "bash[secure_install]", :immediately
  notifies :run, "bash[build]", :immediately
end

bash "secure_install" do
  code <<-EOF
  mysql -uroot -e "DELETE FROM mysql.user WHERE User='';"
  mysql -uroot -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
  mysqladmin -u root password "#{node[:database][:password]}"
  mysql -uroot -p"#{node[:database][:password]}" -e "FLUSH PRIVILEGES;"
  EOF
  action :nothing
end

bash "build" do
  code <<-EOF
  mysql -uroot -p"#{node[:database][:password]}" -e "CREATE DATABASE #{node[:database][:name]};"
  mysql -uroot -p"#{node[:database][:password]}" -e "CREATE USER #{node[:database][:username]}@'%' IDENTIFIED BY '#{node[:database][:password]}';"
  mysql -uroot -p"#{node[:database][:password]}" -e "GRANT ALL ON #{node[:database][:name]}.* TO #{node[:database][:username]}@'%';"
  mysql -uroot -p"#{node[:database][:password]}" -e "FLUSH PRIVILEGES;"
  EOF
  action :nothing
end
