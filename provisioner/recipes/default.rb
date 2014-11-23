include_recipe "provisioner::etcd"
include_recipe "provisioner::base"

# install build compiler
bash "install-build-compiler" do
  code <<BASH
cd /var/cache
test -d "./build-compiler" && rm -rf ./build-compiler
git clone https://github.com/gosuri/build-compiler.git 
cd build-compiler
make install
BASH
end

file "/usr/local/bin/compile-app" do
  mode "744"
  content <<BASH
#!/usr/bin/env bash
build-compiler #{node[:app][:repo]}
BASH
end


# include_recipe "provisioner::runtime"
