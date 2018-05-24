#!/usr/bin/env bash

docker-yml() {
  docker inspect -f $'
{{.Name}}
  image: {{.Config.Image}}
  hostname: {{.Config.Hostname}}
  entrypoint: {{json .Config.Entrypoint}}
  mem_limit: {{.HostConfig.Memory}}
  cpu_shares: {{.HostConfig.CpuShares}}
  {{if .NetworkSettings.Ports}}ports: {{range $p, $conf := .NetworkSettings.Ports}}
    - {{(index $conf 0).HostIp}}:{{(index $conf 0).HostPort}}:{{$p}}{{end}}
  {{end}}
  {{if .Config.Env}}environment: {{range .Config.Env}}
    - {{.}}{{end}}
  {{end}}
  {{if .Config.Volumes}}volumes: {{range .Config.Volumes}}
    - {{.}}{{end}}
  {{end}}
  {{if .Config.Labels}}labels: {{range .Config.Labels}}
    - {{.}}{{end}}
  {{end}}
' $1
}

for i in $( docker ps --format "{{.ID}}" ); do
   docker-yml $i
done