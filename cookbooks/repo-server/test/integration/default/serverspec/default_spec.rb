require 'spec_helper'

#
#test nginx installed and configuration
#
describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/nginx/nginx.conf') do
  it { should be_file }
  it { should be_mode 644 }
  its(:content) { should match /^\s*error_log\s+\/var\/log\/nginx\/error.log\s+warn;/ }
  its(:content) { should match /^\s*access_log\s+\/var\/log\/nginx\/access.log\s+main;/ }
end

describe file('/etc/nginx/conf.d/repo-server.conf') do
  it { should be_file }
  it { should be_mode 644 }
  its(:content) { should match /^\s*#\s*listen\s+80;/ }
  its(:content) { should match /^\s*listen\s+443\s+ssl\s*;/ }
  its(:content) { should match /^\s*ssl_certificate\s+\/etc\/nginx\/chefrepo.cloud-platform.kddi.ne.jp.crt\s*;/ }
  its(:content) { should match /^\s*ssl_certificate_key\s+\/etc\/nginx\/chefrepo.cloud-platform.kddi.ne.jp.key\s*;/ }
  its(:content) { should match /^\s*root\s+\/usr\/share\/nginx\/html\s*;/ }
  its(:content) { should match /^\s*location\s+\/packages\/oracle\s*{.^\s*auth_basic\s+"Restricted"\s*;.^\s*auth_basic_user_file\s+\/etc\/nginx\/\.htpasswd\s*;/m }
end

describe command('ls /etc/nginx/conf.d/ | grep .*\.conf$ | wc -l') do
  its(:stdout) { should match /1/}
end


#
#test make directories
#
test_directories = [
  "/usr/share/nginx/html/packages",
  "/usr/share/nginx/html/packages/chef",
  "/usr/share/nginx/html/packages/chef/bootstrap",
  "/usr/share/nginx/html/packages/chef/gems",
  "/usr/share/nginx/html/packages/chef/packages",
  "/usr/share/nginx/html/packages/mackerel",
  "/usr/share/nginx/html/packages/centos",
  "/usr/share/nginx/html/packages/oracle",
  "/var/log/rsync",
  "/var/log/wget"
]

test_directories.each do |dir|
  describe file(dir) do
    it { should be_directory }
  end
end


#
#test put files
#
describe file('/etc/nginx/.htpasswd') do
  it { should be_file }
  it { should be_owned_by 'nginx' }
  it { should be_grouped_into 'root' }
  it { should be_mode 600 }
end

describe file('/etc/nginx/chefrepo.cloud-platform.kddi.ne.jp.crt') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
end

describe file('/etc/nginx/chefrepo.cloud-platform.kddi.ne.jp.key') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 600 }
end

describe file('/usr/share/nginx/html/check.html') do
  it { should be_file }
  its(:content) { should match /html-check OK/ }
end

describe file('/usr/local/bin/rsync-centos-yum-mirror.sh') do
  it { should be_file }
  it { should be_mode 744 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/logrotate.d/nginx') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /^\s*rotate\s+180\s*$/ }
end

describe file('/etc/logrotate.d/rsync') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /^\s*rotate\s+180\s*$/ }
end

describe file('/etc/logrotate.d/wget') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /^\s*rotate\s+180\s*$/ }
end


#
#test crontab
#
describe file('/etc/crontab') do
  its(:content) { should match /^10 2.*root sh \/usr\/local\/bin\/rsync-centos-yum-mirror\.sh >> \/var\/log\/rsync/rsync-centos-yum-mirror\.log/ }
  its(:content) { should match /^10 2.*root sh \/usr\/local\/bin\/wget-mackerel-package\.sh >> \/var\/log\/wget/wget-mackerel-package\.log/ }
end


#
#test server action
#
describe command('curl -k https://localhost/check.html') do
  its(:stdout) { should match /html-check OK/ }
end

describe command('curl -k https://localhost/packages/oracle') do
  its(:stdout) { should match /401 Authorization Required/ }
end

#
#test http https port
#
describe port(80) do
  it { should_not be_listening }
end

describe port(443) do
  it { should be_listening }
end
