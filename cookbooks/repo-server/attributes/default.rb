#
# Cookbook Name:: repo-server
# Recipe:: attributes/default.rb
#
default["repo-server"]["packages"] = [
  ["akami-1.2.2.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/a-0.1.1.gem", "233dca77fe5df2ef831943993ae7448963f89027929468622c30767a4e8f2357"],
  ["builder-3.2.2.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/builder-3.2.2.gem", "62fb9ad70ea42219a0c8d209a30281803712c717df7cb8f5ce5f63b4d489d191"],
  ["em-winrm-0.6.0.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/em-winrm-0.6.0.gem", "78a0bb563463bfaa3c2fc8f79c173cfea6f0103cddb9ea1e55a7d18b8e9c1428"],
  ["eventmachine-1.0.3.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/eventmachine-1.0.3.gem", "34424c87fc517f70ba137fe2281d16b53ce9c13f5cbfc2dda3ada56e96a65827"],
  ["ffi-1.9.6.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/ffi-1.9.6.gem", "12fe4dad27e16fa1b9ee664b0ac93b87448ce7c32418bab74fdbdb6cc6087cb2"],
  ["gssapi-1.0.3.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/gssapi-1.0.3.gem", "0b8e5f387b66de7cc43108242f3d3c20bd34eaef352ae7556a04e80b807193d1"],
  ["gyoku-1.2.2.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/gyoku-1.2.2.gem", "b164cd019927b4106e4caa4f1071295818e82913498199dcdbbcb67eaf3d2f11"],
  ["httpclient-2.5.3.3.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/httpclient-2.5.3.3.gem", "bbbf5d6fb34108e8724a3812fdff9ea19bd510e1ff18aebe607255f1de29ada4"],
  ["httpi-0.9.7.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/httpi-0.9.7.gem", "0cbdb3f21f9ebe5927a0bbc1c9830a19ca0bf906a23462193358957e0d5d1e6e"],
  ["knife-push-0.5.2.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/knife-push-0.5.2.gem", "f057921cc525e32d623a1c9ed0526b787954f4e1293cd78effa1bde7e8c850be"],
  ["knife-reporting-0.4.1.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/knife-reporting-0.4.1.gem", "9012b0fa78cc7976caf8c697372f1aeb5195e60792bda3b7b6bf94bb8163af40"],
  ["knife-windows-0.8.2.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/knife-windows-0.8.2.gem", "d80b8236a3c47f3a5dca1c655af3fc672de07397ac762b5f5c48b1760ebfce5e"],
  ["little-plugger-1.1.3.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/little-plugger-1.1.3.gem", "d7a3a4582a00ff65955eeded02c6d127f3858f4e101e2fe4c795c7423dd83d33"],
  ["logging-1.8.2.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/logging-1.8.2.gem", "d7204b5ebacdf44756c1358b24ac78da39f63f5e6bfe0b6ffad0393de69d8c6d"],
  ["mini_portile-0.6.1.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/mini_portile-0.6.1.gem", "7434cd632cfcf6bfd680cd72bec9e17788b1d28d2f6d50504b5969822681ea1d"],
  ["mixlib-cli-1.5.0.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/mixlib-cli-1.5.0.gem", "6082fe0d511c6b1e0be4b56e771fab9a3815fc7d30996dc1cf5f99239f95a646"],
  ["mixlib-log-1.6.0.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/mixlib-log-1.6.0.gem", "a2a6bd7d5a245b919c3914788951f65ad7ba6d37d2b0c78a2550dfe1577774f5"],
  ["multi_json-1.10.1.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/multi_json-1.10.1.gem", "2c98979877e87df0b338ebf5c86091b390f53d62c11a8232bd51ca007e0b82d2"],
  ["nokogiri-1.6.5.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/nokogiri-1.6.5.gem", "f448c4e37442bf03b759c0e936ccffb498fde433ffdd670f3b9754a09cf9bdf6"],
  ["nori-1.1.5.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/nori-1.1.5.gem", "d8b58ae79e53c96d22256d6caf51ab1396076282150d4cade6d4b565b6615988"],
  ["rack-1.6.0.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/rack-1.6.0.gem", "6b6941d48013bc605538fc453006a9df18114ddf0757a3cd69cfbd5c3b72a7b8"],
  ["rubyntlm-0.1.1.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/rubyntlm-0.1.1.gem", "a07b9bacc0cf531c76d4f71ed0813b4055fe881447aede2bc7cd7e89ec808870"],
  ["savon-0.9.5.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/savon-0.9.5.gem", "7dd3b205566943894289fad64e45f96fa5f22f23f235148120c1078722137a50"],
  ["uuidtools-2.1.5.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/uuidtools-2.1.5.gem", "af6c85f2fca731cbf45ebc55b96bf5c94d0d46663dfc4a7d32f2db9c65c05b7e"],
  ["wasabi-1.0.0.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/wasabi-1.0.0.gem", "d69b459cc05dcc9e842e66d19bf6e272c8f130336fb2df79813ba40ee337c4f3"],
  ["winrm-1.2.0.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/winrm-1.2.0.gem", "c3844eb8153c11cb1a1c1b268856fd1614a40738881235ff06383ad69c268f5c"],
  ["winrm-s-0.2.2.gem", "/packages/chef/gems", "https://rubygems.global.ssl.fastly.net/gems/winrm-s-0.2.2.gem", "30006b6ae3b16c0b6a8916c2765310fa2feba612cd96e8e2fc06b34d626fdc9f"],
  ["chef-12.0.3-1.x86_64.rpm", "/packages/chef/packages", "https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-12.0.3-1.x86_64.rpm", "0ec6162b9d0ca2b2016ff02781d84905f712d64c7a81d01b0df88f977832f310"],
  ["chef-client-12.0.3-1.msi", "/packages/chef/packages", "https://opscode-omnibus-packages.s3.amazonaws.com/windows/2008r2/x86_64/chef-client-12.0.3-1.msi", "0f42d147492897d32e295d4cd82d6ef57b87321b6cfba9becac601a8f238d3dc"],
  ["chef-server-core-12.0.5-1.el6.x86_64.rpm", "/packages/chef/packages", "https://web-dl.packagecloud.io/chef/stable/packages/el/6/chef-server-core-12.0.5-1.el6.x86_64.rpm", "ccdd4a9bf0a5eebec0f3e46785d3b86113debb44dbb3ab94677be49ba4798e26"],
  ["drbd84-utils-8.9.1-1.el6.elrepo.x86_64.rpm", "/packages/chef/packages", "http://ftp.osuosl.org/pub/elrepo/elrepo/el6/x86_64/RPMS/drbd84-utils-8.9.1-1.el6.elrepo.x86_64.rpm", "8cf2189f31ca619ddef8cc4f7faf49e5b99793abba35378189b5fbba1b71b3d3"],
  ["kmod-drbd84-8.4.5-2.el6.elrepo.x86_64.rpm", "/packages/chef/packages", "http://ftp.osuosl.org/pub/elrepo/elrepo/el6/x86_64/RPMS/kmod-drbd84-8.4.5-2.el6.elrepo.x86_64.rpm", "388e5478c3606ec84e16122c047017ef89f5667c4c18dfdfa5e34f9c7a65d240"],
  ["opscode-analytics-1.1.1-1.x86_64.rpm", "/packages/chef/packages", "https://web-dl.packagecloud.io/chef/stable/packages/el/6/opscode-analytics-1.1.1-1.x86_64.rpm", "1fae8a0418c5460b30daeb9ad5b580bc2d2c5bd3ff158c18ec1a808d319e33ef"],
  ["opscode-manage-1.11.1-1.el5.x86_64.rpm", "/packages/chef/packages", "https://web-dl.packagecloud.io/chef/stable/packages/el/6/opscode-manage-1.11.1-1.el5.x86_64.rpm", "3c311eb449177ff462d25b42e52f570781fc72f7508481b8befd7bf4d981fab3"],
  ["opscode-push-jobs-client-1.1.5-1.el6.x86_64.rpm", "/packages/chef/packages", "https://opscode-private-chef.s3.amazonaws.com/el/6/x86_64/opscode-push-jobs-client-1.1.5-1.el6.x86_64.rpm", "f5e6be32f60b689e999dcdceb102371a4ab21e5a1bb6fb69ff4b2243a7185d84"],
  ["opscode-push-jobs-client-windows-1.1.5-1.windows.msi", "/packages/chef/packages", "https://opscode-private-chef.s3.amazonaws.com/windows/2008r2/x86_64/opscode-push-jobs-client-windows-1.1.5-1.windows.msi", "411520e6a2e3038cd018ffacee0e76e37e7badd1aa84de03f5469c19e8d6c576"],
  ["opscode-push-jobs-server-1.1.6-1.x86_64.rpm", "/packages/chef/packages", "https://web-dl.packagecloud.io/chef/stable/packages/el/6/opscode-push-jobs-server-1.1.6-1.x86_64.rpm", "8377efdb563dc86d77968fdb42d9772a8b367f7083a399c8063975cbc1f393e1"],
  ["opscode-reporting-1.2.3-1.x86_64.rpm", "/packages/chef/packages", "https://web-dl.packagecloud.io/chef/stable/packages/el/6/opscode-reporting-1.2.3-1.x86_64.rpm", "bcdc08f6d0edfc979dda4469184045494933da9e5f45f4eab8e86117a5ab4385"],
  ["wordpress-4.1.tar.gz", "/packages/chef/packages", "http://wordpress.org/wordpress-4.1.tar.gz", "3743d82698571903382dc223940e712f7bb5cfd20cedba7b7c32c97d470defab"]
]

default["repo-server"]["rpm-package"] =   "/tmp/nginx-1.7.10-1.el6.ngx.x86_64.rpm"
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

default["repo-server"]["mackerel-rpm"]["shell"] =         "get-mackerel-rpm.sh"
default["repo-server"]["mackerel-rpm"]["source"] =        "http://file.mackerel.io/agent/rpm"
default["repo-server"]["mackerel-rpm"]["dastination"] =   "#{default["repo-server"]["mackerel"]["dastination"]}"
default["repo-server"]["mackerel-rpm"]["package"] =       "mackerel-agent-latest.noarch.rpm"
default["repo-server"]["mackerel-rpm"]["log-directory"] = "#{default["repo-server"]["mackerel"]["log-directory"]}"
default["repo-server"]["mackerel-rpm"]["log"] =           "get-mackerel-rpm.log"

default["repo-server"]["mackerel-msi"]["shell"] =         "get-mackerel-msi.sh"
default["repo-server"]["mackerel-msi"]["source"] =        "http://file.mackerel.io/agent/msi"
default["repo-server"]["mackerel-msi"]["dastination"] =   "#{default["repo-server"]["mackerel"]["dastination"]}"
default["repo-server"]["mackerel-msi"]["package"] =       "mackerel-agent-latest.msi"
default["repo-server"]["mackerel-msi"]["log-directory"] = "#{default["repo-server"]["mackerel"]["log-directory"]}"
default["repo-server"]["mackerel-msi"]["log"] =           "get-mackerel-msi.log"

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
default["repo-server"]["backup"]["cron"] =          "20 2 * * *"

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
  default["repo-server"]["mackerel-rpm"]["cron"] = "5 2 1-31/2 * *"
  default["repo-server"]["mackerel-yum"]["cron"] = "10 2 1-31/2 * *"
  default["repo-server"]["centos"]["cron"] =       "15 2 1-31/2 * *"
else
  default["repo-server"]["rsync"]["first"] = false
  default["repo-server"]["mackerel-msi"]["cron"] = "0 2 2-31/2 * *"
  default["repo-server"]["mackerel-rpm"]["cron"] = "5 2 2-31/2 * *"
  default["repo-server"]["mackerel-yum"]["cron"] = "10 2 2-31/2 * *"
  default["repo-server"]["centos"]["cron"] =       "15 2 2-31/2 * *"
end
