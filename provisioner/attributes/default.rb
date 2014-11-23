default[:docker].tap do |d|
  d[:init_type]           = "runit"
  d[:container_init_type] = "runit"
  d[:image_cmd_timeout]   = 2400
end

default[:rubyver] = "2.1.2"
default[:nodever] = "0.10.33"

# runtime
default[:packages][:runtime] = %w{
  zlib1g
  libssl1.0.0
  libreadline6
  libyaml-0-2
  sqlite3
  libxml2
  libxslt1.1
  libcurl3
}

# compile time
default[:packages][:buildtime] = %w{
  unzip 
  git
  git-core
  curl
  zlib1g-dev
  build-essential
  libssl-dev
  libreadline-dev
  libyaml-dev
  libsqlite3-dev
  sqlite3
  libxml2-dev
  libxslt1-dev
  libcurl4-openssl-dev
  python-software-properties
}

default[:app][:repo] = "https://github.com/gosuri/containers-demo-app.git"
