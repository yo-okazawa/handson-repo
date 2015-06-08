![Worktation](https://raw.github.com/wiki/urasoko/handson-repo/images/HandsOn-6-1.png)

# 1.環境準備

- 1-1.アカウント作成
- 1-2.chef-repo作成

# 2.WorkStation操作

- 2-1.bootstrapとは
- 2-2.bootstrap実行
- 2-3.COOKBOOKアップロード
- 2-4.chef-client実行

---

# 1.環境準備

---

## 1-1.アカウント作成

Chef-ServerのWEB-UIにアクセスして、Chef-Server上にアカウントを作成します。

WorkStationサーバ経由でChef-ServerのWEB-UIにポートフォワーディングの設定をします。

```bash
$ ssh -L 443:<Chef-ServerのVIP>:443 -l root <WorkStationサーバのIPアドレス>
```

端末のブラウザから"https://localhost/signup"にアクセスします。

![signup](https://raw.github.com/wiki/urasoko/handson-repo/images/HandsOn-6-2.png)

必要事項を入力して、Get Startedをクリックします。

![organization](https://raw.github.com/wiki/urasoko/handson-repo/images/HandsOn-6-3.png)

organizationは共通のものを使用するので、新規作成はせずにinviteが届くまで待ちます。

Inviteが届いたらAccept Invitationsをクリックします。

![reset-key](https://raw.github.com/wiki/urasoko/handson-repo/images/HandsOn-6-4.png)

Administration -> Users -> ユーザーを選択 -> Reset Keyの順番にクリックして、keyファイルをダウンロードしておきます。

![knife-config](https://raw.github.com/wiki/urasoko/handson-repo/images/HandsOn-6-5.png)

Administration -> Organizations -> organizationを選択 -> Generate Knife Configの順番にクリックして、knife.rbファイルをダウンロードしておきます。

---

## 1-2.chef-repo作成

WorkStationサーバにログインして/home配下にユーザーごとのディレクトリを作成します。

```bash
$ ssh -l root@<WorkStationサーバのIPアドレス>
$ cd /home
$ mkdir <username>
$ cd <username>
```

以下の構造になるようにchef-repoを作成します。

```bash
/home/<username>/chef-repo/
┠ .chef/
┃  ┠ bootstrap/
┃  ┃  ┠  rhel.erb
┃  ┃  ┗  win.erb
┃  ┠  chef-study-validator.pem
┃  ┠  <username>.pem
┃  ┗  knife.rb
┗cookbooks/
```

> rhel.erb、win.erb、chef-study-validator.pemは/etc/chef配下に保存してあります。

```bash
$ mkdir chef-repo
$ mkdir chef-repo/.chef
$ mkdir chef-repo/.chef/bootstrap
$ mkdir chef-repo/cookbooks
$ cp /etc/chef/chef-study-validator.pem chef-repo/.chef/chef-study-validator.pem
$ cp /etc/chef/rhel.erb chef-repo/.chef/bootstrap/rhel.erb
$ cp /etc/chef/win.erb chef-repo/.chef/bootstrap/win.erb
```

>knife.rbと<username>.pemは1-1でダウンロードしたファイルを転送して配置して下さい。

```bash
(ローカル端末で実施)
$ scp <knife.rbへのパス> root@<WorkStationサーバのIPアドレス>:/home/<username>/chef-repo/.chef/knife.rb
$ scp <<username>.pemへのパス> root@<WorkStationサーバのIPアドレス>:/home/<username>/chef-repo/.chef/<username>.pem
```

Chef-ServerとリポジトリサーバのSSL証明書を信頼済みの証明書として登録するため、以下のコマンドを実施します。

```bash
(WorkStationサーバ上で実施)
$ cd chef-repo
$ knife ssl check
$ knife ssl fetch
$ knife ssl check -s https://chefrepo.cloud-platform.kddi.ne.jp
$ knife ssl fetch -s https://chefrepo.cloud-platform.kddi.ne.jp
```

以下のコマンドを実行して、Chef-Serverと通信が出来ることを確認します。

```bash
$ knife client list
```

---

# 2.WorkStation操作

---

## 2-1.bootstrapとは

bootstrapとはnode上にchef-clientをインストールするための、一般的な方法です。
デフォルトでは、nodeはChefのWEBサイトからchef-clientパッケージをダウンロードするため、
nodeからChefのWEBサイトにアクセスできる必要があります。

[リンク](https://docs.chef.io/_images/chef_bootstrap.png)の図はknife bootstrapの動作順序を示したものです。

リンクの図を解説します。

### $ knife bootstrap

WorkStationからknife bootstrapコマンドを発行します。
ターゲットとなるnodeのIPアドレス、またはFQDNを引数としてコマンドを発行します。
ポート22番を使用して、ターゲットとなるnodeとの間にsshコネクションを確立します。
ブートストラップテンプレートを使用して、シェルスクリプトが組み立て立てられ、node上で実行されます。
Windowsのnodeの場合にはknife bootstrap windows winrmコマンドを使用し、
シェルスクリプトの代わりにバッチを使用します。
また、接続にはWinRMのポート(5985)を使用します。

### Get the install script from Chef

ブートストラップテンプレートの内容を元に、ChefのWEBサイトからchef-clientパッケージを取得します。

### Install the chef-client

node上でchef-clientパッケージをインストールします。

### Start the chef-client run
first-boot.json内に書かれた設定でchef-clientを実行します。
first-boot.jsonはブートストラップテンプレートの内容を元にWorkStationで生成されます。

### Complete the chef-client run

chef-clientがChefServerにHTTPS(443)を使用して、node登録をします。
通常、初回chef-client実行時はrun_listに何も入っていない状態ですが、
bootstrap時に--run_listオプションを追加することによって、run_listを指定することが出来ます。


### カスタムテンプレートについて

環境に合わせてbootstrapの挙動を変更させるために、カスタムテンプレートを使用します。  
デフォルトのブートストラップテンプレートとの変更点は以下の通りです。

- /etc/hostsにChef-ServerとリポジトリサーバのVIPを登録
- chef-clientのパッケージ取得先としてリポジトリサーバを指定

## 2-2.bootstrap実行

![bootstrap](https://raw.github.com/wiki/urasoko/handson-repo/images/HandsOn-6-6.png)

以下のコマンドを実行して、bootstrap時の認証に使用するWorkStationの公開鍵をインスタンスに登録しておきます。

```bash
$ ssh-copy-id -i /root/.ssh/id_rsa.pub root@<node-ip>
```

以下のコマンドを実行して、bootstrapを実行します。

> nodeにchef-clientをインストール  
> ChefServerにnodeを登録

```bash
$ knife bootstrap <node-ip> -x root -i /root/.ssh/id_rsa -t rhel
```

以下のコマンドを実行して、登録状態を確認します。

```bash
$ knife node list
$ knife client list
```

ChefServerのWEB-UI上でNodesタブをクリックして、bootstrapしたnodeが登録されていることと、対象nodeのAttributesを確認して下さい。

---

## 2-3.COOKBOOKアップロード

![cookbook-upload](https://raw.github.com/wiki/urasoko/handson-repo/images/HandsOn-6-7.png)

chef-repo/cookbooks配下にCOOKBOOKを作成します。

```bash
(WorkStationサーバ上のchef-repoで実施)
$ knife cookbook create <username> -o cookbooks
```

> ChefServer上でCOOKBOOKの名前の競合を防ぐため、COOKBOOK名はusernameとします。

cookbooks/username/recipes/default.rbを以下のように修正しておきます。

```bash
ruby_block "run_count" do
  block do
    unless node["run_count"]
      node.set["run_count"] = 1
    else
      node.set["run_count"] = node["run_count"] + 1
    end
  end
  action :run
end
```

作成したCOOKBOOKをChefServerにアップロードします。

```bash
$ knife cookbook list
$ knife cookbook upload <username>
$ knife cookbook list
<username>   0.1.0
```

---

## 2-4.chef-client実行

![knife-ssh](https://raw.github.com/wiki/urasoko/handson-repo/images/HandsOn-6-8.png)

以下のコマンドを実行して、nodeのrun_listに作成したCOOKBOOKを追加します。

```bash
$ knife node list
$ knife node show <node-name>
$ knife node run_list add <node-name> <username>
$ knife node show <node-name>
```

以下のコマンドを実行してインスタンス上のchef-clientを実行します。

```bash
$ knife ssh <node-ip> "chef-client" -m -x root -i /root/.ssh/id_rsa
```

以下のコマンドを実行して、nodeのattributeにrun_countがセットされたことを確認します。

```bash
$ knife search "name:*" --attribute "run_count"
```

ChefServerのWEB-UI上で、対象nodeのAttributesにrun_countが追加されたことを確認して下さい。

