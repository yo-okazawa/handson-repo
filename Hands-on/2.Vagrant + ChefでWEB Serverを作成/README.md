# 1.Vagrant環境の作成
- 1-1.[Virtual Boxのインストール](#markdown-header-1-1virtual-box)
- 1-2.[Vagrantのインストール](#markdown-header-1-2vagrant)
- 1-3.[Boxの準備](#markdown-header-1-3box)

# 2.Vagrant操作
- 2-1.[仮想サーバの起動](#markdown-header-2-1)
- 2-2.[仮想サーバへの接続](#markdown-header-2-2)
- 2-3.[仮想サーバの停止、破棄](#markdown-header-2-3)

# 3.ChefでWEBサーバをインストール
- 3-1.[仮想サーバにchef-clientをインストール](#markdown-header-3-1chef-client)
- 3-2.recipeを実行してみる
- 3-3.[ChefでWEBサーバをインストール](#markdown-header-3-3chefweb)

---

# 1.Vagrant環境の作成

---

## 1-1.Virtual Boxのインストール  
[こちら](https://www.virtualbox.org/wiki/Downloads)からインストーラをダウンロードして、インストーラの指示にしたがってインストールして下さい。  
> Windowsの場合⇒VirtualBox x.x.x for Windows hosts  
> Macの場合⇒VirtualBox x.x.x for OS X hosts  
> ※一時的にPCのネットワークが切断されます。

---

## 1-2.Vagrantのインストール  
[こちら](https://www.vagrantup.com/downloads.html)からインストーラをダウンロードして、インストーラの指示にしたがってインストールして下さい。  
> Windowsの場合⇒WINDOWS Universal (32 and 64-bit)  
> Macの場合⇒MAC OS X Universal (32 and 64-bit)  
> ※PC再起動が必要になります。

---

## 1-3.Boxの準備  
[こちら](http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.6_chef-provisionerless.box)からboxをダウンロードして保存して下さい。（どうしても遅い時は[こちら](https://119.81.145.242/packages/chef/boxes/opscode_centos-6.6_chef-provisionerless.box)）  
ターミナル(コマンドプロンプト)上で以下のコマンドを実行して、VagrantにダウンロードしたBoxを追加します。  

>```
$ vagrant box add centos66 <Boxファイルへのパス>
```

以下のコマンドを実行してBoxが追加されたことを確認します。  

>```
$ vagrant box list
centos65 (virtualbox, 0)
```

---

# 2.Vagrant操作

---

## 2-1.仮想サーバの起動  
仮想サーバを起動するためのディレクトリを作成して下さい。  
> * 場所はどこでも可  
* 名前は統一で『vagrant』として下さい。


>```
$ mkdir vagrant
```

作成したディレクトリに移動して、以下のコマンドを実行して下さい。  

>```
$ cd vagrant
$ vagrant init
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
```

カレントディレクトリにVagrantfileが生成されます。

>```
$ ls  #Windowsは『dir』
Vagrantfile
```

Vagrantfileをエディタで開いて、以下のように編集して下さい。

>```
 # -*- mode: ruby -*-
 # vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box_check_update = false
  config.vm.box = "centos66"
  config.vm.hostname = "test01"
  config.vm.network "private_network", ip: "192.168.33.101"
end
```

以下のコマンドを実行して、仮想サーバを起動します。

>```
$ vagrant up
```

以下のコマンドを実行して、起動中の仮想サーバの状態を確認します。

>```
$ vagrant status
Current machine states:
default                   running (virtualbox)
```

---

## 2-2.仮想サーバへの接続  
仮想サーバの接続情報を以下のコマンドで確認します。

>```
$ vagrant ssh-config
Host default
  HostName 127.0.0.1
  User vagrant
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile C:/Users/h-arai/vagrant/.vagrant/machines/default/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL
```

> localhost(127.0.0.1)のポート2222に接続するということが分かります。  
> また、接続に使用する鍵ファイルが"C:/Users/h-arai/vagrant/.vagrant/machines/default/virtualbox/private_key"に生成されていることが分かります。

実際に接続してみます。

>```
$ ssh vagrant@localhost -p 2222
vagrant@localhost's password:
[vagrant@test01 ~]$ exit
logout
Connection to localhost closed.
$
```

> パスワード : vagrant

windowsの場合はTeraterm等のツールで接続して下さい。

---

## 2-3.仮想サーバの停止、破棄  
仮想サーバを停止する場合は、以下のコマンドを実行します。

>```
$ vagrant halt
==> default: Attempting graceful shutdown of VM...
```

> 再度起動する場合は、『vagrant up』で起動出来ます。

仮想サーバを破棄する場合は、以下のコマンドを実行します。

>```
$ vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Destroying VM and associated drives...
```

---

# 3.ChefでWEBサーバをインストール

---

## 3-1.仮想サーバにchef-clientをインストール  
[こちら](https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-12.2.1-1.el6.x86_64.rpm)からchef-clientのパッケージをダウンロードして下さい。  
ダウンロードしたパッケージはvagrantディレクトリに保存して下さい。

仮想サーバを起動して接続します。

>```
$ vagrant up
$ vagrant ssh-config
$ ssh vagrant@localhost -p 2222
[vagrant@test01 ~]$
```

/vagrantディレクトリに先ほどダウンロードしたパッケージがホスト-ゲスト間で共有されています。

>```
$ ls /vagrant
chef-12.2.1-1.el6.x86_64.rpm  Vagrantfile
```

chef-clientパッケージをインストールします。

>```
$ cp /vagrant/chef-12.2.1-1.el6.x86_64.rpm /tmp
$ cd /tmp
$ ls
chef-12.2.1-1.el6.x86_64.rpm
$ sudo rpm -ivh chef-12.2.1-1.el6.x86_64.rpm
warning: chef-12.2.1-1.el6.x86_64.rpm: Header V4 DSA/SHA1 Signature, key ID 83ef826a: NOKEY
Preparing...                ########################################### [100%]
   1:chef                   ########################################### [100%]
Thank you for installing Chef!
$ chef-client -v
Chef: 12.2.1
```

---

## 3-2.recipeを実行してみる  
Chef作業用ディレクトリとしてhomeディレクトリ配下にchef-repoを作成します。

>```
$ mkdir ~/chef-repo
$ cd ~/chef-repo
$ pwd
/home/vagrant/chef-repo
```

chef-repo配下に以下の内容でrecipeを作成します。

>```
$ cat << EOF > hello.rb
file 'test.txt' do
  content 'hello world!'
end
EOF
```

以下のコマンドで作成したrecipeを適用します。

>```
$ chef-apply hello.rb
Recipe: (chef-apply cookbook)::(chef-apply recipe)
  * file[test.txt] action create
    - create new file test.txt
    - update content in file test.txt from none to 7509e5
    --- test.txt        2015-04-24 05:55:23.612199023 +0000
    +++ ./.test.txt20150424-9002-17wadhk        2015-04-24 05:55:23.612199023 +0000
    @@ -1 +1,2 @@
    +hello world!
```

recipeに指定した通りにfileが作成されてることが確認出来ます。

>```
$ ls
hello.rb  test.txt
$ cat test.txt
hello world!
```

もう一度実行してみます。

>```
Recipe: (chef-apply cookbook)::(chef-apply recipe)
  * file[test.txt] action create (up to date)
```

既にtest.txtがあるべき状態となっているため、file resourceは実行されません。

---

## 3-3.ChefでWEBサーバをインストール  
WEBサーバをインストールするrecipe(httpd.rb)を作成します。

>```
$ cat << EOF > httpd.rb
package 'httpd' do
  action :install
end
EOF
```

作成したrecipeを適用します。
> パッケージのインストールにroot権限が必要になるため、sudoで実行します。
```
$ sudo chef-apply httpd.rb
Recipe: (chef-apply cookbook)::(chef-apply recipe)
  * yum_package[httpd] action install
    - install version 2.2.15-39.el6.centos of package httpd
```
出力内容からhttpdのパッケージをyumでインストールことが分かります。

httpdの状態を確認してみます。

>```
$ yum list installed | grep httpd
httpd.x86_64           2.2.15-39.el6.centos
httpd-tools.x86_64     2.2.15-39.el6.centos
$ sudo service httpd status
httpd is stopped
$ chkconfig --list httpd
httpd           0:off   1:off   2:off   3:off   4:off   5:off   6:off
```
httpdはインストールされていますが、起動していない、起動設定も有効化されていないことが分かります。

recipe(httpd.rb)を以下のように修正して、サービスを起動、起動設定を有効化してみます。  
ついでに接続確認用にindex.htmlも配置するようにします。

>```
$ cat << EOF > httpd.rb
package "httpd" do
  action :install
end
service "httpd" do
  action [:enable, :start]
end
file "/var/www/html/index.html" do
  content "<html>
  <body>
    <h1>hello world</h1>
  </body>
</html>"
end
EOF
```

recipeを適用します。

>```
$ sudo chef-apply httpd.rb
Recipe: (chef-apply cookbook)::(chef-apply recipe)
以下略
```
httpdは既にインストール済みのため、インストールされません。  

httpdの状態を確認してみます。

>```
$ yum list installed | grep httpd
httpd.x86_64           2.2.15-39.el6.centos
httpd-tools.x86_64     2.2.15-39.el6.centos
$ sudo service httpd status
httpd (pid  3714) is running...
$ chkconfig --list httpd
httpd           0:off   1:off   2:on    3:on    4:on    5:on    6:off
$ ls /var/www/html/
index.html
$curl http://localhost
<html>
  <body>
    <h1>hello world</h1>
  </body>
</html>[vagrant@test01 chef-repo]$ ls /var/www/html/
index.html
```

端末のブラウザからのアクセスも確認してみます。  
http://192.168.33.101/

---

# Appendix  

---

## Vagrantの仮想サーバへの接続方法について  
以下の方法でも接続することが可能です。

>```
$ vagrant ssh-config >> .ssh_config
$ vagrant ssh
[vagrant@test01 ~]$
```

※windows端末の場合はsshコマンドが実行出来る必要があります。(Cygwin, Git Bash等)
