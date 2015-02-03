#
# Cookbook Name:: repo-server
# Recipe:: attributes/default.rb
#

default["repo-server"]["rpm-package"] = "/tmp/nginx-1.7.9-1.el6.ngx.x86_64.rpm"

default["repo-server"]["shell"] = "/usr/local/bin/rsync-centos-yum-mirror.sh"
default["repo-server"]["source"] = "rsync://rsync.kddilabs.jp/centos/"
default["repo-server"]["dastination"] = "/usr/share/nginx/html/centos/"
default["repo-server"]["log"] = "/var/log/rsync-centos-yum-mirror.log"
