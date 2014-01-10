default[:infrastructure_provider] = 'amazon'

default[:project][:name] = 'testproject'
default[:project][:version] = 1
default[:project][:versions_to_keep] = 5
default[:project][:directory] = "/opt/projects"

default[:php][:configuration] = {}

default[:database][:enable] = 'false'
default[:database][:endpoint] = 'localhost'
default[:database][:port] = 3306
default[:database][:name] = 'testproject_development'
default[:database][:username] = 'testproject_user'
default[:database][:password] = 'testproject_password'

default[:ftp][:enable] = 'false'
default[:ftp][:username] = 'testproject_user'
default[:ftp][:password] = 'testproject_password'

default[:ssl][:enable] = 'false'
default[:ssl][:redirect] = ''
default[:ssl][:file] = ''

default[:cloudwatch][:enable] = 'false'
default[:cloudwatch][:metric_name] = 'testproject-apache-busy-workers'
default[:cloudwatch][:namespace] = 'AS:testproject-production'
default[:cloudwatch][:key] = ''
default[:cloudwatch][:secret] = ''
