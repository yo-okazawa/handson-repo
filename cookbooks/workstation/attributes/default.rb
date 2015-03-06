#
# Cookbook Name:: workstation
# Recipe:: attributes/default.rb
#

default["workstation"]["gem-list"] = [
  "knife-push-0.5.2.gem",
  "knife-reporting-0.4.1.gem"
]

default["workstation"]["template"] = [
  "rhel.erb",
  "win.erb"
]

default["workstation"]["repo-url"] = "https://chefrepo.cloud-platform.kddi.ne.jp/packages/chef"
default["workstation"]["repo-gem"] = "gems"
default["workstation"]["repo-template"] = "bootstrap"
default["workstation"]["gem-dir"] = "/tmp/gems"
default["workstation"]["template-dir"] = "/etc/chef"
