user "jenkins" do
   supports :manage_home => true
   action :create 
end

directory "/home/jenkins/.ssh" do
    owner "jenkins"
    group "jenkins"
    mode  00700
    action :create
end

file "/home/jenkins/.ssh/authorized_keys" do
    owner "jenkins"
    group "jenkins"
    content node['users']['jenkins']['authorized_keys'].join("\n")
    mode 00600
    action :create
end

# Add ssh private key
file "/home/jenkins/.ssh/id_rsa" do
  owner   "jenkins"
  group   "jenkins"
  mode    00600
  content node['users']['jenkins']['rsa']
  action  :create
end

file "/home/jenkins/.ssh/id_rsa.pub" do
  owner   "jenkins"
  group   "jenkins"
  mode    00600
  content node['users']['jenkins']['rsa.pub']
  action  :create
end

# Jenkins dependencies                                                      
package 'java-1.7.0-openjdk'
