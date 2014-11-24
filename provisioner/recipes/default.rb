include_recipe "serf"
include_recipe "docker"

docker_image "registry"

# setup docker registry
docker_container 'registry' do
  detach true
  port '5000:5000'
  env 'SETTINGS_FLAVOR=local'
  volume '/mnt/docker:/docker-storage'
  cmd_timeout 2400
end

# install build compiler
bash "install-build-compiler" do
  code <<BASH
cd /var/cache
curl -sL https://github.com/gosuri/build-compiler/archive/v0.0.1.tar.gz | tar xz
cd build-compiler-0.0.1
make install
BASH
end

file "/usr/local/bin/compile-app" do
  mode "744"
  content <<BASH
#!/usr/bin/env bash
build-compiler #{node[:app][:repo]}
id=$(docker run -td app-runtime /bin/bash)
docker export ${id} > app-runtime.tar
aws s3 cp app-runtime.tar s3://ap-workshop/app-runtime.tar --region us-east-1
docker rm -f ${id}
serf event deploy
BASH
end
