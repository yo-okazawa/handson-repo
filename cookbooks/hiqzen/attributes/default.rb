#
# Cookbook Name:: mysql
# Recipe:: attributes/default.rb
#

default["hiqzen"]["bash_profile"] = [
"export JAVA_HOME=/usr/java/default",
"export PROSELF_STORE=/mnt/KFS_STORE",
"PATH=$PATH:$JAVA_HOME/bin"
]

default["hiqzen"]["limits_conf"] = [
"kfsadmin hard nofile 8192",
"kfsadmin soft nofile 8192"
]

default["hiqzen"]["repo"] = "https://chefrepo.cloud-platform.kddi.ne.jp/packages/chef/packages"
default["hiqzen"]["jdk"] = "jdk-7u71-linux-x64.rpm"
default["hiqzen"]["f-secure"] = "f-secure-linux-security-9.20.2520.tar.gz"
default["hiqzen"]["KFS"] = "KFS_20150122.tar.gz"