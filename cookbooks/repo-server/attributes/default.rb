#
# Cookbook Name:: repo-server
# Recipe:: attributes/default.rb
#

default["repo-server"]["rpm-package"] = "/tmp/nginx-1.7.10-1.el6.ngx.x86_64.rpm"

default["repo-server"]["shell"] = "/usr/local/bin/rsync-centos-yum-mirror.sh"
default["repo-server"]["source"] = "rsync://rsync.kddilabs.jp/centos/"
default["repo-server"]["dastination"] = "/usr/share/nginx/html/packages/centos/"
default["repo-server"]["log"] = "/var/log/rsync/rsync-centos-yum-mirror.log"

default["repo-server"]["directories"] = [
  "/usr/share/nginx/html/packages",
  "/usr/share/nginx/html/packages/chef",
  "/usr/share/nginx/html/packages/chef/bootstrap",
  "/usr/share/nginx/html/packages/chef/gems",
  "/usr/share/nginx/html/packages/chef/packages",
  "/usr/share/nginx/html/packages/mackerel",
  "#{default["repo-server"]["dastination"]}",
  "/usr/share/nginx/html/packages/oracle",
  "/var/log/rsync"
]

if "#{node["hostname"][-1]}" == "1"
  default["repo-server"]["rsync"]["first"] = true
  default["repo-server"]["cron"]["interval"] = "10 2 1-31/2 * *"
else
  default["repo-server"]["rsync"]["first"] = false
  default["repo-server"]["cron"]["interval"] = "10 2 2-31/2 * *"
end
