#
# Cookbook Name:: mysql
# Recipe:: attributes/default.rb
#

default["mysql"]["package-list"] = [
  "MySQL-shared-compat-5.5.30-1.el6.x86_64.rpm",
  "MySQL-client-5.5.30-1.el6.x86_64.rpm",
  "MySQL-server-5.5.30-1.el6.x86_64.rpm"
]

default["mysql"]["erb-file"] = "my.cnf.erb"
default["mysql"]["cnf-file"] = "my.cnf"
default["mysql"]["cnf-dir"] = "/etc"

default["mysql"]["repo-url"] = "http://10.110.42.200/packages"
default["mysql"]["package-dir"] = "/tmp"

