#
# Cookbook Name:: insMysql
# Recipe:: attributes/default.rb
#


default["mysql"]["rpmList"] = ["MySQL-shared-compat-5.5.30-1.el6.x86_64.rpm",
                               "MySQL-client-5.5.30-1.el6.x86_64.rpm",
                               "MySQL-server-5.5.30-1.el6.x86_64.rpm"]
default["mysql"]["cnfFile"] = "my.cnf"
default["mysql"]["cnfDir"] = "/etc"

default["repo"]["url"] = "http://10.110.42.200/packages"
default["target"]["insDir"] = "/tmp"

