#
# Cookbook Name:: wordpress
# Recipe:: attributes/default.rb
#

default["wordpress"]["package-url"] = "https://chefrepo.cloud-platform.kddi.ne.jp/packages/wordpress-4.1.tar.gz"
default["wordpress"]["package"] = "wordpress-4.1.tar.gz"
default["wordpress"]["documentroot"] = "/var/www/html"
default["wordpress"]["wordpressroot"] = "wdp"


default["wordpress"]["user"]["name"] = "wdp-user"
default["wordpress"]["user"]["host"] = "localhost"
default["wordpress"]["user"]["password"] = "wdp-user"

default["wordpress"]["db"]["name"] = "wdb"

default["wordpress"]["sql"]["path"] = "/tmp"
default["wordpress"]["sql"]["name"] = "create-wordpress.sql"
default["wordpress"]["sql"]["erb"] = "create-wordpress.sql.erb"

default["wordpress"]["wp-config"]["name"] = "wp-config.php"
default["wordpress"]["wp-config"]["erb"] = "wp-config.php.erb"