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



