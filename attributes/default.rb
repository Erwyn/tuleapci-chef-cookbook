default['yum']['epel']['enabled'] = true

default['yum']['rpmforge']['enabled']            = false
default['yum']['rpmforge-extras']['enabled']     = true
default['yum']['rpmforge-extras']['includepkgs'] = "git* perl-Git*";
default['yum']['rpmforge-testing']['enabled']    = false
