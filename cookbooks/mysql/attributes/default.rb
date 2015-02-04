#
# Cookbook Name:: mysql
# Recipe:: attributes/default.rb
#

default["mysql"]["packages"] = "mysql-server"
default["mysql"]["conf-dir"] = "/etc"
default["mysql"]["conf-file"] = "my.cnf"
default["mysql"]["template"] = "my.cnf.erb"



