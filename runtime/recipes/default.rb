#
# Cookbook Name:: runtime
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.
#
include_recipe "serf"
include_recipe "docker"

directory "/etc/serf/handlers" do
  recursive true
end

template "/etc/serf/handlers/user-deploy" do
  variables({:url => "https://s3.amazonaws.com/ap-workshop/app-runtime.tar"})
  mode "755"
end
