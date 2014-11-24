#
# Cookbook Name:: serf
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.


include_recipe "runit"

# fetch binary
remote_file "/var/cache/serf.zip" do
  source "https://dl.bintray.com/mitchellh/serf/0.6.3_linux_amd64.zip"
  action :create_if_missing
end

# Make sure unzip is available to us
package "unzip" do
  action :install
end

# extract
execute "unzip serf binary" do
  cwd "/usr/local/bin"
  command "unzip -qo /var/cache/serf.zip"
end

runit_service "serf" do
  default_logger true
end

if node[:serf][:cluster]
  execute "join-serf-cluster" do
    command "serf join #{node[:serf][:cluster]}"
  end
end
