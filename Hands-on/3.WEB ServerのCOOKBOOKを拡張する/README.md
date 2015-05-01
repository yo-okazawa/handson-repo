# 1.COOKBOOK[httpd]を修正する
- 1-1.[fileリソースを使用して必要なファイルを設置する](#)
- 1-2.[templateリソースを使用してhttpd.confを設置する](#)
- 1-3.[attributesを利用する](#)

# 2.複数のCOOKBOOKを使用する
- 2-1.[COOKBOOK[iptables]を作成する](#)

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

ブラウザから確認するためにVagrantfileに以下の設定を追加しておきます。

```
config.vm.network "forwarded_port", guest: 80, host: 8080
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



