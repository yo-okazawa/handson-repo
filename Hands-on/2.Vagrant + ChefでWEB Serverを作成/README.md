# 1.Vagrant環境の作成
- 1-1.Virtual Boxのインストール
- 1-2.Vagrantのインストール
- 1-3.Boxの準備

# 2.Vagrant操作
- 2-1.仮想サーバの起動
- 2-2.仮想サーバへの接続
- 2-3.仮想サーバの停止、破棄

---

# 1.Vagrant環境の作成

## 1-1.Virtual Boxのインストール  
[こちら](https://www.virtualbox.org/wiki/Downloads)からインストーラをダウンロードして、インストーラの指示にしたがってインストールして下さい。  
> Windowsの場合⇒VirtualBox x.x.x for Windows hosts  
> Macの場合⇒VirtualBox x.x.x for OS X hosts  
> ※一時的にPCのネットワークが切断されます。

## 1-2.Vagrantのインストール  
[こちら](https://www.vagrantup.com/downloads.html)からインストーラをダウンロードして、インストーラの指示にしたがってインストールして下さい。  
> Windowsの場合⇒WINDOWS Universal (32 and 64-bit)  
> Macの場合⇒MAC OS X Universal (32 and 64-bit)  
> ※PC再起動が必要になります。

## 1-3.Boxの準備  
[こちら](https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box)からboxをダウンロードして保存して下さい。（どうしても遅い時は[こちら](https://119.81.145.242/packages/chef/boxes/centos65-x86_64-20140116.box)）  
ターミナル(コマンドプロンプト)上で以下のコマンドを実行して、VagrantにダウンロードしたBoxを追加します。  
```
$ vagrant box add centos65 <Boxファイルへのパス>
```
以下のコマンドを実行してBoxが追加されたことを確認します。  
```
$ vagrant box list
centos65 (virtualbox, 0)
```
---
# 2.Vagrant操作

## 2-1.仮想サーバの起動  
仮想サーバを起動するためのディレクトリを作成して下さい。  
> * 場所はどこでも可  
* 名前は統一で『vagrant』として下さい。


```
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

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
  end

  config.vm.box = "centos65"
  config.vm.hostname = "test01"
  config.vm.network "private_network", ip: "192.168.33.101"
end
```

以下のコマンドを実行して、仮想サーバを起動します。

```
$ vagrant up
```

---

