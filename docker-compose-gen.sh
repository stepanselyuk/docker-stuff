#!/bin/bash

docker-yml() {
  /usr/bin/docker inspect -f $'
{{.Name}}
  image: {{.Config.Image}}
  hostname: {{.Config.Hostname}}
  entrypoint: {{json .Config.Entrypoint}}
  mem_limit: {{printf "%.f" .HostConfig.Memory}}
  cpu_shares: {{.HostConfig.CpuShares}}
  {{- if .NetworkSettings.Ports}}
  ports: {{range $p, $conf := .NetworkSettings.Ports}}
    - {{(index $conf 0).HostIp}}:{{(index $conf 0).HostPort}}:{{$p}}{{end}}
  {{- end}}
  {{- if .Config.Env}}
  environment: {{range .Config.Env}}
    - {{.}}{{end}}
  {{- end}}
  {{- if .Config.Volumes}}
  volumes: {{range .Config.Volumes}}
    - {{.}}{{end}}
  {{- end}}
  {{- if .Config.Labels}}
  labels: {{range $n, $v := .Config.Labels}}
    - {{$n}}: {{$v}}{{end}}
  {{- end}}
' $1
}

for i in $( /usr/bin/docker ps --format "{{.ID}}" ); do
   docker-yml $i
done