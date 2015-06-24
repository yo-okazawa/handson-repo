## 1.chef-provisioning

### 1-1.chef-provisioningとは

### 1-2.chef-provisioningの動作

### 1-3.chef-provisioningのresource

### 1-4.chef-provisioningを使ってみる

---

## 1.chef-provisioning

---

### 1-1.chef-provisioningとは

クラスタ全体の操作に特化したchefの機能。

クラウド、ベアメタル、仮想マシン、コンテナのクラスタに対して作成～収束までをコードで記述することが出来ます。

例えば、LB1台とWEBサーバ2台とDBサーバ2台のクラスタを構成する場合、サーバを作成->ミドルウェアのインストール->取得したIPアドレスを別のサーバに認識させるといった作業が必要になりますが、chef-provisioningを使用すれば、サーバ作成～収束までを自動化することが可能になります。

また、多くのクラウド、仮想マシン、コンテナ用の動作するための拡張可能なドライバ機構を持っているため、複数環境へのデプロイが可能になります。

---

### 1-2.chef-provisioningの動作

- workstationとなる端末上でchef-clientのローカルモードでchef-provisioning用のrbファイルを指定して実行します。

> workstation上でchef-zeroのchefサーバが起動し、nodeとなる端末はworkstationをchefサーバとして動作します。

- (インスタンス作成)

- nodeにchef-clientをインストール(chef.ioからomnibusインストーラをダウンロード)

> node上の動作としては、通常のchef-clientの動作(サーバ/クライアント構成)と同様になります。

- chef-client実行、recipe適用、workstationを介してnodeの情報/ファイルをやり取りして収束へ


---

### 1-3.chef-provisioningのresource

- machine

仮想マシンの作成/破棄と収束を行います。また、他のリソースからmachineを操作/参照するための識別子を返します。

```ruby
# 予め指定しておいたproviderで仮想マシンcent01というhostnameで作成/起動
machine "x" do
  name "cent01"
  action :allocate
end
```

- machine_batch

パラレルで仮想マシンの作成/破棄と収束を行います。平行で動作するため、複数端末を操作する場合にmachine resourceよりも早く収束します。

```ruby
# 複数マシンをパラレルで作成
machine_batch do
  action :allocate
  machine "a" , "b" , "c"
end

# dbとwebをパラレルで作成
machine_batch do
  action :converge
  machine "db" do
    recipe "database"
  end
  machine "web" do
    recipe "webserver"
  end
end
```

- machine_execute

指定したmachine上で任意のコマンドを実行します。recipeで利用するexecuteリソースと同じように使用出来ます。

```ruby
# machine x上でコマンド"echo hoge"を実行します。
machine "x" do
  action :allocate
end
machine_execute "example" do
  action :run
  machine "x"
  command "echo hoge"
end
```

- machine_file

workstationとmachine間でファイルのアップロード、ダウンロードを行います。

```ruby
# machine xの/tmp/test.txtをmachine yの/tmp/test.txtに転送します。
machine_batch do
  action :allocate
  machine "x", "y"
end

machine_file "test.txt" do
  machine "x"
  action :download
  localpath "test.txt"
end

machine_file "test.txt" do
  machine "y"
  action :upload
  localpath "test.txt"
end
```

- machine_image

仮想マシンのイメージの取得、削除、イメージから仮想マシンの展開を行います。

```ruby
# machine イメージを作成
machine_image "example_image" do
  recipe "example"
  action :create
end
# 作成したイメージを使用して起動
machine "x" do
  from_image "example_image"
end
```

---

### 1-4.chef-provisioningを使ってみる

chef-provisioningを実際に動作させてみましょう。今回は既に立ち上がっているnodeに対してchef-provisioningを使用するため、ドライバはchef-provisioning-sshを使用します。

今回はWorkstationサーバ上でchef-provisioningを動作させて、複数のlinuxインスタンスに対して操作を行います。

Workstationサーバの/home/<username>/chef-repoにprovision.rbを作成します。

```ruby
cd /home/<username>/chef-repo
vi provision.rb
```
provision.rbの内容は以下の通りです。

***provision.rb***

```ruby
# chef-provisioningをロード
require 'chef/provisioning'
# chef-provisioning-sshをロード
require 'chef/provisioning/ssh_driver'
# ドライバの指定
with_driver 'ssh'

# host01のIPアドレスを記載
host01 = "<ipaddress>"
# host02のIPアドレスを記載
host02 = "<ipaddress>"

# host01をmachineとして登録
machine "host01" do
  machine_options :transport_options => {
    :ip_address => host01,
    :username => 'root',
    :ssh_options => {
      :keys => ['~/.ssh/id_rsa']
    }
  }
  action :allocate
end

# host01をmachineとして登録
machine "host02" do
  machine_options :transport_options => {
    :ip_address => host02,
    :username => 'root',
    :ssh_options => {
      :keys => ['~/.ssh/id_rsa']
    }
  }
  action :allocate
end

%w{ host01 host02 }.each do | host |

  # machine_fileリソースを使用してnodeにchef-clientのパッケージを転送
  machine_file "/tmp/chef-12.2.1-1.el6.x86_64.rpm" do
    machine host
    local_path "/root/chef-12.2.1-1.el6.x86_64.rpm"
    action :upload
  end
  # machine_executeリソースを使用して、chef-clientをインストールする
  machine_execute "install chef-client" do
    command "[ `rpm -qa | grep chef-12.2.1 | wc -l` -eq 0 ] && rpm -i /tmp/chef-12.2.1-1.el6.x86_64.rpm || exit 0"
    machine host
    action :run
  end
  
  # nodeをconvergeする(chef-client実行)
  machine host do
    # recipeを適用する場合は以下のように書く
    # recipe 'example::default'
    action :converge
  end
  
end
```

以下のコマンドを実行してchef-provisioningを実行します。

```bash
$ chef-client -z provision.rb
```

> workstation上でchef-zeroが起動 -> machine allocate -> インストーラ転送 -> chef-clientインストール -> machine converge していることが出力から確認できます。

chef-provisioning実行後、カレントディレクトリにnodesディレクトリが作成され、その配下にそれぞれのnodeのnodeオブジェクトjson形式のファイルで格納されます。

```bash
$ cd nodes
$ cat host01.json
$ cat host02.json
```
