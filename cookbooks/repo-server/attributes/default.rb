#
# Cookbook Name:: repo-server
# Recipe:: attributes/default.rb
#

default["repo-server"]["nginx"]["package"] =   "nginx-1.7.10-1.el6.ngx.x86_64.rpm"
default["repo-server"]["nginx"]["source"] =   "http://nginx.org/packages/mainline/rhel/6/x86_64/RPMS"
default["repo-server"]["document-root"] = "/usr/share/nginx/html"
default["repo-server"]["shell"]["path"] = "/usr/local/bin"

default["repo-server"]["centos"]["shell"] =         "rsync-centos-yum-mirror.sh"
default["repo-server"]["centos"]["source"] =        "rsync://rsync.kddilabs.jp/centos/"
default["repo-server"]["centos"]["dastination"] =   "#{default["repo-server"]["document-root"]}/packages/centos/"
default["repo-server"]["centos"]["log-directory"] = "/var/log/rsync"
default["repo-server"]["centos"]["log"] =           "rsync-centos-yum-mirror.log"

default["repo-server"]["mackerel"]["log-directory"] = "/var/log/mackerel"
default["repo-server"]["mackerel"]["dastination"] =   "#{default["repo-server"]["document-root"]}/packages/mackerel"
default["repo-server"]["mackerel"]["gpg-url"] =   "https://mackerel.io/assets/files/GPG-KEY-mackerel"

if "#{node["hostname"][0, 3]}" == "ck2"
  default["repo-server"]["mackerel"]["yum-url"] =     "http://repo-kcps.mackerel.io/yum/centos"
  default["repo-server"]["mackerel-rpm"]["source"] =  "http://repo-kcps.mackerel.io/file/rpm"
  default["repo-server"]["mackerel-rpm"]["package"] = "mackerel-agent-kcps-latest.noarch.rpm"
  default["repo-server"]["mackerel-msi"]["source"] =  "http://repo-kcps.mackerel.io/file/msi"
  default["repo-server"]["mackerel-msi"]["package"] = "mackerel-agent-latest-kcps.msi"
  default["repo-server"]["mackerel-tgz"]["source"] =  "http://repo-kcps.mackerel.io/file/tgz"
  default["repo-server"]["mackerel-tgz"]["package"] = "mackerel-agent-latest.tar.gz"
else
  default["repo-server"]["mackerel"]["yum-url"] =     "http://yum.mackerel.io/centos"
  default["repo-server"]["mackerel-rpm"]["source"] =  "http://file.mackerel.io/agent/rpm"
  default["repo-server"]["mackerel-rpm"]["package"] = "mackerel-agent-latest.noarch.rpm"
  default["repo-server"]["mackerel-msi"]["source"] =  "http://file.mackerel.io/agent/msi"
  default["repo-server"]["mackerel-msi"]["package"] = "mackerel-agent-latest.msi"
  default["repo-server"]["mackerel-tgz"]["source"] =  "http://file.mackerel.io/agent/tgz"
  default["repo-server"]["mackerel-tgz"]["package"] = "mackerel-agent-latest.tar.gz"
end

default["repo-server"]["mackerel-rpm"]["shell"] =         "get-mackerel-rpm.sh"
default["repo-server"]["mackerel-rpm"]["dastination"] =   "#{default["repo-server"]["mackerel"]["dastination"]}"
default["repo-server"]["mackerel-rpm"]["log-directory"] = "#{default["repo-server"]["mackerel"]["log-directory"]}"
default["repo-server"]["mackerel-rpm"]["log"] =           "get-mackerel-rpm.log"

default["repo-server"]["mackerel-msi"]["shell"] =         "get-mackerel-msi.sh"
default["repo-server"]["mackerel-msi"]["dastination"] =   "#{default["repo-server"]["mackerel"]["dastination"]}"
default["repo-server"]["mackerel-msi"]["log-directory"] = "#{default["repo-server"]["mackerel"]["log-directory"]}"
default["repo-server"]["mackerel-msi"]["log"] =           "get-mackerel-msi.log"

default["repo-server"]["mackerel-tgz"]["shell"] =         "get-mackerel-tgz.sh"
default["repo-server"]["mackerel-tgz"]["dastination"] =   "#{default["repo-server"]["mackerel"]["dastination"]}"
default["repo-server"]["mackerel-tgz"]["log-directory"] = "#{default["repo-server"]["mackerel"]["log-directory"]}"
default["repo-server"]["mackerel-tgz"]["log"] =           "get-mackerel-tgz.log"

default["repo-server"]["mackerel-yum"]["shell"] =         "reposync-mackerel.sh"
default["repo-server"]["mackerel-yum"]["dastination"] =   "#{default["repo-server"]["document-root"]}/packages/yum_mackerel"
default["repo-server"]["mackerel-yum"]["log-directory"] = "#{default["repo-server"]["mackerel"]["log-directory"]}"
default["repo-server"]["mackerel-yum"]["log"] =           "reposync-mackerel.log"

default["repo-server"]["mackerel-set"]["shell"] =         "setup-yum.sh"

default["repo-server"]["backup"]["shell"] =         "rsync-local-backup.sh"
default["repo-server"]["backup"]["source"] =        "#{default["repo-server"]["document-root"]}/packages/chef"
default["repo-server"]["backup"]["destination"] =   "/var/backups"
default["repo-server"]["backup"]["log-directory"] = "/var/log/backups"
default["repo-server"]["backup"]["log"] =           "rsync-local-backup.log"
default["repo-server"]["backup"]["cron"] =          "25 2 * * *"

default["repo-server"]["directories"] = [
  "#{default["repo-server"]["document-root"]}/packages",
  "#{default["repo-server"]["document-root"]}/packages/chef",
  "#{default["repo-server"]["document-root"]}/packages/chef/bootstrap",
  "#{default["repo-server"]["document-root"]}/packages/chef/gems",
  "#{default["repo-server"]["document-root"]}/packages/chef/packages",
  "#{default["repo-server"]["document-root"]}/packages/chef/cookbooks",
  "#{default["repo-server"]["document-root"]}/packages/oracle",
  "#{default["repo-server"]["mackerel"]["log-directory"]}",
  "#{default["repo-server"]["mackerel"]["dastination"]}",
  "#{default["repo-server"]["mackerel-yum"]["dastination"]}",
  "#{default["repo-server"]["centos"]["dastination"]}",
  "#{default["repo-server"]["centos"]["log-directory"]}",
  "#{default["repo-server"]["backup"]["destination"]}",
  "#{default["repo-server"]["backup"]["log-directory"]}"
]

if "#{node["hostname"][-1]}" == "1"
  default["repo-server"]["rsync"]["first"] = true
  default["repo-server"]["mackerel-msi"]["cron"] = "0 2 1-31/2 * *"
  default["repo-server"]["mackerel-tgz"]["cron"] = "5 2 1-31/2 * *"
  default["repo-server"]["mackerel-rpm"]["cron"] = "10 2 1-31/2 * *"
  default["repo-server"]["mackerel-yum"]["cron"] = "15 2 1-31/2 * *"
  default["repo-server"]["centos"]["cron"] =       "20 2 1-31/2 * *"
else
  default["repo-server"]["rsync"]["first"] = false
  default["repo-server"]["mackerel-msi"]["cron"] = "0 2 2-31/2 * *"
  default["repo-server"]["mackerel-tgz"]["cron"] = "5 2 2-31/2 * *"
  default["repo-server"]["mackerel-rpm"]["cron"] = "10 2 2-31/2 * *"
  default["repo-server"]["mackerel-yum"]["cron"] = "15 2 2-31/2 * *"
  default["repo-server"]["centos"]["cron"] =       "20 2 2-31/2 * *"
end
