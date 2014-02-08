include_recipe 'tuleapci::jenkins'

# Configure Tuleap repo
yum_repository 'tuleap-dev' do
  description "Tuleap development repository"
  baseurl "http://ci.tuleap.net/yum/tuleap/rhel/6/dev/$basearch"
  gpgcheck false
  action :create
end

# Install dependencies
package 'git'
package 'php-soap'
package 'php'
package 'php-pear-Mail-mimeDecode'
package 'php-mysql'
package 'php-password-compat'
package 'php-zendframework'
package 'htmlpurifier'
package 'rcs'
package 'cvs'
package 'jpgraph-tuleap'
package 'php-gd'
package 'php-process'

# Phpuint                                                                   
package 'php-xml'
include_recipe 'yum-epel'
package 'php-pecl-xdebug'

# DB integration tests
execute "Setup DB" do
  command "mysql -uroot -pwelcome0 -e \"GRANT ALL PRIVILEGES on *.* to 'integration_test'@'localhost' identified by 'welcome0'\""
end

# JS tests
#package 'centos-release-SCL'
#package 'nodejs010-npm'

#execute "Install NPM packages" do
#  command "scl enable nodejs010 'npm install -g mocha chai rimraf adm-zip mocha-phantomjs phantomjs'"
#end

# Rest tests
package 'httpd'
package 'php-restler'

# Needed so apache can access sources in workspace
directory "/home/jenkins" do
  mode 00755
  action :create
end

execute "Install composer" do
  command "curl -k -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin"
   not_if     { ::File.exists?("/usr/local/bin/composer.phar")}
end

template "/etc/httpd/conf.d/rest-tests.conf" do
  source "rest-tests.conf"
  action :create
  variables(
    :source_path => "/home/jenkins/workspace/rest_job/tuleap",
    :conf_path  =>  "/home/jenkins/workspace/rest_job/etc"
  )
end

service "httpd" do
  action [ :start, :enable ]
end
