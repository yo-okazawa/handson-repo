require 'spec_helper'

#test user kfsadmin 
describe user('kfsadmin') do
  it { should exist }
  it { should belong_to_group 'root' }
end


#test /ets/hosts "127.0.0.1 hostname"
describe command('cat /etc/hosts | grep 127.0.0.1 | grep `hostname -s`') do
  its(:stdout) { should match /.+/ }
end


#test Language setting should be in Japanese
describe file('/etc/sysconfig/i18n') do
  its(:content) { should match /LANG="ja_JP.utf8"/ }
end


#test directory /mnt/KFS_STORE
describe file('/mnt/KFS_STORE') do
  it { should be_directory }
  it { should be_owned_by 'kfsadmin' }
  it { should be_grouped_into 'root' }
  it { should be_mode 755 }
end


#test .bash_profile
describe file('/home/kfsadmin/.bash_profile') do
  its(:content) { should match /export JAVA_HOME=\/usr\/java\/default/}
  its(:content) { should match /export PROSELF_STORE=\/mnt\/KFS_STORE/}
  its(:content) { should match /PATH=\$PATH:\$JAVA_HOME\/bin/}
end


#test /etc/security/limits.conf
describe file('/etc/security/limits.conf') do
  its(:content) { should match /kfsadmin hard nofile 8192/}
  its(:content) { should match /kfsadmin soft nofile 8192/}
end


#test openjdk is not installed
describe package('openjdk') do
  it { should_not be_installed }
end


#test jdk-1.7.0 should installed
describe command('rpm -q jdk') do
  its(:stdout) { should match /jdk-1\.7\.0/}
end


#test glibc.i686 should installed
describe command('rpm -q glibc') do
  its(:stdout) { should match /glibc.*i686/}
end


#test expect should installed
describe package('expect') do
  it { should be_installed }
end


#test f-secure should installed
describe command('fsav --version') do
  its(:stdout) { should_not match /command not found/ }
end


#test KFS should expanded
describe file ('/var/KFS/LICENSE') do
  it { should be_file }
  it { should be_owned_by 'kfsadmin' }
  it { should be_grouped_into 'root' }
end


#test KFS proself.properties
describe file('/var/KFS/conf/proself.properties') do
  its(:content) { should match /http:\/\/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:8080/ }
end


#test KFS should started
describe command('/usr/java/default/bin/jps') do
  its(:stdout) { should match /DerbyServer/ }
  its(:stdout) { should match /Bootstrap/ }
  its(:stdout) { should match /Extractor/ }
  its(:stdout) { should match /Jps/ }
end