# 1.[vagrant-aws](#)
- 1-1.[vagrant pluginをインストール](#)
- 1-2.[Vagrantfileの準備](#)
- 1-3.[インスタンスを起動する](#)
- 1-4.[Chef-Clientをインストールする](#)
- 1-5.[COOKBOOKを適用する](#)

# 2.serverspec

- 2-1.serverspecとは
- 2-2.serverspec-init
- 2-3.COOKBOOK[httpd]のテスト用コードを作成
- 2-4.テスト実施

---

# 1.vagrant-aws

---

![test](https://raw.github.com/wiki/urasoko/handson-repo/images/HandsOn-4-1.png)


## 1-1.vagrant pluginをインストール

以下のコマンドを実行してvagrant pluginをインストールします。

```bash
$ vagrant plugin install vagrant-aws
$ vagrant plugin install dotenv
```

---

## 1-2.Vagrantfileの準備

vagrant-awsフォルダを作成して、Vagrantfileと.envファイルを作成します。

```bash
$ cd chef-study
$ mkdir vagrant-aws
$ cd vagrant-aws
$ vagrant-init
$ touch .env
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
    override.ssh.private_key_path = "~/.ssh/#{ENV["KEY_PAIR"]}.pem"
  end
end
```

> Dotenv.load -> カレントディレクトリの.envファイルを読み込む  
> ENV[] -> .envファイルで指定した変数を呼び出す  
> aws.user_data -> sudoの設定変更(vagrantフォルダのrsync同期処理失敗を回避するため、Defaults  requirettyをコメントアウトする)

.envファイルを編集します。

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

.envファイルに記載する情報は[こちら](https://119.81.145.242/packages/oracle/chef-study.env)からダウンロードして下さい。

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
  config.vm.provision "shell", inline: <<-SHELL
    chef_check=`rpm -qa | grep chef-12.2.1-1.el6.x86_64 | wc -l`
    if [ $chef_check -eq 0 ] ; then
      cp /vagrant/chef-12.2.1-1.el6.x86_64.rpm /tmp/chef-12.2.1-1.el6.x86_64.rpm
      rpm -i /tmp/chef-12.2.1-1.el6.x86_64.rpm
    fi
  SHELL
```

インストールするパッケージファイルをvagrant-awsフォルダ内に配置しておきます。

```bash
$ cp ../vagrant/chef-12.2.1-1.el6.x86_64.rpm ./
$ ls
.  ..  .env   .vagrant  Vagrantfile  chef-12.2.1-1.el6.x86_64.rpm
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
    chef.cookbooks_path = ["../chef-repo/site-cookbooks"]
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


