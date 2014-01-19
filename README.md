# Description

stacker_php is a top level cookbook that deploys apache, php and optional mysql/cloudwatch/ssl.

This is cookbook relies on the attributes given for a customized configuration. Currently everything deployed is in the cookbook, please see the roadmap to make this a true top level cookbook.

# Roadmap

1. <del>Deploy apache 2.2+</del>
2. <del>Deploy php 5.3+</del>
3. <del>Optionally deploy mysql 5.3+</del>
4. <del>Configure ephemeral mounts for application</del>
5. <del>Add database_config.php file for applications to use it</del>
6. <del>Optionally deploy SSL certificates and/or ports for a load balancer to use</del>
7. <del>Optionally deploy cloudwatch cron job for apache statistics</del>
8. Move each deployment type to it's own seperate cookbook (apache, php, mysql, etc...) this way we can use this cookbook as a top level cookbook

# Requirements

### Platform

* Amazon Linux

Tested on:

* Amazon Linux 6 - 2013.09.1

# Dependencies

* stacker_file cookbook

# Attributes

### Input

* `[:project][:name]` - the project's name
* `[:project][:version]` - version of the project to deploy
* `[:project][:versions_to_keep]` - how many versions to keep on the server(s)
* `[:php][:configuration]` - php.ini attributes hash
* `[:database][:enable]` - true or false (true will setup database on local server, false will not)
* `[:database][:endpoint]` - database server dns record
* `[:database][:port]` - database server port
* `[:database][:name]` - database name to use (if enable is true, then it will create it also)
* `[:database][:username]` - database user for project (if enable is true, then it will create the user also)
* `[:database][:password]` - database password (if enable is true, will assign the password to the user)
* `[:ssl][:enable]` - true or false (true will setup server with SSL certificates from `[:ssl][:file]` attribute)
* `[:ssl][:redirect]` - URL to redirect non-ssl requests to (optional)
* `[:ssl][:file]` - certificate archive file url (required if `[:ssl][:enable]` = 'true')
* `[:cloudwatch][:enable]` - true or false (true will setup cloudwatch cron jobs)
* `[:cloudwatch][:metric_name]` - A unique cloudwatch metric name
* `[:cloudwatch][:namespace]` - A cloudwatch namespace to add the metric to
* `[:cloudwatch][:key]` - API Key
* `[:cloudwatch][:secret]` - API Secret Key
* `[:infrastructure_provider]` - For stacker_file dependency

### Output


# Usage

Use the default recipe while specifying the necessary attributes to deploy the application:

    include_recipe "stacker_php::default"

# License

[Stacker Project](http://stacker-project.github.io/) - Stack Management

|                      |                                                     |
|:---------------------|:----------------------------------------------------|
| **Author:**          | Stacker-Project (<stacker-project@phoenection.com>) |
| **Copyright:**       | Copyright (c) 2014 Phoenection                      |
| **License:**         | Apache License, Version 2.0                         |

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
