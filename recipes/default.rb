include_recipe "stacker_file"
include_recipe "stacker_php::mount"
include_recipe "stacker_php::http"
include_recipe "stacker_php::php"
include_recipe "stacker_php::ssl" if node[:ssl][:enable] == "true"

directory node[:project][:directory] do
  owner "root"
  group "root"
  mode 00775
  action :create
end

directory "#{node[:project][:directory]}/#{node[:project][:name]}" do
  owner "apache"
  group "apache"
  mode 00775
  recursive true
  action :create
end

directory "#{node[:project][:directory]}/#{node[:project][:name]}/versions" do
  owner "apache"
  group "apache"
  mode 00775
  recursive true
  action :create
end

group "apache" do
  action :modify
  members "ec2-user"
  append true
end

include_recipe "stacker_php::deploy"
include_recipe "stacker_php::database" if node[:database][:enable] == "true"
include_recipe "stacker_php::cloudwatch" if node[:cloudwatch][:enable] == "true"
