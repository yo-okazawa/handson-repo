# 1.リポジトリサーバについて

- 1-1.リポジトリサーバの用途
- 1-2.リポジトリサーバを活用したrecipe例

---

# 1.リポジトリサーバについて

---

## 1-1.リポジトリサーバの用途

インターネットに接続出来ないインスタンスに対して、必要なパッケージを提供します。
また、インターネット上に存在しないパッケージやファイルをリポジトリサーバに配置しておいて、利用することが可能です。

![Worktation](https://raw.github.com/wiki/urasoko/handson-repo/images/HandsOn-7-1.png)

> - chef-clientパッケージ

> - 各種ミドルウェアの特定のパッケージ

> - ruby gem

> - CentOSのyumリポジトリミラー

---

## 1-2.リポジトリサーバを活用したrecipe例

リポジトリサーバを活用したrecipeのサンプルとしてwordpressを解説します。

![Worktation](https://raw.github.com/wiki/urasoko/handson-repo/images/HandsOn-7-2.png)

リポジトリサーバを利用している部分

- wordpressのパッケージをリポジトリサーバから取得
- COOKBOOK[yum-repo]でyumのリポジトリとしてリポジトリサーバを登録(CentOSのみ)

以下のコマンドをWorkStation上で実行して、Chef-Server上にあるCOOKBOOK[wordpress]をダウンロードします。

```bash
$ cd /home/<username>/chef-repo
$ knife cookbook list
$ knife cookbook download wordpress
```

ダウンロードされたCOOKBOOKのrecipeを確認します。

*** wordpress/recipes/default.rb ***

```ruby
# COOKBOOK[lamp]を呼び出し(apache,php,mysqlがインストールされる)
include_recipe 'lamp'

# wp-config.phpで使用するキー文字列を生成するメソッド
require 'openssl'
def secure_password(length = 20)
  pw = String.new
  while pw.length < length
    pw << ::OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
  end
  pw
end

# wordpressのパッケージを取得
remote_file "/tmp/#{node["wordpress"]["package"]}" do
  source "#{node["wordpress"]["package-url"]}"
  owner 'root'
  group 'root'
  mode '0644'
end

# wordpressパッケージを展開するディレクトリを作成
directory "#{node["wordpress"]["documentroot"]}/#{node["wordpress"]["wordpressroot"]}/" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# wordpressパッケージを展開
bash 'deploy_package' do
  cwd "/tmp"
  code <<-EOH
    tar -xzvf #{node["wordpress"]["package"]}
    cp -a wordpress/* #{node["wordpress"]["documentroot"]}/#{node["wordpress"]["wordpressroot"]}/
    EOH
  not_if { ::File.exists?("/var/www/html/wdp/index.php") }
end

#キー文字列をnode attributeにセット(初回のみ)
node.set_unless["wordpress"]["keys"]["auth"] = secure_password
node.set_unless["wordpress"]["keys"]["secure_auth"] = secure_password
node.set_unless["wordpress"]["keys"]["logged_in"] = secure_password
node.set_unless["wordpress"]["keys"]["nonce"] = secure_password
node.set_unless["wordpress"]["salt"]["auth"] = secure_password
node.set_unless["wordpress"]["salt"]["secure_auth"] = secure_password
node.set_unless["wordpress"]["salt"]["logged_in"] = secure_password
node.set_unless["wordpress"]["salt"]["nonce"] = secure_password

# wp-config.phpを設置
template "#{node["wordpress"]["documentroot"]}/#{node["wordpress"]["wordpressroot"]}/#{node["wordpress"]["wp-config"]["name"]}" do
  source node["wordpress"]["wp-config"]["erb"]
  owner "root"
  group "root"
  action :create
end

# wordpress用のデータベースとユーザを作成するsqlファイルを実行
execute "create-db" do
  command "mysql < #{node["wordpress"]["sql"]["path"]}/#{node["wordpress"]["sql"]["name"]}"
  action :nothing
end

# wordpress用のデータベースとユーザを作成するsqlファイルを作成
template "#{node["wordpress"]["sql"]["path"]}/#{node["wordpress"]["sql"]["name"]}" do
  source node["wordpress"]["sql"]["erb"]
  owner "root"
  group "root"
  action :create
  notifies :run, "execute[create-db]", :immediately
end
```

*** lamp/recipes/default.rb ***

```ruby
# phpとapacheとmysqlのCOOKBOOKを呼び出し
include_recipe 'php'
include_recipe 'apache'
include_recipe 'mysql'
```

*** php/recipes/default.rb ***

```ruby
# COOKBOOK[yum-repo]を呼び出し
include_recipe 'yum-repo'

# yumでphp関連のパッケージをインストール
node["php"]["packages"].each do |package|
  package "#{package}" do
    action :install
  end
end

# php.iniファイルを作成
template "#{node["php"]["conf-dir"]}/#{node["php"]["conf-file"]}" do
  source "#{node["php"]["template"]}"
  owner "root"
  group "root"
  mode 0644
  action :create
end
```

*** apache/recipes/default.rb ***

```ruby
# COOKBOOK[yum-repo]を呼び出し(lampから呼び出した場合は、COOKBOOK[php]で既に呼び出されているが、単体での利用を考慮して、冒頭で呼び出している)
include_recipe 'yum-repo'

# yumでhttpdパッケージをインストール
package "#{node["apache"]["package"]}" do
  action :install
end

# httpdサービスの自動起動設定と起動
service "httpd" do
  action [ :enable, :start ]
end

# httpd.confファイルの作成,httpd.confファイルに変更があった場合は、httpdサービスを再起動
template "#{node["apache"]["conf-dir"]}/#{node["apache"]["conf-file"]}" do
  source "#{node["apache"]["template"]}"
  owner "root"
  group "root"
  mode 0644
  action :create
  notifies :reload, "service[httpd]"
end
```

*** mysql/recipes/default.rb ***

```ruby
# COOKBOOK[yum-repo]を呼び出し(lampから呼び出した場合は、COOKBOOK[php]で既に呼び出されているが、単体での利用を考慮して、冒頭で呼び出している)
include_recipe 'yum-repo'

# yumでmysqlパッケージをインストール
package node["mysql"]["packages"] do
  action :install
end


# mysqldサービスの自動起動設定と起動
service "mysqld" do
  action [ :enable, :start ]
end

# my.confファイルの作成、my.confファイルに変更があった場合は、mysqldサービスを再起動
template "#{node["mysql"]["conf-dir"]}/#{node["mysql"]["conf-file"]}" do
  source "#{node["mysql"]["template"]}"
  action :create
end
```

*** yum-repo/recipes/default.rb ***

```ruby
# centos 5.系の場合に、リポジトリサーバ用のyum.repoファイルを設置
template "/etc/yum.repos.d/cent5-chefrepo.repo" do
  source "cent5-chefrepo.repo.erb"
  owner "root"
  group "root"
  mode 0644
  sensitive true
  action :create
  only_if {node["platform"] == "centos" && node["platform_version"][0] == "5"}
end

# centos 6.系の場合に、リポジトリサーバ用のyum.repoファイルを設置
template "/etc/yum.repos.d/cent6-chefrepo.repo" do
  source "cent6-chefrepo.repo.erb"
  owner "root"
  group "root"
  mode 0644
  sensitive true
  action :create
  only_if {node["platform"] == "centos" && node["platform_version"][0] == "6"}
end
```

実際にnodeに対して適用して動作を確認します。

```bash
$ knife node run_list add <nodename> wordpress
$ knife node show <node-name>
$ knife ssh <node-ip> "chef-client" -m -x root -i /root/.ssh/id_rsa
```

> 出力されたログを確認して、期待通りの動作がされていることを確認して下さい。

以下のURLにアクセスして、初期設定画面で必要な情報を入力して、正しく動作することを確認して下さい。

- http://node-ip/wdp/wp-admin/install.php

ChefServerのWEB-UIから適用状況の確認を行います。

WorkStationサーバ経由でChef-ServerのWEB-UIにポートフォワードの設定をします。

```bash
$ ssh -L 443:<Chef-ServerのVIP>:443 -l root <WorkStationサーバのIPアドレス>
```

端末のブラウザから"https://localhost/signup"にアクセスします。

Reportsのタブでchef-clientの実行結果を確認します。

