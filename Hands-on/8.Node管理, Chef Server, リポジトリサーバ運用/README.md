# 1.一括パッチ適用

- 1-1.シナリオ
- 1-2.事前準備
- 1-3.一括パッチ適用

---

# 1.一括パッチ適用

---

## 1-1.シナリオ

ChefServerを活用して、脆弱性の確認と修正パッチの適用を一括で行います。

条件

- 複数のインスタンスがChef-Serverでnode管理されている状態
- 全てのnodeは同じorganizationに所属
- nginxのバージョン1.6.2以下に脆弱性が見つかったことを想定
- 一つのキーで全nodeにsshアクセスが可能

対応手順

- nginxのバージョン確認用のrecipe[check]を作成
- knife sshコマンドで全nodeに対してrecipe[check]を一括適用
- knife searchコマンドで全nodeのnginxのバージョンを確認
- nginxのバージョンアップ用（パッチ）recipe[patch]を作成
- 全nodeに対してrecipe[patch]を適用
- knife searchコマンドで全nodeのnginxのバージョンを確認

---

## 1-2.事前準備

以下のコマンドを実行して、COOKBOOK[centos_base]を作成します。

```bash
$ cd /home/<username>/chef-repo
$ knife cookbook create centos_base -o cookbooks
```

centos_baseのrecipes配下にip_get.rbを作成して、以下のように記述します。

**cookbooks/centos_base/recipes/ip_get.rb**

```ruby
# knife sshで接続する際に使用するnodeのIPアドレスをattributeに登録
ruby_block "get ip address" do
  block do
    ip_list = `ifconfig | grep "inet addr" | awk {'print $2'} | sed -e "s/addr://"`
    ip_array = ip_list.split("\n")
    i = 1
    ip_array.each do |ip|
      node.set["centos_base"]["ipaddress"]["#{i.to_s}"] = ip
      i += i
    end
  end
  action :run
end
```

centos_baseのrecipes配下にcheck.rbを作成して、以下のように記述します。

**cookbooks/centos_base/recipes/check.rb**

```ruby
# nginxのバージョンを取得して、1.6.2以下であればnode["centos_base"]["count"]に1をセット
ruby_block "check nginx version" do
  block do

    node.set["centos_base"]["nginx"]["check"] = 0
    nginx_version = `rpm -q nginx`
    if md = nginx_version.match(/-(\d+\.\d+\.\d+)-/)
      node.set["centos_base"]["nginx"]["version"] =  md[1]
      if node["centos_base"]["nginx"]["version"].gsub(/\./, "").to_i <= 1710 then
        node.set["centos_base"]["nginx"]["check"] = 1
      end
    end

  end
  action :run
end
```

centos_baseのrecipes配下にpatch.rbを作成して、以下のように記述します。

**cookbooks/centos_base/recipes/patch.rb**

```ruby
remote_file "/tmp/nginx-1.8.0-1.el6.ngx.x86_64.rpm" do
  source "http://nginx.org/packages/centos/6/x86_64/RPMS/nginx-1.8.0-1.el6.ngx.x86_64.rpm"
  action :create
  only_if { node["centos_base"]["nginx"]["check"] == 1 }
end

rpm_package "nginx-1.8.0-1.el6.ngx.x86_64.rpm" do
  source "/tmp/nginx-1.8.0-1.el6.ngx.x86_64.rpm"
  action :install
  only_if { node["centos_base"]["nginx"]["check"] == 1 }
end
```

各nodeにログインして、nginxをインストールして下さい。

```bash
$ ssh root@<ipaddress>
$ rpm -ivh nginx-1.7.10-1.el6.ngx.x86_64.rpm http://119.81.145.242/packages/chef/packages/nginx-1.7.10-1.el6.ngx.x86_64.rpm
# または
$ rpm -ivh nginx-1.7.11-1.el6.ngx.x86_64.rpm http://119.81.145.242/packages/chef/packages/nginx-1.7.11-1.el6.ngx.x86_64.rpm
$ exit
```

centos_baseのrecipes配下のdefault.rbを、以下のように記述します。

**cookbooks/centos_base/recipes/default.rb**

```ruby
include_recipe "ip_get"
```

各nodeのrun_listにrecipe[centos_base]を追加して、適用しておきます。

```bash
$ knife cookbook upload centos_base
$ knife node run_list add <node_name> recipe[centos_base]
$ knife node show <node_name>
$ knife ssh <node_ip> "chef-client" -m -x root -P "password"
```

---

## 1-3.一括パッチ適用

対応手順

- nginxのバージョン確認用のrecipe[check]を作成
- knife sshコマンドで全nodeに対してrecipe[check]を一括適用
- knife searchコマンドで全nodeのnginxのバージョンを確認
- nginxのバージョンアップ用（パッチ）recipe[patch]を作成
- 全nodeに対してrecipe[patch]を適用
- knife searchコマンドで全nodeのnginxのバージョンを確認

### nginxのバージョン確認用のrecipe[check]を作成

recipeは事前準備で作成しておいたので、centos_base適用時にcheck.rbも実行するように修正します。

**cookbooks/centos_base/recipes/default.rb**

```ruby
include_recipe "ip_get"
include_recipe "check"
```

### knife sshコマンドで全nodeに対してrecipe[check]を一括適用

以下のknife searchコマンドを実行して、接続に利用するIPアドレスを確認します。

```bash
knife search "name:*" -a centos_base.ipaddress
```

以下のコマンドを実行して全nodeのchef-clientを実行します（check.rbによるnginxのバージョン確認）

```bash
knife ssh "name:*" "chef-client" -a centos_base.ipaddress.1 -x root -i /root/.ssh/id_rsa
```

### knife searchコマンドで全nodeのnginxのバージョンを確認

以下のコマンドを実行してcheck.rbで取得したnginxのバージョンを一括で確認します。

```bash
$ knife search "name:*" -a centos_base.nginx
```

### nginxのバージョンアップ用（パッチ）recipe[patch]を作成

recipeは事前準備で作成しておいたので、centos_base適用時にpatch.rbも実行するように修正します。

**cookbooks/centos_base/recipes/default.rb**

```ruby
include_recipe "ip_get"
include_recipe "check"
include_recipe "patch"
# patch.rb適用後にcheck.rbで状態を取得
include_recipe "check"
```

### 全nodeに対してrecipe[patch]を適用

以下のコマンドを実行して全nodeのchef-clientを実行します

```bash
knife ssh "name:*" "chef-client" -a centos_base.ipaddress.1 -x root -i /root/.ssh/id_rsa
```

### knife searchコマンドで全nodeのnginxのバージョンを確認

以下のコマンドを実行してcheck.rbで取得したnginxのバージョンを一括で確認します。

```bash
$ knife search "name:*" -a centos_base.nginx
```
