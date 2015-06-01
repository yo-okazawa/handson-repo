# 1.リポジトリサーバについて

- 1-1.リポジトリサーバの用途
- 1-2.リポジトリサーバを活用したrecipe例

---

# 1.リポジトリサーバについて

---

## 1-1.リポジトリサーバの用途

インターネットに接続出来ないインスタンスに対して、必要なパッケージを提供します。
また、インターネット上に存在しないパッケージやファイルをリポジトリサーバに配置しておいて、利用することが可能です。

![Worktation](https://raw.github.com/wiki/urasoko/handson-repo/images/HandsOn-7-1.png)

> - chef-clientパッケージ

> - 各種ミドルウェアの特定のパッケージ

> - ruby gem

> - CentOSのyumリポジトリミラー

---

## 1-2.リポジトリサーバを活用したrecipe例

リポジトリサーバを活用したrecipeのサンプルとしてwordpressを解説します。

![Worktation](https://raw.github.com/wiki/urasoko/handson-repo/images/HandsOn-7-2.png)

リポジトリサーバを利用している部分

- wordpressのパッケージをリポジトリサーバから取得
- COOKBOOK[yum-repo]でyumのリポジトリとしてリポジトリサーバを登録(CentOSのみ)

以下のコマンドをWorkStation上で実行して、Chef-Server上にあるCOOKBOOK[wordpress]をダウンロードします。

```bash
$ cd /home/<username>/chef-repo
$ knife cookbook list
$ knife cookbook download wordpress
```

ダウンロードされたCOOKBOOKのrecipeを確認します。

*** wordpress/recipes/default.rb ***

- COOKBOOK[lamp]を呼び出し
- wordpressのパッケージをリポジトリサーバからダウンロード
- wordpressの動作に必要な各種設定

*** lamp/recipes/default.rb ***

- phpとapacheとmysqlのCOOKBOOKを呼び出し

*** php/recipes/default.rb ***

*** apache/recipes/default.rb ***

*** mysql/recipes/default.rb ***

- COOKBOOK[yum-repo]を呼び出し
- パッケージをyumでインストール
- 設定ファイルを配置
- サービスの起動と有効化(apache,mysqlのみ)

*** yum-repo/recipes/default.rb ***

- yumのリポジトリとして、リポジトリサーバを登録

実際にnodeに対して適用して動作を確認します。

```bash
$ knife node run_list add <nodename> wordpress
$ knife node show <node-name>
$ knife ssh <node-ip> "chef-client" -m -x root -i /root/.ssh/id_rsa
```

> 出力されたログを確認して、期待通りの動作がされていることを確認して下さい。

以下のURLにアクセスして、初期設定画面で必要な情報を入力して、正しく動作することを確認して下さい。

- http://node-ip/wdp/wp-admin/install.php

ChefServerのWEB-UIから適用状況の確認を行います。

WorkStationサーバ経由でChef-ServerのWEB-UIにポートフォワードの設定をします。

```bash
$ ssh -L 443:<Chef-ServerのVIP>:443 -l root <WorkStationサーバのIPアドレス>
```

端末のブラウザから"https://localhost/signup"にアクセスします。

Reportsのタブでchef-clientの実行結果を確認します。

