include_recipe "stacker_file"
include_recipe "stacker_php::mount"
include_recipe "stacker_php::ftp" if node[:ftp][:enable] == "true"
include_recipe "stacker_php::http"
include_recipe "stacker_php::php"
include_recipe "stacker_php::ssl" if node[:ssl][:enable] == "true"
include_recipe "stacker_php::deploy"
include_recipe "stacker_php::database" if node[:database][:enable] == "true"
include_recipe "stacker_php::cloudwatch" if node[:cloudwatch][:enable] == "true"