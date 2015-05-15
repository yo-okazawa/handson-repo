# 1.[vagrant-aws](#)
- 1-1.[vagrant pluginをインストール](#)
- 1-2.[Vagrantfileの準備](#)
- 1-3.[インスタンスを起動する](#)
- 1-4.[Chef-Clientをインストールする](#)
- 1-5.[COOKBOOKを適用する](#)

---

# 1.vagrant-aws

---

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


