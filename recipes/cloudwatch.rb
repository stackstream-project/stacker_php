directory "/opt/cloudwatch" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

template "/opt/cloudwatch/apache-busy-workers.sh" do
  source "apache-busy-workers.sh.erb"
  mode "0755"
  owner "root"
  group "root"
  variables(
    :namespace => node[:cloudwatch][:namespace],
    :metric_name => node[:cloudwatch][:metric_name],
    :key => node[:cloudwatch][:key],
    :secret => node[:cloudwatch][:secret]
  )
end

cron "apache-busy-workers" do
  minute "*/2"
  command "/opt/cloudwatch/apache-busy-workers.sh >/dev/null 2>&1"
  action :create
end
