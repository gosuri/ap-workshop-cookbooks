default[:docker].tap do |d|
  d[:init_type]           = "runit"
  d[:container_init_type] = "runit"
  d[:image_cmd_timeout]     = 2400
  d[:container_cmd_timeout] = 2400
end


default[:serf][:event_handlers] = {
  "user:deploy" => "/etc/serf/handlers/user-deploy"
}

# generate new ones by going to https://discovery.etcd.io/new
default[:etcd][:discovery_url] = "https://discovery.etcd.io/3f9a759df1ab5c22929657b72fe15e65"
