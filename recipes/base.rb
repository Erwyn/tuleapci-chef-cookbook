include_recipe 'jenkins'

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

directory "/home/jenkins" do
  mode 00755
  action :create
end

execute "Install composer" do
  command "curl -k -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin"
   not_if     { ::File.exists?("/usr/local/bin/composer.phar")}
end

cookbook_file "/etc/httpd/conf.d/rest-tests.conf" do
  source "rest-tests.conf"
  action :create_if_missing
end

cookbook_file "/etc/httpd/conf.d/php.conf" do
  source "php.conf"
  action :create_if_missing
end

%w[ /home/jenkins/etc /home/jenkins/etc/codendi /home/jenkins/etc/codendi/c\
onf ].each do |path|
  directory path do
    owner "jenkins"
    group "jenkins"
    mode 00755
  end
end

template "/home/jenkins/etc/codendi/conf/integration_tests.inc" do
  source "integration_tests.inc.dist"
  owner "jenkins"
  group "jenkins"
  action :create
  variables(
    :source_path => "/home/jenkins/tuleap"
  )
end

cookbook_file "/home/jenkins/etc/codendi/conf/dbtest.inc" do
  source "dbtest.inc.dist"
  action :create_if_missing
end

service "httpd" do
  action [ :start, :enable ]
end
