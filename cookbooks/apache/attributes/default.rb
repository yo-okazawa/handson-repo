#
# Cookbook Name:: apache
# Recipe:: attributes/default.rb
#

default["apache"]["package"] = "httpd"
default["apache"]["conf-dir"] = "/etc/httpd/conf"
default["apache"]["conf-file"] = "httpd.conf"
default["apache"]["template"] = "httpd.conf.erb"


