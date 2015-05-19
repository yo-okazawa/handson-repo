![Worktation](https://raw.github.com/wiki/urasoko/handson-repo/images/HandsOn-6-1.png)

# 1.環境準備

- 1-1.アカウント作成
- 1-2.chef-repo作成
- 1-3.bootstrap実行

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

## 1-3.bootstrap実行

以下のコマンドを実行して、bootstrapを実行します。

```bash
$ knife bootstrap <node-ip> -x root -P <password> -t rhel
```

以下のコマンドを実行して、登録状態を確認します。

```bash
$ knife node list
$ knife client list
```


