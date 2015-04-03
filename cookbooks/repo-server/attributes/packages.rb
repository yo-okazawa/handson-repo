#
# Cookbook Name:: repo-server
# Recipe:: attributes/packages.rb
#

default["repo-server"]["packages_dir"] = "/usr/share/nginx/html/packages/chef/packages"

default["repo-server"]["packages"] = [
  ["nginx-1.7.10-1.el6.ngx.x86_64.rpm", "http://nginx.org/packages/mainline/rhel/6/x86_64/RPMS"],
  ["nginx-1.7.11-1.el6.ngx.x86_64.rpm", "http://nginx.org/packages/mainline/rhel/6/x86_64/RPMS"],
  ["chef-12.2.1-1.el6.x86_64.rpm", "https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64"],
  ["chef-client-12.2.1-1.msi", "https://opscode-omnibus-packages.s3.amazonaws.com/windows/2008r2/x86_64"],
  ["kmod-drbd84-8.4.5-2.el6.elrepo.x86_64.rpm", "http://ftp.osuosl.org/pub/elrepo/elrepo/el6/x86_64/RPMS"],
  ["drbd84-utils-8.9.1-1.el6.elrepo.x86_64.rpm", "http://ftp.osuosl.org/pub/elrepo/elrepo/el6/x86_64/RPMS"],
  ["chef-server-core-12.0.7-1.el6.x86_64.rpm", "https://web-dl.packagecloud.io/chef/stable/packages/el/6"],
  ["opscode-reporting-1.3.0-1.el6.x86_64.rpm", "https://web-dl.packagecloud.io/chef/stable/packages/el/6"],
  ["opscode-push-jobs-server-1.1.6-1.x86_64.rpm", "https://web-dl.packagecloud.io/chef/stable/packages/el/6"],
  ["opscode-manage-1.11.4-1.el5.x86_64.rpm", "https://web-dl.packagecloud.io/chef/stable/packages/el/6"],
  ["opscode-analytics-1.1.2-1.el6.x86_64.rpm", "https://web-dl.packagecloud.io/chef/stable/packages/el/6"],
  ["opscode-push-jobs-client-1.1.5-1.el6.x86_64.rpm", "https://opscode-private-chef.s3.amazonaws.com/el/6/x86_64"],
  ["opscode-push-jobs-client-windows-1.1.5-1.windows.msi", "https://opscode-private-chef.s3.amazonaws.com/windows/2008r2/x86_64"]
]

default["repo-server"]["other_packages_dir"] = "/usr/share/nginx/html/packages/chef/packages"

default["repo-server"]["other_packages"] = [
  ["runit-2.1.1.rpm", "http://119.81.145.242/packages/chef/packages"],
  ["f-secure-linux-security-9.20.2520.tar.gz", "http://119.81.145.242/packages/chef/packages"],
  ["jdk-7u71-linux-x64.rpm", "http://119.81.145.242/packages/chef/packages"],
  ["KFS_20150122.tar.gz", "http://119.81.145.242/packages/chef/packages"],
  ["SQLEXPR_x64_JPN.exe", "http://119.81.145.242/packages/chef/packages"],
  ["wordpress-4.1.tar.gz", "http://119.81.145.242/packages/chef/packages"]
]

default["repo-server"]["gem_dir"] = "/usr/share/nginx/html/packages/chef/gems"

default["repo-server"]["gems"] = [
  ["inifile", "2.0.2"],
  ["ipaddress", "0.8.0"],
  ["eventmachine", "1.0.7"],
  ["pry", "0.10.1"],
  ["net-ssh-multi", "1.2.0"],
  ["net-scp", "1.2.1"],
  ["gssapi", "1.0.3"],
  ["little-plugger", "1.1.3"],
  ["rspec-mocks", "3.2.1"],
  ["chef-provisioning-ssh", "0.0.6"],
  ["multi_json", "1.11.0"],
  ["chef-analytics", "0.1.0"],
  ["cheffish", "0.10"],
  ["serverspec", "2.14.0"],
  ["httpi", "0.9.7"],
  ["httpclient", "2.6.0.1"],
  ["mixlib-log", "1.6.0"],
  ["rspec-expectations", "3.2.0"],
  ["builder", "3.2.2"],
  ["rspec", "3.2.0"],
  ["rspec_junit_formatter", "0.2.0"],
  ["em-winrm", "0.6.0"],
  ["hashie", "2.1.2"],
  ["rspec-its", "1.2.0"],
  ["gyoku", "1.3.0"],
  ["savon", "0.9.5"],
  ["chef", "12.2.1"],
  ["knife-reporting", "0.4.1"],
  ["method_source", "0.8.2"],
  ["chef-provisioning", "0.20.1"],
  ["diff-lcs", "1.2.5"],
  ["mixlib-authentication", "1.3.0"],
  ["winrm-s", "0.2.4"],
  ["winrm", "1.2.0"],
  ["rack", "1.6.0"],
  ["mixlib-cli", "1.5.0"],
  ["slop", "3.6.0"],
  ["rubyntlm", "0.1.1"],
  ["net-ssh", "2.9.2"],
  ["nori", "1.1.5"],
  ["libyajl2", "1.2.0"],
  ["knife-windows", "0.8.4"],
  ["coderay", "1.1.0"],
  ["mime-types", "2.4.3"],
  ["highline", "1.7.1"],
  ["rspec-support", "3.2.2"],
  ["net-ssh-gateway", "1.2.0"],
  ["knife-push", "0.5.2"],
  ["knife-analytics", "0.1.0"],
  ["ffi-yajl", "1.4.0"],
  ["wasabi", "1.0.0"],
  ["erubis", "2.7.0"],
  ["logging", "1.8.2"],
  ["ohai", "8.2.0"],
  ["mini_portile", "0.6.2"],
  ["rake", "10.4.2"],
  ["rspec-core", "3.2.2"],
  ["akami", "1.3.0"],
  ["chef-zero", "4.1.0"],
  ["mixlib-config", "2.1.0"],
  ["ffi", "1.9.8"],
  ["specinfra", "2.28.0"],
  ["plist", "3.1.0"],
  ["nokogiri", "1.6.6.2"],
  ["systemu", "2.6.5"],
  ["wmi-lite", "1.0.0"],
  ["uuidtools", "2.1.5"],
  ["mixlib-shellout", "2.0.1"]
]