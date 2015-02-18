#
# Cookbook Name:: repo-server
# Recipe:: attributes/default.rb
#

default["repo-server"]["rpm-package"] = "/tmp/nginx-1.7.10-1.el6.ngx.x86_64.rpm"

default["repo-server"]["shell"] = "/usr/local/bin/rsync-centos-yum-mirror.sh"
default["repo-server"]["packages"] = "/usr/share/nginx/html/packages"
default["repo-server"]["source"] = "rsync://rsync.kddilabs.jp/centos/"
default["repo-server"]["dastination"] = "/usr/share/nginx/html/packages/centos/"
default["repo-server"]["log"] = "/var/log/rsync-centos-yum-mirror.log"

if "#{node["hostname"][-1]}" == "1"
  default["repo-server"]["rsync"]["first"] = true
  default["repo-server"]["cron"]["interval"] = "10 2 1-31/2 * *"
else
  default["repo-server"]["rsync"]["first"] = false
  default["repo-server"]["cron"]["interval"] = "10 2 2-31/2 * *"
end
