# Recipe to create a base container used for compiling the application

# install and configure docker
include_recipe "docker"

# create the directory to stage files 
# for the container
cachedir = "/var/containers/base"
directory(cachedir) do
  recursive true
  action :create
end

# create base dockerfile
template "#{cachedir}/Dockerfile" do
  source "base/Dockerfile.erb"
  variables({
    :packages     => node[:packages][:buildtime],
    :ruby_version => node[:rubyver],
    :node_version => node[:nodever]
  })
end

# build the base docker image
docker_image "app-base" do
  source cachedir
  action :build
  cmd_timeout 2400
end
