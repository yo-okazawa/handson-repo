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

