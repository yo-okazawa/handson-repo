# 1.COOKBOOK[httpd]を修正する
- 1-1.[fileリソースを使用して必要なファイルを設置する](#)
- 1-2.[templateリソースを使用してhttpd.confを設置する](#)
- 1-3.[attributesを利用する](#)

# 2.複数のCOOKBOOKを使用する
- 2-1.[COOKBOOK[iptables]を作成する](#)
- 2-2.[COOKBOOK間の依存を定義する](#)

# 3.複数のOSに対応させる
- 3-1.[ubuntuのBOXファイルとchef-clientを取得する](#)
- 3-2.[COOKBOOK[httpd]をubuntuに対応させる](#)

# 4.TIPS
- 4-1.[executeリソース使用時に冪等性を持たせる](#)
- 4-2.[同じリソースを複数回使う時の記述方法](#)

---

# 1.COOKBOOK[httpd]を修正する

---

## 1-1.[cookbook_file](http://docs.chef.io/resources.html#cookbook-file)リソースを使用して必要なファイルを設置する  

前回作成したCOOKBOOK[httpd]のfileリソースは以下のようになっています。

```
file "/var/www/html/index.html" do
  content "<html>
  <body>
    <h1>hello world</h1>
  </body>
</html>"
end
```

短いファイルであれば、今のままで問題ありませんが、長いファイルやバイナリファイルを扱う場合には、[cookbook_file](http://docs.chef.io/resources.html#cookbook-file)リソースを使用して、以下のように記述します。

```
cookbook_file "index.html" do
  path "/var/www/html/index.html"
  action :create
end
```

COOKBOOKのfiles/default配下にcookbook_fileリソースで指定したファイル名（index.html）のファイルを用意しておきます。

```
<html>
  <body>
    <h1>hello world</h1>
  </body>
</html>
```

仮想サーバを起動して確認してみます。

```
$ vagrant up
$ vagrant ssh
[vagrant@test02 ~]$ ls /var/www/html/
[vagrant@test02 ~]$ cat /var/www/html/index.html
```

---

## 1-2.[template](http://docs.chef.io/resources.html#template)リソースを使用してWEBページを設置する

COOKBOOK[httpd]のrecipeに以下を追加します。

```
template "/var/www/html/template.html" do
  source "template.html.erb"
  action :create
end
```

COOKBOOKのtemplates/default配下にtemplateリソースのsourceで指定したファイル名（template.html.erb）のファイルを用意しておきます。  
> [ohai](https://docs.chef.io/ohai.html)が収集した仮想サーバの情報を表示させてみます。

```
<html>
  <body>
    <h1>template.html</h1>
    <p>HOSTNAME = <%= node["hostname"] %></p>
    <p>IPaddress = <%= node["ipaddress"] %></p>
    <p>MACaddress = <%= node["macaddress"] %></p>
  </body>
</html>
```

仮想サーバを起動して確認してみます。

```
$ vagrant up
$ vagrant ssh
[vagrant@test02 ~]$ ls /var/www/html/
[vagrant@test02 ~]$ cat /var/www/html/template.html
```

ブラウザから(http://localhost:8080/template.html)に接続して確認してみます。

---

## 1-3.[attributes](https://docs.chef.io/attributes.html)を利用する。  
COOKBOOK内で共通利用する変数はattributesに記述しておくと、変更があった時に便利です。  
以下では例としてhttpdのドキュメントルートをattributesに定義して利用します。

httpd.confをtemplateリソースで生成するため、元となるファイルを取得してきます。

```
[vagrant@test02 ~]$ cp /etc/httpd/conf/httpd.conf /vagrant/
```

vagrantディレクトリ配下のhttpd.confをCOOKBOOKのtemplates/defaults/配下にhttpd.conf.erbというファイル名で保存します。

httpd.conf.erb内のDocumentRoot "/var/www/html"の部分を以下のように変更します。

```
- DocumentRoot "/var/www/html"
+ DocumentRoot "<%= node["httpd"]["document_root"] %>"
```

COOKBOOKのattributesディレクトリの配下にdefault.rbを作成して、以下のように編集します。

```
default["httpd"]["document_root"] = "/var/www/html2"
```

以下のようにrecipeを修正します。  
> ドキュメントルートのディレクトリを生成([directory](http://docs.chef.io/resources.html#directory)リソースを使用)  
> httpd.confを配置  
> htmlファイルの生成先を変更

```
package "httpd" do
  action :install
end
service "httpd" do
  action [:enable, :start]
end
directory node["httpd"]["document_root"] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
template "/etc/httpd/conf/httpd.conf" do
  source "httpd.conf.erb"
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  notifies :restart, 'service[httpd]', :immediately
end
cookbook_file "index.html" do
  path "#{node["httpd"]["document_root"]}/index.html"
  action :create
end
template "#{node["httpd"]["document_root"]}/template.html" do
  source "template.html.erb"
  action :create
end
```

recipeを適用して確認してみます。

```
$ vagrant destroy
$ vagrant up
$ vagrant ssh
[vagrant@test02 ~]$ cat /etc/httpd/conf/httpd.conf | grep DocumentRoot
[vagrant@test02 ~]$ ls -l /var/www/
[vagrant@test02 ~]$ ls -l /var/www/html2
```

ブラウザから(http://localhost:8080/template.html)に接続して確認してみます。

---

# 2.複数のCOOKBOOKを使用する

---

## 2-1.COOKBOOK[iptables]を作成する  
knifeコマンドでCOOKBOOKを生成します。

```
$ cd ../chef-repo
$ knife cookbook create iptables -o cookbooks
```

COOKBOOK[iptables]で設定する内容は以下です。
> iptabesパッケージをインストール  
> iptablesを有効化  
> /etc/sysconfig/iptablesを配置(変更があったらiptablesを再起動)

*** recipes/defaults.rb ***

```
package "iptables" do
  action :install
end
service "iptables" do
  action [:enable]
end
cookbook_file "iptables" do
  path ""
  action :create
  notifies :restart, "service[iptables]", :immediately
end
```

*** files/default/iptables ***

```
*filter
:INPUT DROP [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [6:432]
-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT 
-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT 
-A INPUT -s 127.0.0.1/32 -d 127.0.0.1/32 -j ACCEPT 
-A OUTPUT -s 127.0.0.1/32 -d 127.0.0.1/32 -j ACCEPT 
COMMIT
```
> COMMITの行は改行が必要です。

---

## 2-2.COOKBOOK間の依存を定義する  
COOKBOOK[httpd]が実行された時にCOOKBOOK[iptables]も実行されるようにします。

COOKBOOK[httpd]のmetadata.rbに以下の行を追記します。

*** metadata.rb ***

```
depends 'iptables'
```

COOKBOOK[httpd]のrecipe/default.rbに以下の行を追記します。

```
include_recipe 'iptables'
```

仮想サーバを起動してCOOKBOOK[iptables]が適用されているか確認してみます。

```
$ vagrant destroy
$ vagrant up
$ vagrant ssh
[vagrant@test01 ~]$ sudo service iptables status
```

> COOKBOOK[iptables]で指定したルールが表示されるはずです。

---

# 3.複数のOSに対応させる

---

3-1.ubuntuのBOXファイルとchef-clientを取得する

---

3-1-1.[こちら](http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box)からboxをダウンロードして保存して下さい。（どうしても遅い時は[こちら](https://119.81.145.242/packages/chef/boxes/opscode_ubuntu-12.04_chef-provisionerless.box)）  
ターミナル(コマンドプロンプト)上で以下のコマンドを実行して、VagrantにダウンロードしたBoxを追加します。  

```
$ vagrant box add ubuntu12 <Boxファイルへのパス>
```

以下のコマンドを実行してBoxが追加されたことを確認します。  

```
$ vagrant box list
centos66 (virtualbox, 0)
ubuntu12 (virtualbox, 0)
```

3-1-2.[こちら](https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef_12.2.1-1_amd64.deb)からchef-clientパッケージをダウンロードして保存して下さい。（どうしても遅い時は[こちら](https://119.81.145.242/packages/chef/packages/chef_12.2.1-1_amd64.deb)）  
chef-studyディレクトリ配下に"vagrant-ubuntu"ディレクトリを作成して、配下にダウンロードしたパッケージを保存しておきます。

3-1-3.chef-study/vagrant-ubuntu配下にVagrantfileを作成しておきます。

*** chef-study/vagrant-ubuntu/Vagrantfile ***

```
 # -*- mode: ruby -*-
 # vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box_check_update = false
  config.vm.box = "ubuntu12"
  config.vm.hostname = "test02"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provision "shell", inline: <<-SHELL
    chef_check=`dpkg -l | grep -e "chef\s*12.2.1-1" | wc -l`
    if [ $chef_check -eq 0 ] ; then
      cp /vagrant/chef_12.2.1-1_amd64.deb /tmp/chef_12.2.1-1_amd64.deb
      sudo dpkg -i /tmp/chef_12.2.1-1_amd64.deb
    fi
  SHELL
  config.vm.provision "chef_zero" do |chef|
    chef.cookbooks_path = ["../chef-repo/site-cookbooks"]
    chef.add_recipe "httpd"
  end
end
```

3-1-4.仮想サーバを起動してみます。

```
$ vagrant up
```

> OSは起動しますが、COOKBOOK[httpd]の適用に失敗します。

---

## 3-2.COOKBOOK[httpd]をubuntuに対応させる  
COOKBOOK[httpd]をcentosに適用しても、ubuntuに適用しても同じ結果が得られるように修正します。

COOKBOOK[httpd]を修正する際にドキュメントルートの設定ファイルが必要になるため、先に手動でapache2をインストールして、defaultを取得しておきます。

```
$ vagrant ssh
$ sudo apt-get update
$ sudo apt-get install apache2
$ cp /etc/apache2/sites-available/default /vagrant/default
```

取得したdefaultをchef-repo/site-cookbooks/httpd/templates/default/default.erbに保存して以下のように修正します。

```
- DocumentRoot /var/www
+ DocumentRoot <%= node["httpd"]["document_root"] %>
```

COOKBOOK[httpd]を以下のように修正します。

*** attributes/default.rb ***

```
default["httpd"]["document_root"] = "/var/www/html2"

case node["platform"]
when "ubuntu"
  default["httpd"]["package"] = "apache2"
  default["httpd"]["conf"] = "/etc/apache2/sites-available/default"
  default["httpd"]["conf_source"] = "default.erb"
when "centos"
  default["httpd"]["package"] = "httpd"
  default["httpd"]["conf"] = "/etc/httpd/conf/httpd.conf"
  default["httpd"]["conf_source"] = "httpd.conf.erb"
end
```

*** recipe/default.rb ***

```
execute "apt-get update" if node["platform"] == "ubuntu"
package node["httpd"]["package"] do
  action :install
end
service node["httpd"]["package"] do
  action [:enable, :start]
end
directory node["httpd"]["document_root"] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
template node["httpd"]["conf"] do
  source node["httpd"]["conf_source"]
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  notifies :restart, "service[#{node["httpd"]["package"]}]", :immediately
end
cookbook_file "index.html" do
  path "#{node["httpd"]["document_root"]}/index.html"
  action :create
end
template "#{node["httpd"]["document_root"]}/template.html" do
  source "template.html.erb"
  action :create
end

include_recipe 'iptables' if node["platform"] == "centos"
```

*** templates/default/template.html.erb ***

```
<html>
  <body>
    <h1>template.html</h1>hostname
    <p>PLATFORM = <%= node["platform"] %></p>
    <p>HOSTNAME = <%= node["hostname"] %></p>
    <p>IPaddress = <%= node["ipaddress"] %></p>
    <p>MACaddress = <%= node["macaddress"] %></p>
  </body>
</html>
```

ubuntuに対応させるためにrecipeを修正した点は以下

- attributeでOSによって異なる値を設定
- ubuntuの場合は初回apt-getの前にapt-get updateを実行
- ubuntuの場合はCOOKBOOK[iptables]を実行しないように設定
- template.html.erbをPLATFORMも表示するように変更

仮想サーバを起動してrecipeを適用してみます。

```
$ vagrant destroy
$ vagrant up
$ vagrant ssh
vagrant@test02:~$ service apache2 status
vagrant@test02:~$ cat /etc/apache2/sites-available/default
vagrant@test02:~$ ls /var/www/html2/
```

ブラウザから(http://localhost:8080/template.html)に接続して確認してみます。

---

# 4.TIPS

---

## 4-1.executeリソース使用時に冪等性を持たせる

test用にCOOKBOOKを作成します。

```bash
$ knife cookbook create test -o site-cookbooks
```

*** site-cookbooks/test/recipe/test01.rb ***

```ruby
execute "add hosts" do
  command "echo '8.8.8.8  google-dns' >> /etc/hosts"
end
```

vagrantフォルダのVagrantfileを編集しておきます。

```ruby
- chef.add_recipe "httpd"
+ chef.add_recipe "test::test01"
```

作成したrecipeを適用します。

```bash
$ cd ../vagrant
$ vagrant up
$ vagrant ssh
[vagrant@test01 ~]$ cat /etc/hosts
[vagrant@test01 ~]$ ping google-dns
[vagrant@test01 ~]$ exit
```

今の状態でもう一度recipeを適用してみます。

```bash
$ vagrant provision
$ vagrant ssh
[vagrant@test01 ~]$ cat /etc/hosts
[vagrant@test01 ~]$ exit
```

既にhostsに書き込まれていた場合には、追記しないようにrecipeを修正します。

*** site-cookbooks/test/recipe/test01.rb ***

```ruby
execute "add hosts" do
  command "echo '8.8.8.8  google-dns' >> /etc/hosts"
  not_if "grep '8\.8\.8\.8\s*google-dns' /etc/hosts"
end
```
もう一度recipeを適用してみます。

```bash
$ vagrant provision
$ vagrant ssh
[vagrant@test01 ~]$ cat /etc/hosts
[vagrant@test01 ~]$ exit
```

## 4-2.同じリソースを複数回使う時の記述方法

---

5人のユーザーを作成するrecipeを作成します。

*** site-cookbooks/test/recipe/test02.rb ***

```ruby
user "user1" do
  action :create
end
user "user2" do
  action :create
end
user "user3" do
  action :create
end
user "user4" do
  action :create
end
user "user5" do
  action :create
end
```

vagrantフォルダのVagrantfileを編集しておきます。

```ruby
- chef.add_recipe "test::test01"
+ chef.add_recipe "test::test02"
```

作成したrecipeを適用してみます。

```bash
$ vagrant up
$ vagrant ssh
[vagrant@test01 ~]$ cat /etc/passwd
[vagrant@test01 ~]$ exit
```

recipeの記述方法を変更します。

*** site-cookbooks/test/recipe/test02.rb ***

```ruby
%w{ user1 user2 user3 user4 user5 }.each do | target |
  user target do
    action :create
  end
end
```

変更したrecipeを適用してみます。

```bash
$ vagrant destroy
$ vagrant up
$ vagrant ssh
[vagrant@test01 ~]$ cat /etc/passwd
[vagrant@test01 ~]$ exit
```

Attributesを利用して以下のようにしても、同じ結果が得られます。

*** site-cookbooks/test/attributes/default.rb ***

```ruby
default["test"]["user"] = [
  "user1",
  "user2",
  "user3",
  "user4",
  "user5"
]
```

*** site-cookbooks/test/recipe/test02.rb ***

```ruby
node["test"]["user"].each do | target |
  user target do
    action :create
  end
end
```