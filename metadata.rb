name             'stacker_php'
maintainer       'stacker-project'
maintainer_email 'stacker-project@phoenection.com'
license          'Apache 2.0'
description      'stacker_php is a top level cookbook that deploys apache, php and optional mysql'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

recipe 'stacker_php::default', 'The only recipe to call to install the project'
recipe 'stacker_php::cloudwatch', 'Installs cloudwatch metric scripts'
recipe 'stacker_php::database', 'Install the database and/or dependency files'
recipe 'stacker_php::deploy', 'Deploys the project files'
recipe 'stacker_php::http', 'Installs HTTP for the server'
recipe 'stacker_php::mount', 'Configures the ephemeral mount'
recipe 'stacker_php::php', 'Installs PHP for the server'
recipe 'stacker_php::ssl', 'Install SSL certificates on the server'

supports 'amazon', '>= 2013.09.1'

depends 'stacker_file', '~> 0.0.1'
