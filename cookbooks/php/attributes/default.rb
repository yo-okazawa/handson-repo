#
# Cookbook Name:: php
# Recipe:: attributes/default.rb
#

default["php"]["packages"] = ["php", "php-mysql"]
default["php"]["conf-dir"] = "/tmp"
default["php"]["conf-file"] = "php.ini"
default["php"]["template"] = "php.ini.erb"


