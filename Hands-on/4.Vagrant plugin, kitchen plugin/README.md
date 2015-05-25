# 1.vagrant-aws
- 1-1.vagrant pluginをインストール
- 1-2.Vagrantfileの準備
- 1-3.インスタンスを起動する
- 1-4.Chef-Clientをインストールする
- 1-5.COOKBOOKを適用する

# 2.serverspec

- 2-1.serverspecとは
- 2-2.serverspec-init
- 2-3.COOKBOOK[httpd]のテスト用コードを作成
- 2-4.テスト実施

# 3.コミュニティーCOOKBOOKを利用する
- 3-1.コミュニティーCOOKBOOKのダウンロード方法
- 3-2.コミュニティーCOOKBOOKの探し方
- 3-3.COOKBOOK間の依存について

# Appendix

- test-kitchen

---

# 1.vagrant-aws

---

![test](https://raw.github.com/wiki/urasoko/handson-repo/images/HandsOn-4-1.png)


## 1-1.vagrant pluginをインストール

以下のコマンドを実行してvagrant pluginをインストールします。

```bash
$ vagrant plugin install vagrant-aws
$ vagrant plugin install dotenv
$ vagrant plugin install vagrant-omnibus
```

---

## 1-2.Vagrantfileの準備

vagrant-awsフォルダを作成して、Vagrantfileを作成します。

```bash
$ cd chef-study
$ mkdir vagrant-aws
$ cd vagrant-aws
$ vagrant init
```

Vagrantfileを編集します。

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Dotenv.load

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "dummy"
  config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

  config.vm.provider "aws" do |aws, override|
    aws.tags = {
      'Name' => ENV["TAGS_NAME"]
    }
    
    aws.access_key_id     = ENV["ACCESS_KEY_ID"]
    aws.secret_access_key = ENV["SECRET_ACCESS_KEY"]
    aws.keypair_name      = ENV["KEY_PAIR"]
    aws.ami               = ENV["AMI"]
    aws.instance_type     = ENV["INSTANCE_TYPE"]
    aws.subnet_id         = ENV["SUBNET_ID"]
    aws.security_groups   = ENV["SECURITY_GROUPS"]
    aws.region            = ENV["REGION"]
    
    aws.user_data = "#!/bin/sh\nsed -i -e 's/^Defaults\\s*requiretty/#Defaults  requiretty/g' /etc/sudoers\n"
    
    override.ssh.username = "ec2-user"
    override.ssh.private_key_path = "../.ssh/#{ENV["KEY_PAIR"]}.pem"
  end
end
```

> Dotenv.load -> カレントディレクトリの.envファイルを読み込む  
> ENV[] -> .envファイルで指定した変数を呼び出す  
> aws.user_data -> sudoの設定変更(vagrantフォルダのrsync同期処理失敗を回避するため、Defaults  requirettyをコメントアウトする)

[こちら](https://119.81.145.242/packages/oracle/.env)からenvファイルをダウンロードしてchef-study/vagrant-aws/.envとして保存します。
.envファイルTAGS_NAMEの値をchef-study-<name>に修正します。その他の項目は修正不要です。

```ruby
TAGS_NAME         = "タグ名(例：chef-study-arai)"
ACCESS_KEY_ID     = "アクセスキーID"
SECRET_ACCESS_KEY = "シークレットアクセスキー"
KEY_PAIR          = "キーペア名"
AMI               = "AMIのID"
INSTANCE_TYPE     = "インスタンスタイプ"
SUBNET_ID         = "サブネットID"
SECURITY_GROUPS   = "セキュリティーグループID"
REGION            = "リージョン"
```

[こちら](https://119.81.145.242/packages/oracle/chef-study.pem)から秘密キーをダウンロードして、chef-study/.ssh/chef-study.pemに保存して、パーミッションを600に設定します。

```bash
$ cd chef-study
$ mkdir .ssh
ダウンロード
$ cd .ssh
$ chmod 600 chef-study.pem
```

---

## 1-3.インスタンスを起動する

以下のコマンドを実行して、インスタンスを起動します。

```bash
$ vagrant up --provider=aws
```

ログインして確認してみます。

```bash
$ vagrant ssh
[ec2-user@ip-172-30-0-xx ~]$ cat /etc/redhat-rerease || cat /etc/os-release
[ec2-user@ip-172-30-0-xx ~]$ ls /vagrant
[ec2-user@ip-172-30-0-xx ~]$ exit
```

---

## 1-4.Chef-Clientをインストールする

Vagrant起動時にChef-ClientをインストールするようにVagrantfileに以下を追記します。

```ruby
config.omnibus.chef_version = "12.2.1"
```

以下のコマンドを実行してChef-Clientがインストールされるか確認します。

```bash
$ vagrant provision
$ vagrant ssh
[ec2-user@ip-172-30-0-xx ~]$ chef-client -v
Chef: 12.2.1
[ec2-user@ip-172-30-0-xx ~]$ exit
```

---

## 1-5.COOKBOOKを適用する

前回作成したCOOKBOOK[httpd]をvagrant-awsのインスタンスに適用します。

Vagrant起動時にCOOKBOOK[httpd]を適用するようにVagrantfileに以下を追記します。

```ruby
  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = ["../chef-repo/cookbooks"]
    chef.add_recipe "httpd"
  end
```

この状態でCOOKBOOK[httpd]を適用してみます。

```bash
$ vagrant provision
```

現在のCOOKBOOKの状態のままだと、OSに対応していないのでエラーになります。

*** ・COOKBOOK[httpd]のattributes/defaultsにOSに対応させる処理を追加して、COOKBOOKが動作することを確認して下さい。 ***

*** ・COOKBOOK適用後、WEBブラウザからアクセスできることを確認してください。 ***

> platformを確認するコマンド -> "ohai | grep platform"  
> WEBサーバのパッケージ名 -> "httpd"  
> COOKBOOKを修正した場合は、"vagrant rsync"コマンドを実行してCOOKBOOKを同期して下さい。

COOKBOOKの適用に成功したら、以下のコマンドを実行して、インスタンスが削除されることを確認します。

```
$ vagrant destroy
```

---

# 2.serverspec

---
## 2-1.serverspecとは

serverspecとは -> サーバの状態をテストするためのフレームワーク

### 特徴
- sshでログインしてリモートでコードを実行
- エージェントレス
- OSごとの違いを吸収

---

## 2-2.serverspec-init

通常はruby gemでインストールして利用しますが、前回インストールしたChefDKに付属されていますのでインストールは不要です。

```bash
$ chef gem list | grep serverspec
serverspec (2.14.1)
```

serverspecで利用するファイルのひな形をchef-study/vagrantディレクトリに作成します。

```bash
$ cd chef-study/vagrant
$ serverspec-init
Select OS type:

  1) UN*X
  2) Windows

Select number: 1

Select a backend type:

  1) SSH
  2) Exec (local)

Select number: 1

Vagrant instance y/n: y
Auto-configure Vagrant from Vagrantfile? y/n: y
 + spec/
 + spec/default/
 + spec/default/sample_spec.rb
 + spec/spec_helper.rb
 + Rakefile
 + .rspec
```

> Select OS type: -> Centosのテストをするので『1』  
> Select a backend type: -> SSHで接続するので『1』  
> Vagrant instance y/n: -> vagrant instanceなので『y』  
> Auto-configure Vagrant from Vagrantfile? y/n: -> Vagrantfileの情報を元にconfigureするので『y』

serverspec-initコマンドで生成されたファイルの内容を確認してみます。

*** ./Rakefile ***

- rakeの定義ファイル

*** ./spec/spec_helper.rb ***

- sshの接続方法等を定義

*** ./spec/default/sample_spec.rb *** 

- テストコードを記載

---

## 2-3.テスト用コードを作成

./spec/default/sample_spec.rbを編集して前回までで作成したCOOKBOOK[httpd]のテスト用コードを作成します。

```ruby
require "spec_helper"

describe package("httpd") do
  it { should be_installed }
end

describe service("httpd") do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

describe file("/etc/httpd/conf/httpd.conf") do
  it { should be_file }
  its(:content) { should match /^DocumentRoot\s\"\/var\/www\/html2\"/ }
end

describe file("/var/www/html2") do
  it { should be_directory }
end

describe file("/var/www/html2/index.html") do
  it { should be_file }
end

describe file("/var/www/html2/template.html") do
  it { should be_file }
end

describe command('curl -k http://localhost/index.html') do
  its(:stdout) { should match /hello world/ }
end
```

---

## 2-4.テスト実施

初期状態で仮想サーバを立ち上げて、serverspecでtestを実行します。

```bash
$ vagrant up --no-provision
$ rake spec
```

> 全てのテストが失敗したことを確認して下さい(全てRED表示)

今度はプロビジョニングを実行してから、再度テストを実行します。

```bash
$ vagrant provision
$ rake spec
```

> 全てのテストに成功したことを確認して下さい(全てGREEN表示)

---

# 3.コミュニティーCOOKBOOKを利用する

---

## 3-1.コミュニティーCOOKBOOKのダウンロード方法

コミュニティーCOOKBOOKは以下のコマンドでインストール可能です。

```bash
$ cd chef-study/chef-repo
$ knife cookbook site install <COOKBOOK名>
```

---

## 3-2.コミュニティーCOOKBOOKの探し方

[こちら](https://supermarket.chef.io/cookbooks-directory)のリンク先で探すことが出来ます。

各COOKBOOKの『View Source』でソースコードを参照できます。

ページから直接DownLoadすることも可能です。

---

## 3-3.COOKBOOK間の依存について

- コミュニティーCOOKBOOKの多くは他のCOOKBOOKに依存しています。
- metadata.rbまたはREADME.rbを確認すれば、どのCOOKBOOKに依存しているかが確認できます。
- 依存関係にあるCOOKBOOKは個別でダウンロードしておくか、[Berkshelf](http://berkshelf.com/)を利用してダウンロードして利用します。

---

# Appendix

---

## test-kitchen

test-kitchenとは…指定したOS上でインフラのコードを実行、テストを行うための統合ツールで、インスタンス起動～COOKBOOK適用～テスト～インスタンス破棄までを一つのコマンドで行うことが可能

*** 今回はvagrant上にcentosを起動～chef-zeroでcookbookを適用(WEBサーバ)～serverspecでテスト実施～インスタンス破棄までをtest-kitchenで行います ***

> test-kitchenはChefDKに同梱されていますので、インストールは不要です。

COOKBOOK[test-kitchen]を生成します。

``` bash
$ cd chef-study/chef-repo/cookbooks
$ chef generate cookbook test-kitchen -o cookbooks
```

> "chef generate cookbook"コマンドでCOOKBOOKのひな形を生成すると、test-kitchen用のテンプレートも同時に生成されます。

- COOKBOOK[test-kitchen]の内容を以下のように修正します。

*** recipes/default.rb ***

```ruby
package "httpd"

service "httpd" do
  action [:enable, :start]
end

file "/var/www/html/index.html" do
  content "hello world"
end
```

*** .kitchen.yml ***

```ruby
---
driver:
  name: vagrant
  synced_folders: [
    ["./chef-installer", "/tmp/chef-installer"]
  ]
provisioner:
  chef_omnibus_url: file:///tmp/chef-installer/install.sh
  name: chef_zero
  
platforms:

  - name: centos66

suites:
  - name: default
    run_list:
      - recipe[test-kitchen::default]
```

*** test/integration/default/serverspec/default_spec.rb ***

```ruby
require "spec_helper"

describe package("httpd") do
  it { should be_installed }
end

describe service("httpd") do
  it { should be_enabled }
  it { should be_running }
end

describe file("/var/www/html/index.html") do
  it { should be_file }
  its(:content) { should match /hello world/ }
end
```

- COOKBOOK[test-kitchen]ディレクトリの配下にディレクトリを作成します。

```bash
$ cd test-kitchen
$ mkdir chef-installer
```

- chef-installerディレクトリの配下にchef-clientのパッケージ(chef-12.2.1-1.el6.x86_64.rpm)を配置します。

- chef-installer/install.shを作成して、以下のように修正します。

*** chef-installer/install.sh ***

```bash
sudo rpm -ivh /tmp/chef-installer/chef-12.2.1-1.el6.x86_64.rpm
```

- centos66のBOX名を以下の名前で新たに追加します。

```bash
$ vagrant box add opscode-centos66 <boxファイルのパス>
```

準備が完了したので、実際にkitchef ～コマンドを使用して操作してみます。

> 以下は全てchef-repo/cookbooks/test-kitchenディレクトリ配下で実施

```bash
$ kitchen create
```

> インスタンス起動

```bash
$ kitchen list
```

> インスタンスのリストを表示

```bash
$ kitchen converge
```

> インスタンス起動～プロビジョニング実施(起動済みの場合はプロビジョニングのみ)

```bash
$ kitchen verify
```

> テスト実施

```bash
$ kitchen login
```

> インスタンスにログイン

```bash
$ kitchen destroy
```

> インスタンス破棄

```bash
$ kitchen test
```

> インスタンス起動～プロビジョニング～テスト実行～インスタンス破棄


