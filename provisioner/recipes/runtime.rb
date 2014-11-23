rubyver   = node[:rubyver]
nodever   = node[:nodever]

bundledir = "/app/vendor/bundle"
rubydir   = "/app/vendor/ruby/#{rubyver}"
nodedir   = "/app/vendor/node/#{nodever}" # execjs runtime
pkgs      = node[:packages][:runtime]
runtimedir = "#{Chef::Config[:file_cache_path]}/app-runtime"

directory(runtimedir) do
  action :create
end

# install and configure docker
include_recipe "docker"

# cache secrets base key
secrets_base = `cat #{runtimedir}/secrets_base`.strip
if secrets_base == ''
  secrets_base = `date +%s | sha256sum | base64 | head -c 64`.strip
  file "#{runtimedir}/secrets_base" do
    content secrets_base
  end
end

file "#{runtimedir}/Dockerfile" do
  content <<-EOM
FROM ubuntu
EXPOSE 9292

# Install runtime packages
RUN apt-get update && apt-get install -y #{pkgs.join(" ")}

# Set paths and environment variables
ENV PATH /app/bin:#{bundledir}/bin:#{rubydir}/bin:#{nodedir}/bin:$PATH
ENV GEM_PATH #{bundledir}/ruby/#{rubyver}
ENV RAILS_ENV production
ENV PORT 9292
ENV HOME /app
ENV SECRET_KEY_BASE #{secrets_base}

# copy application and dependencies
ADD app app

# remove write permissions
RUN chmod go-w -R /bin
RUN chmod go-w -R /lib
RUN chmod go-w -R /app/vendor
EOM
end

docker_image "app-runtime" do
  source "#{runtimedir}"
  action :build
  cmd_timeout 1200
end
