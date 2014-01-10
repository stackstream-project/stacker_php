%w(php php-devel).each do |pkg|
  package pkg
end

template "/etc/php.ini" do
  source "php.ini.erb"
  mode "0644"
  owner "root"
  group "root"
  variables(
    :php_configurations => node[:php][:configuration]
  )
  notifies :restart, "service[httpd]", :delayed
end

template "/etc/httpd/conf.d/php.conf" do
  source "php.conf.erb"
  mode "0644"
  owner "root"
  group "root"
  notifies :restart, "service[httpd]", :delayed
end
