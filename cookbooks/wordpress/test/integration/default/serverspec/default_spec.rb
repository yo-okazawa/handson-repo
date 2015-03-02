require 'spec_helper'

#test httpd
describe package('httpd') do
  it { should be_installed }
end

describe service('httpd') do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end


#test mysql
describe package('mysql-server') do
  it { should be_installed }
end

describe service('mysqld') do
  it { should be_enabled }
  it { should be_running }
end

#test php
describe package('php') do
  it { should be_installed }
end


#test wordpress
describe command('mysql -u root -e \'show databases\'') do
  its(:stdout) {should match /.*wdb.*/}
end

describe file('/var/www/html/wdp') do
  it {should be_directory}
end

describe file('/var/www/html/wdp/wp-config.php') do
  it {should be_file}
  its(:content) {should match /define\('DB_NAME', 'wdb'\);/}
  its(:content) {should match /define\('DB_USER',\s*'wdp-user'\);/}
  its(:content) {should match /define\('DB_PASSWORD',\s*'wdp-user'\);/}
  its(:content) {should match /define\('DB_HOST',\s*'localhost'\);/}
  its(:content) {should match /define\('AUTH_KEY',\s*'\w*'\);/}
  its(:content) {should match /define\('SECURE_AUTH_KEY',\s*'\w*'\);/}
  its(:content) {should match /define\('LOGGED_IN_KEY',\s*'\w*'\);/}
  its(:content) {should match /define\('NONCE_KEY',\s*'\w*'\);/}
  its(:content) {should match /define\('SECURE_AUTH_SALT',\s*'\w*'\);/}
  its(:content) {should match /define\('LOGGED_IN_SALT',\s*'\w*'\);/}
  its(:content) {should match /define\('NONCE_SALT',\s*'\w*'\);/}
end

