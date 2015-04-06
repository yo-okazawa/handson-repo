#
# Cookbook Name:: knife-windows
# Recipe:: attributes/default.rb
#

default["knife-windows"]["package"] = [
  "libxml2-devel",
  "gcc",
  "gcc-c++",
  "patch"
]

default["knife-windows"]["gem-list"] = [
  "akami-1.3.0.gem",
  "builder-3.2.2.gem",
  "em-winrm-0.6.0.gem",
  "eventmachine-1.0.7.gem",
  "ffi-1.9.8.gem",
  "gssapi-1.0.3.gem",
  "gyoku-1.3.0.gem",
  "httpclient-2.6.0.1.gem",
  "httpi-0.9.7.gem",
  "knife-windows-0.8.4.gem",
  "little-plugger-1.1.3.gem",
  "logging-1.8.2.gem",
  "mini_portile-0.6.2.gem",
  "mixlib-log-1.6.0.gem",
  "multi_json-1.11.0.gem",
  "nokogiri-1.6.6.2.gem",
  "nori-1.1.5.gem",
  "rack-1.6.0.gem",
  "rubyntlm-0.1.1.gem",
  "savon-0.9.5.gem",
  "uuidtools-2.1.5.gem",
  "wasabi-1.0.0.gem",
  "winrm-1.2.0.gem",
  "winrm-s-0.2.4.gem"
]

default["knife-windows"]["repo-url"] = "https://chefrepo.cloud-platform.kddi.ne.jp/packages/chef"
default["knife-windows"]["repo-gem"] = "gems"
default["knife-windows"]["gem-dir"] = "/tmp/gems"
