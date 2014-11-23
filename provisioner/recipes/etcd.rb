# installs and configure etcd

include_recipe "runit"

bash "install-etcd" do
  code <<BASH
cachedir=/var/cache/etcd

# create the directory if it doesnt exist
[ ! -d $cachedir ] && mkdir -p $cachedir
cd $cachedir

# download if not downloaded
if [ ! -d etcd-v0.5.0-alpha.3-linux-amd64 ]; then
  curl -Ls https://github.com/coreos/etcd/releases/download/v0.5.0-alpha.3/etcd-v0.5.0-alpha.3-linux-amd64.tar.gz | tar xz
fi

cd etcd-v0.5.0-alpha.3-linux-amd64
cp etcd /usr/local/bin
cp etcdctl /usr/local/bin
BASH

 not_if "type etcd > /dev/null" 
end

runit_service "etcd" do
  default_logger true
end

# installs nginx with lua module

bash "install_nginx" do
  code <<EOM
cachedir=/var/cache/nginx

# create the directory if it doesnt exist
[ -d $cachedir ] && mkdir -p $cachedir
cd $cachedir

curl -s http://nginx.org/download/nginx-1.6.0.tar.gz | tar xv
EOM
  action :nothing
end
