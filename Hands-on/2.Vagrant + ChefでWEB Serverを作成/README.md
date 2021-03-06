# 1.Vagrant環境の作成
- 1-1.[Virtual Boxのインストール](#markdown-header-1-1virtual-box)
- 1-2.[Vagrantのインストール](#markdown-header-1-2vagrant)
- 1-3.[Boxの準備](#markdown-header-1-3box)
- 1-4.[Git Bashをインストール](#markdown-header-1-4git-bash)

# 2.Vagrant操作
- 2-1.[仮想サーバの起動](#markdown-header-2-1)
- 2-2.[仮想サーバへの接続](#markdown-header-2-2)
- 2-3.[仮想サーバの停止、破棄](#markdown-header-2-3)

# 3.ChefでWEBサーバをインストール
- 3-1.[仮想サーバにchef-clientをインストール](#markdown-header-3-1chef-client)
- 3-2.[recipeを実行してみる](#markdown-header-3-2recipe)
- 3-3.[ChefでWEBサーバをインストール](#markdown-header-3-3chefweb)

# 4.recipe適用までの作業を簡略化する
- 4-1.[chef-clientのインストールを簡略化](#markdown-header-4-1chef-client)
- 4-2.[ChefDKのインストール](#markdown-header-4-2chefdk)
- 4-3.[ローカル端末上でCOOKBOOKを作成](#markdown-header-4-3cookbook)
- 4-4.[recipe適用を簡略化する](#markdown-header-4-4recipe)

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

```
$ vagrant box add centos66 <Boxファイルへのパス>
```

以下のコマンドを実行してBoxが追加されたことを確認します。  

```
$ vagrant box list
centos66 (virtualbox, 0)
```
---
## 1-4.[Git Bashをインストール]  
> Windowsの場合のみ実施

[こちら](https://msysgit.github.io/)からインストーラをダウンロードし、インストーラの指示に従ってインストールしてください。

インストール完了後、Git BashのbinディレクトリをPathに追加します。

- ファイル名を指定して実行に"sysdm.cpl"と入力
- 詳細設定タブの環境設定(N)をクリック
- システム環境変数のPathの編集
- 末尾に";C:\Program Files (x86)\Git\bin"を追加

---

# 2.Vagrant操作

---

## 2-1.仮想サーバの起動  
ハンズオンで使用するディレクトリを作成して、そのディレクトリ配下に仮想サーバを起動するためのディレクトリを作成して下さい。  
> * 場所はどこでも可  
* 名前は統一で『chef-study/vagrant』として下さい。


```
$ mkdir chef-study
$ cd chef-study
$ mkdir vagrant
```

作成したディレクトリに移動して、以下のコマンドを実行して下さい。  

```
$ cd vagrant
$ vagrant init
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
```

カレントディレクトリにVagrantfileが生成されます。

```
$ ls  #Windowsは『dir』
Vagrantfile
```

Vagrantfileをエディタで開いて、以下のように編集して下さい。

```
 # -*- mode: ruby -*-
 # vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box_check_update = false
  config.vm.box = "centos66"
  config.vm.hostname = "test01"
  config.vm.network "forwarded_port", guest: 80, host: 8080
end
```

以下のコマンドを実行して、仮想サーバを起動します。

```
$ vagrant up
```

以下のコマンドを実行して、起動中の仮想サーバの状態を確認します。

```
$ vagrant status
Current machine states:
default                   running (virtualbox)
```

---

## 2-2.仮想サーバへの接続  
仮想サーバの接続情報を".ssh_config"に出力しておきます。

```
$ vagrant ssh-config >> .ssh_config
```

実際に接続してみます。

```
$ vagrant ssh
[vagrant@test01 ~]$ exit
logout
Connection to 127.0.0.1 closed.
$
```

---

## 2-3.仮想サーバの停止、破棄  
仮想サーバを停止する場合は、以下のコマンドを実行します。

```
$ vagrant halt
==> default: Attempting graceful shutdown of VM...
```

> 再度起動する場合は、『vagrant up』で起動出来ます。

仮想サーバを破棄する場合は、以下のコマンドを実行します。

```
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

```
$ vagrant up
$ vagrant ssh
[vagrant@test01 ~]$
```

/vagrantディレクトリに先ほどダウンロードしたパッケージがホスト-ゲスト間で共有されています。

```
[vagrant@test01 ~]$ ls /vagrant
chef-12.2.1-1.el6.x86_64.rpm  Vagrantfile
```

chef-clientパッケージをインストールします。

```
[vagrant@test01 ~]$ cp /vagrant/chef-12.2.1-1.el6.x86_64.rpm /tmp
[vagrant@test01 ~]$ cd /tmp
[vagrant@test01 tmp]$ ls
chef-12.2.1-1.el6.x86_64.rpm
[vagrant@test01 tmp]$ sudo rpm -ivh chef-12.2.1-1.el6.x86_64.rpm
[vagrant@test01 tmp]$ chef-client -v
Chef: 12.2.1
```

---

## 3-2.recipeを実行してみる  
Chef作業用ディレクトリとしhomeディレクトリ配下にchef-repoを作成します。

```
[vagrant@test01 tmp]$ mkdir ~/chef-repo
[vagrant@test01 ~]$ cd ~/chef-repo
[vagrant@test01 chef-repo]$ pwd
/home/vagrant/chef-repo
```

chef-repo配下に以下の内容でrecipeを作成します。

```
[vagrant@test01 chef-repo]$ cat << EOF > hello.rb
file 'test.txt' do
  content 'hello world!'
end
EOF
```

以下のコマンドで作成したrecipeを適用します。

```
[vagrant@test01 chef-repo]$ chef-apply hello.rb
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

```
[vagrant@test01 chef-repo]$ ls
hello.rb  test.txt
[vagrant@test01 chef-repo]$ cat test.txt
hello world!
```

もう一度実行してみます。

```
[vagrant@test01 chef-repo]$ chef-apply hello.rb
Recipe: (chef-apply cookbook)::(chef-apply recipe)
  * file[test.txt] action create (up to date)
```

既にtest.txtがあるべき状態となっているため、file resourceは実行されません。

---

## 3-3.ChefでWEBサーバをインストール  
WEBサーバをインストールするrecipe(httpd.rb)を作成します。

```
[vagrant@test01 chef-repo]$ cat << EOF > httpd.rb
package 'httpd' do
  action :install
end
EOF
```

作成したrecipeを適用します。
> パッケージのインストールにroot権限が必要になるため、sudoで実行します。

```
[vagrant@test01 chef-repo]$ sudo chef-apply httpd.rb
Recipe: (chef-apply cookbook)::(chef-apply recipe)
  * yum_package[httpd] action install
    - install version 2.2.15-39.el6.centos of package httpd
```
出力内容からhttpdのパッケージをyumでインストールしたことが分かります。

httpdの状態を確認してみます。

```
[vagrant@test01 chef-repo]$ yum list installed | grep httpd
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

```
[vagrant@test01 chef-repo]$ cat << EOF > httpd.rb
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

```
[vagrant@test01 chef-repo]$ sudo chef-apply httpd.rb
Recipe: (chef-apply cookbook)::(chef-apply recipe)
以下略
```
httpdは既にインストール済みのため、インストールされません。  

httpdの状態を確認してみます。

```
[vagrant@test01 chef-repo]$ yum list installed | grep httpd
httpd.x86_64           2.2.15-39.el6.centos
httpd-tools.x86_64     2.2.15-39.el6.centos
[vagrant@test01 chef-repo]$ sudo service httpd status
httpd (pid  3714) is running...
[vagrant@test01 chef-repo]$ chkconfig --list httpd
httpd           0:off   1:off   2:on    3:on    4:on    5:on    6:off
[vagrant@test01 chef-repo]$ ls /var/www/html/
index.html
[vagrant@test01 chef-repo]$ curl http://localhost
<html>
  <body>
    <h1>hello world</h1>
  </body>
</html>[vagrant@test01 chef-repo]$ ls /var/www/html/
index.html
```

端末のブラウザからのアクセスも確認してみます。  
http://localhost:8080

---
# 4.recipe適用までの作業を簡略化する
---

## 4-1.chef-clientのインストールを簡略化  
Vagrantfileの内容を以下のように編集します。

```
 # -*- mode: ruby -*-
 # vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box_check_update = false
  config.vm.box = "centos66"
  config.vm.hostname = "test01"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provision "shell", inline: <<-SHELL
    chef_check=`rpm -qa | grep chef-12.2.1 | wc -l`
    if [ $chef_check -eq 0 ] ; then
      cp /vagrant/chef-12.2.1-1.el6.x86_64.rpm /tmp/chef-12.2.1-1.el6.x86_64.rpm
      rpm -i /tmp/chef-12.2.1-1.el6.x86_64.rpm
    fi
  SHELL
end
```

仮想サーバを新規で起動してchef-clientがインストールされているか確認してみます。

```
$ vagrant destroy
$ vagrant up
$ vagrant ssh
[vagrant@test01 ~]$ chef-client -v
Chef: 12.2.1
```

>今回はvm.provisionに[shell](http://docs.vagrantup.com/v2/provisioning/shell.html)を指定してシェルスクリプトを利用していますが、
別の方法としてvagrantプラグイン[vagrant-omunibus](https://github.com/chef/vagrant-omnibus)を使った方法もあります。

## 4-2.ChefDKのインストール  
[こちら](https://downloads.chef.io/chef-dk/)からインストーラをダウンロードして、インストーラの指示にしたがってインストールして下さい。

## 4-3.ローカル端末上でCOOKBOOKを作成  
chef-repoを作成
> chef-study配下に作成して下さい。

```
$ cd ../
$ pwd
$ chef gem install knife-solo
$ knife solo init chef-repo
$ cd chef-repo
$ git init
$ git add -A
$ git commit -m "first commit"
```  

以下のコマンドを実行して、COOKBOOK[httpd]を生成

```
$ knife cookbook create httpd -o site-cookbooks
$ ls site-cookbooks
httpd
```

httpd/recipe/default.rbをテキストエディタで開いて、以下の内容を追記します。

```
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
```

## 4-4.recipe適用を簡略化する  
Vagrantfileの内容を以下のように編集します。

```
 # -*- mode: ruby -*-
 # vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box_check_update = false
  config.vm.box = "centos66"
  config.vm.hostname = "test01"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provision "shell", inline: <<-SHELL
    chef_check=`rpm -qa | grep chef-12.2.1-1.el6.x86_64 | wc -l`
    if [ $chef_check -eq 0 ] ; then
      cp /vagrant/chef-12.2.1-1.el6.x86_64.rpm /tmp/chef-12.2.1-1.el6.x86_64.rpm
      rpm -i /tmp/chef-12.2.1-1.el6.x86_64.rpm
    fi
  SHELL
  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = ["../chef-repo/site-cookbooks"]
    chef.add_recipe "httpd"
  end
end
```

> 今回はvm.provisionに[chef-solo](http://docs.vagrantup.com/v2/provisioning/chef_solo.html)を指定していますが、
[chef-zero](http://docs.vagrantup.com/v2/provisioning/chef_zero.html)も指定可能です。  
chef-zeroについては第5回以降で解説します。

仮想サーバを新規で起動してchef-clientがインストールされて、recipeが適用されているか確認してみます。

```
$ cd ../vagrant
$ vagrant destroy
$ vagrant up
$ vagrant ssh
[vagrant@test01 ~]$ chef-client -v
[vagrant@test01 ~]$ yum list installed | grep httpd
[vagrant@test01 ~]$ sudo service httpd status
[vagrant@test01 ~]$ chkconfig --list httpd
[vagrant@test01 ~]$ curl http://localhost
```

