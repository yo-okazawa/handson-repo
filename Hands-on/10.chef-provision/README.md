## 1.chef-provisioning

### 1-1.chef-provisioningとは

### 1-2.chef-provisioningの動作

### 1-3.chef-provisioningのresource

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
