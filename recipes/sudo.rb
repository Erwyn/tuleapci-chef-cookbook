package 'sudo'
sudo 'jenkins autoprovision' do
  user "jenkins"
  nopasswd true
  commands [ '/usr/bin/chef-solo -c /root/tuleapci/solo.rb -j /root/tuleapci/node.json']
  defaults ['!requiretty','env_reset'] 	
end
