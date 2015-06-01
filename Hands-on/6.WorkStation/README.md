![Worktation](https://raw.github.com/wiki/urasoko/handson-repo/images/HandsOn-6-1.png)

# 1.環境準備

- 1-1.アカウント作成
- 1-2.chef-repo作成

# 2.WorkStation操作

- 2-1.bootstrap実行
- 2-2.COOKBOOKアップロード
- 2-3.chef-client実行

---

# 1.環境準備

---

## 1-1.アカウント作成

商用小山環境のChef-ServerのWEB-UIにアクセスして、Chef-Server上にアカウントを作成します。

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

## 2-1.bootstrap実行

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

---

## 2-2.COOKBOOKアップロード

![cookbook-upload](https://raw.github.com/wiki/urasoko/handson-repo/images/HandsOn-6-7.png)

chef-repo/cookbooks配下にCOOKBOOKを作成します。

```bash
$ cd chef-repo
$ knife cookbook create <username> -o cookbooks
```

> ChefServer上でCOOKBOOKの名前の競合を防ぐため、COOKBOOK名はusernameとします。

cookbooks/username/recipes/default.rbを以下のように修正しておきます。

```bash
log "test" do
  message "hogehoge"
  level :info
end
```

作成したCOOKBOOKをChefServerにアップロードします。

```bash
$ knife cookbook list
$ knife cookbook upload <username>
$ knife cookbook list
<username>
```

---

## 2-3.chef-client実行

![knife-ssh](https://raw.github.com/wiki/urasoko/handson-repo/images/HandsOn-6-8.png)

以下のコマンドを実行して、nodeのrun_listに作成したCOOKBOOKを追加します。

```bash
$ knife node list
$ knife node run_list add <node-name> <username>
$ knife node show <node-name>
```

以下のコマンドを実行してインスタンス上のchef-clientを実行します。

```bash
knife ssh <node-ip> "chef-client" -m -x root -i /root/.ssh/id_rsa
```

