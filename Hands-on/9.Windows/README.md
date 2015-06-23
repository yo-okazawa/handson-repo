# Windows

## 1.Windows向けresource

- 1-1.windows_package
- 1-2.windows_service
- 1-3.powershell_script
- 1-4.dsc_resource
- 1-5.dsc_script
- 1-6.registry_key
- 1-7.COOKBOOK[windows]で提供されるresource

## 2.Windowsインスタンスのプロビジョニング

- 2-1.WindowsServerをbootstrap
- 2-2.COOKBOOK[windows-fileserver]を作成
- 2-3.recipeを適用する

## 3.PowerShell DSC

- 3-1.特徴
- 3-2.用語
- 3-3.環境準備
- 3-4.WindowsServer上でPowerShell DSCを実行する
- 3-5.ChefからPowerShell DSCを実行する

---

## 1.Windows向けresource

---

### 1-1.windows_package

- windows用のインストーラ(.msi)を操作するためのリソース
- インストーラのパッケージはremote_file等で取得してから利用する。
- packageリソースを使用しても、ohaiが収集したOSがwindowsなら、このリソースが使用される。

```ruby
windows_package 'example' do
  source 'C:\example.msi'
  action :install
end
```

---

### 1-2.windows_service

- windows用のサービスを操作するためのリソース
- serviceリソースを使用しても、ほぼ同様のことが可能だが、『startup_type :manual』はserviceリソースでは指定が出来ないため、windows_serviceを使用する必要がある。

```ruby
windows_service "example" do
  service_name "example_service"
  action :configure_startup
  startup_type :manual
end
```

---

### 1-3.powershell_script

- Power ShellスクリプトをChefで使用するためのリソース
- 冪等性を保つためには、not_ifやonly_ifを指定する必要がある。  
not_ifやonly_ifでPowerShellスクリプトを使用するためには、『guard_interpreter :powershell_script』と指定する。デフォルトはbatchを使用

```ruby
powershell_script "example" do
  code <<-EOH
     cp ~/data/nodes.json ~/data/nodes.bak
  EOH
  action :run
  guard_interpreter :powershell_script
  not_if 'test-path ~/data/nodes.bak'
end
```

---

### 1-4.dsc_resource

- PowerShell DSCのリソースをChefで使用するためのリソース
- DSC(Desired State Configuration)とは、PowerShell版のchefのようなもの
- Windows Management Framework (WMF) 5.0以上が必要。  
Windows Server 2012R2とWindows8.1の標準がWMF4.0のため、dsc_resourceを使用するためには、WMF 5.0をインストールする必要がある。
- ChefのDSLでDSCのリソースが利用できる。

```ruby
dsc_resource 'example' do
  resource :archive
  property :ensure, 'Present'
  property :path, "C:\Users\Public\Documents\example.zip"
  property :destination, "C:\Users\Public\Documents\ExtractionPath"
end
```

---

### 1-5.dsc_script

- PowerShell DSCのコードをChefで使用するためのリソース
- DSCの動作にWMF4.0以上が必要。  
Windows Server 2012R2とWindows8.1には標準でWMF4.0インストールされているが、それより以前のOSの場合には、別途インストールが必要。
- DSCのリソースをDSCのDSLで記述する。

```ruby
dsc_script 'example' do
  code <<-EOH
  Archive 'example'
  {
    Ensure = "Present"
    Path = "C:\Users\Public\Documents\example.zip"
    Destination = "C:\Users\Public\Documents\ExtractionPath"
  }
  EOH
end
```

---

### 1-6.registry_key

- Windowsのレジストリを操作するためのリソース
- 

```ruby
registry_key 'HKEY_LOCAL_MACHINE\EXAMPLE' do
  values [{ :name => 'Enabled', :type => :dword, :data => 1}]
  action :create
end
```

---

### 1-7.COOKBOOK[windows]で提供されるresource

[COOKBOOK[windows]](https://github.com/opscode-cookbooks/windows)はwindowsで使用するLWRPを提供するCOOKBOOKです。

***LWRPについて***

LWRP(light weight resource provider)とは・・・任意のリソースを定義して、Chefのリソースの書き方で使えるようにする機能です。

例えば以下のようなコードを

```ruby
bash 'hosts_entry' do
  code <<-EOH
    check = `grep /etc/hosts "2.3.4.5 www.example.com" | wc -l`
    if [check -eq 0] then ;
      echo "2.3.4.5 www.example.com" >> /etc/hosts
    fi
  EOH
end
```

以下のようにChefのresourceの書き方で使えるようにすることができます。

```ruby
hostsfile_entry '2.3.4.5' do
  hostname  'www.example.com'
  unique    true
end
```

COOKBOOK[windows]の使うには、COOKBOOK[windows]を取得してから、使いたいCOOKBOOKのmetadata.rb内で以下のように記述します。

```ruby
depends 'windows'
```

使用可能なresouceについては[リンク](https://github.com/opscode-cookbooks/windows)を参照して下さい。

※『2-2.COOKBOOK[windows-fileserver]を作成』では、COOKBOOK[windows]のwindows_featureリソースを使用します。

---

## 2.Windowsインスタンスのプロビジョニング

---

### 2-1.Windowsインスタンスをbootstrap

WorkStationにログインしてwindowsインスタンスをbootstrapします。

> Windowsインスタンスをbootstrapする場合にはknife bootstrap windowsコマンドを使用します。

```bash
# WorkStationにログイン
$ ssh root@<workstation ipaddress>
$ cd /home/<username>/chef-repo
# bootstrap前のnode,client listを確認
$ knife node list
$ knife client list
# bootstrap実行
$ knife bootstrap windows winrm <node ip> -x administrator -P <password> -d win -N <nodename>
# bootstrap後にnode,client listを確認
$ knife node list
$ knife client list
```

ChefServerのWEB-GUI上でnodeの状態を確認するために、ポートフォワードの設定をします。

```bash
# ローカル端末上で実施
$ ssh -L 443:<Chef-ServerのVIP>:443 -l root <WorkStationサーバのIPアドレス>
```

以下のURLにアクセスして、Nodesタブから登録したnodeの情報を確認します。

- https://localhost

---

2-2.COOKBOOK[windows-fileserver]を作成

windowsインスタンスをプロビジョニングするためのCOOKBOOKを作成します。

今回作成するCOOKBOOKの動作の概要は以下の通りです。

- SMBを使用して、特定のユーザーのみがアクセス可能な共有ディレクトリを作成する。(ファイルサーバ)
- 共有ディレクトリを使用するユーザーはパスワード付きで作成

以下のコマンドを実行してCOOKBOOKを作成します。

```bash
# workstationのchef-repoで実施
$ knife cookboook create <windows-fileserver-<username>> -o cookbooks
```

COOKBOOKの内容を以下のように修正します。

***metadata.rb***

以下を追記(COOKBOOK[windows]はChefserver上にアップロード済みです。)

```ruby
depends "windows"
```

***recipes/default.rb***

```ruby
# SMBのプロトコルをインストール
windows_feature "File-Services" do
  action :install
end

# ユーザを作成(パスワードは任意のものを指定して下さい)
user "test01" do
  password "hoge"
  action :create
end

# 共有するディレクトリを作成
directory "C:/test" do
  action :create
end

# 共有設定(共有名 => share  ディレクトリ => c:\test  ユーザー => test01 権限 => フルコントロール)
powershell_script "name_of_script" do
  code "New-SmbShare share C:\\test -FullAccess test01"
end

# firewall設定
execute "open firewall port" do
  command "netsh advfirewall firewall set rule \"name=ファイルとプリンターの共有 (SMB 受信)\" new enable=Yes"
end
```

---

### 2-3.recipeを適用する

以下のコマンドを実行して、nodeのrun_listに作成したCOOKBOOKを追加します。

```bash
# workstationのchef-repoで実施
$ knife node list
$ knife node show <node name>
$ knife node run_list add <node name> <cookbook name>
$ knife node show <node name>
```

以下のコマンドを実行して、node上でchef-clientを実行します。

```bash
$ knife winrm <node up> "chef-client" -m -x administrator -P 'password'
```

以下のコマンドを実行して、chef-clientの実行結果を確認します。

```bash
$ knife node list
$ knife runs list <node name>
$ knife runs show <run id>
```

ChefServerのWEB-UI上でも実行結果を確認して下さい。

ローカル端末からもファイル共有サーバにSMBアクセスが出来るかを確認して下さい。

---

## 3.PowerShell DSC

---

## 3-1.特徴
- Infrastructure as Code
- Declarative Syntax(宣言的構文)
- 冪等性
- クライアントレス(PowerShellがあれば動く)
- サーバ/クライアント構成はプッシュ型とプル型両方に対応

---

## 3-2.用語

- Resource(Chefのresourceに相当)  
> 標準では12種類のresourceが利用可能(ビルトインリソース)  
> 拡張resourceも利用することが可能（カスタムリソース）  
> 拡張resourceを独自に作成することも可能

- Configuration(Chefのrecipeに相当)

---

## 3-3.環境準備

powershell DSCはWindows Management Framework 4.0から追加された機能です。

WindowsServer2012R2とWindows8.1から標準でWMF4.0が搭載されています。

Windowsインスタンスにリモートデスクトップで接続して、WMFのバージョンを確認します。

- ローカル端末で以下のコマンドを実行してポートフォワードの設定をします。

```bash
$ ssh -L <local port>:<Windows IP>:3389 -l root <workstation IP>
```

- リモートデスクトップでWindowsインスタンスにログインします。(localhost:<local port>)

- Windowsインスタンスでpowershellを立ち上げて以下のコマンドを実行します。

```
> $PSVersionTable
```

3.0と表示された場合はWMF4.0をインストールする必要があります。

- WMF4.0をインストールします。Windowsインスタンス上でインストーラをダウンロードして、インストールして下さい。

> インストーラは以下のURLからダウンロード出来ます。  
> http://119.81.145.242/packages/chef/packages/Windows8-RT-KB2799888-x64.msu  
> http://www.microsoft.com/ja-jp/download/details.aspx?id=40855

WMF4.0をインストールするには.NET FrameWork4.5がインストールされている必要があります。

- .NET FrameWorkのバージョンを確認します。

- Windowsインスタンス上でサーバーマネージャーを起動し、『ローカルサーバー』の『役割と機能』欄に".net"と入力して、.NET FrameWork4.5が表示されれば、OKです。

> 表示されない場合には、『サーバーマネージャー』⇒『ダッシュボード』⇒『役割の機能と追加』から追加して下さい。

WMF4.0のインストールが完了したら、再度powershell上で"$PSVersionTable"を実行して、バージョンを確認します。

---

## 3-5.WindowsServer上でPowerShell DSCを実行する

- HOMEディレクトリ配下にpsというフォルダを作成して、psフォルダ配下にtest.ps1というファイルを作成します。

```PowerShell
# Windowsインスタンスのpowershell ISE上で実行
> cd ~/
> New-Item -ItemType Directory ps
> cd ps
> New-Item -ItemType file test.ps1
> Get-ChildItem
```

test.ps1を編集して以下のように変更します。

```PowerShell
Configuration "WebServer"
{

  Node "localhost"
  {
    WindowsFeature InstallWebServer
    {
      Ensure = "Present"
      Name  = "Web-Server"
    }
  }
}

WebServer -OutputPath . -Node localhost
Start-DscConfiguration -Path .\WebServer -Wait -Verbose
```

- 作成したpowershellスクリプトを実行します。

```PowerShell
> ./test.ps1
```

> 『このシステムではスクリプトの実行が無効~~』のエラーメッセージが出力された場合には、以下のコマンドで実行権限を変更します。

```PowerShell
# 現在の設定を確認
> Get-ExecutionPolicy
# スクリプトの実行権限をRemoteSignedに変更
> Set-ExecutionPolicy = RemoteSigned
:Y
# 変更後の設定を確認
> Get-ExecutionPolicy
```

- サーバーマネージャーから、IISがインストールされたことを確認して下さい。

- もう一度test.ps1を実行して、冪等性が保障されていることを確認します。

```PowerShell
> ./test.ps1
```

> IIS(Web-Server)は既にインストールされているため、インストールされません。

次項でChefからIISをインストールするため、一旦アンインストールしておきます。

- test.ps1のEnsure = の値をPresentからAbsentに変更して実行します。

test.ps1を編集して以下のように変更します。

```PowerShell
Configuration "WebServer"
{

  Node "localhost"
  {
    WindowsFeature InstallWebServer
    {
      Ensure = "Absent"
      Name  = "Web-Server"
    }
  }
}

WebServer -OutputPath . -Node localhost
Start-DscConfiguration -Path .\WebServer -Wait -Verbose
```

- 変更したtest.ps1を実行します。
```PowerShell
> ./test.ps1
```

---

## 3-6.ChefからPowerShell DSCを実行する

Chefのresource dsc_scriptを使用してIIS(WebServer)をインストールします。

- 以下のコマンドを実行して、COOKBOOKを作成します。

```bash
# workstationのchef-repo上で実施
$ knife cookbook create iis-<username> -o cookbooks
```

recipes/default.rbを以下のように編集します。

```ruby
dsc_script 'install IIS' do
  code <<-EOH
    WindowsFeature InstallWebServer
    {
      Ensure = "Present"
      Name  = "Web-Server"
    }
  EOH
end
```

COOKBOOK[iis]をnodeに適用します。

```bash
$ knife cookbook upload <cookbook name>
$ knife node run_list add <node name> <cookbook name>
$ knife winrm <node ip> "chef-client" -m -x administrator -P <password>
```

