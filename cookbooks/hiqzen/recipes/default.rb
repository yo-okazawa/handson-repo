#
# Cookbook Name:: hiqzen
# Recipe:: default
#

#rootグループにkfsadminを作成する

user "kfsadmin" do
  gid "root"
  shell "/bin/bash"
  home "/home/kfsadmin"
  action :create
end


#hostsファイルの127.0.0.1の行にサーバのhostnameを記載

hostsfile_entry "127.0.0.1" do
  hostname  "#{node["hostname"]}"
  action :append
end


#言語設定を日本語にする

bash 'locale' do
  user 'root'
  code <<-EOC
cp -p /etc/sysconfig/i18n /etc/sysconfig/i18n.old
cat /etc/sysconfig/i18n.old | sed 's/LANG.*$/LANG="ja_JP.utf8"/' > /etc/sysconfig/i18n
  EOC
  not_if "grep -q ja_JP /etc/sysconfig/i18n"
end


#データストア先のディレクトリを作成(NFSマウントさせる？マウントさせるとしたら、
#attributesに記載してもらわないとマウント出来ない)

directory "/mnt/KFS_STORE" do
  owner "kfsadmin"
  group "root"
  mode "0755"
  action :create
end


#環境変数の設定

node["hiqzen"]["bash_profile"].each do |str|
  bash 'edit .bash_profile' do
    user "kfsadmin"
    code  <<-EOC
cp -f /home/kfsadmin/.bash_profile /home/kfsadmin/.bash_profile.org
sed -e 's/export PATH//g' /home/kfsadmin/.bash_profile.org > /home/kfsadmin/.bash_profile
echo '#{str}' >> /home/kfsadmin/.bash_profile
echo 'export PATH' >> /home/kfsadmin/.bash_profile
source /home/kfsadmin/.bash_profile
    EOC
    not_if "grep '#{str}' /home/kfsadmin/.bash_profile"
  end
end


#/etc/security/limits.confの末尾から2行目に追記する

node["hiqzen"]["limits_conf"].each do |str|
  bash 'edit limits.conf' do
    code  <<-EOC
cp -f /etc/security/limits.conf /etc/security/limits.conf.org
sed -e 's/# End of file//g' /etc/security/limits.conf.org > /etc/security/limits.conf
echo "#{str}" >> /etc/security/limits.conf
echo "# End of file" >> /etc/security/limits.conf
    EOC
    not_if "grep '#{str}' /etc/security/limits.conf"
  end
end


#OSの再起動(ここは保留)

#OpenJDKがインストールされていたら、アンインストールする。
openjdk_rpm = `rpm -qa | grep openjdk`
if (openjdk_rpm) then
  array_openjdk = openjdk_rpm.split("\n")
  array_openjdk.each do |rpm|
    rpm_package "#{rpm}" do
      action :remove
    end
  end
end if


#javaのバージョンを1.7にする
remote_file "/tmp/#{node["hiqzen"]["jdk"]}" do
  source "#{node["hiqzen"]["repo"]}/#{node["hiqzen"]["jdk"]}"
  action :create
end
rpm_package "/tmp/#{node["hiqzen"]["jdk"]}" do
  action :install
end


#glibc.i686をインストール

yum_package "glibc.i686" do
  action :install
end


#expectをインストール

yum_package "expect" do
  action :install
end


#f-secureをインストール(インストール中にエンターしたりするためにexpectスクリプトで実行する。)

remote_file "/tmp/#{node["hiqzen"]["f-secure"]}" do
  source "#{node["hiqzen"]["repo"]}/#{node["hiqzen"]["f-secure"]}"
  action :create
end

execute "deploy_package" do
  cwd "/var"
  command "tar -xzvf /tmp/#{node["hiqzen"]["f-secure"]}"
  not_if { ::File.exists?("/var/f-secure-linux-security-9.20.2520/f-secure-linux-security-9.20.2520-release-notes.txt") }
end

template "/tmp/expect.sh" do
  source "expect.sh.erb"
  mode "0755"
  owner "root"
  group "root"
  action :create
end

execute "install f-secure" do
  command "/tmp/expect.sh"
  not_if { ::File.exists?("/opt/f-secure") }
end


#HiQZenのtarファイルを展開 ディレクトリの所有者はkfsadmin(tar zxvf)

remote_file "/tmp/#{node["hiqzen"]["KFS"]}" do
  source "#{node["hiqzen"]["repo"]}/#{node["hiqzen"]["KFS"]}"
  action :create
end

execute "deploy_package" do
  cwd "/var"
  command "tar -xzvf /tmp/#{node["hiqzen"]["KFS"]}"
  not_if { ::File.exists?("/var/KFS/LICENSE") }
end

execute "chown /var/KFS" do
  command "chown -R kfsadmin:root /var/KFS"
end

#/var/KFS/conf/proself.propertiesのproself.public.host= http://XXX.XXX.XXX.XXX:8080

template "/var/KFS/conf/proself.properties" do
  source "proself.properties.erb"
  mode "0644"
  owner "kfsadmin"
  group "root"
  action :create
end

#start.sh実行

bash "install KFS" do
  user "kfsadmin"
code  <<-EOC
source /home/kfsadmin/.bash_profile
/var/KFS/bin/startup.sh
    EOC
end