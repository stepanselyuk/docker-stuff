#!/bin/bash

echo "version: '2.3'"
echo "services:"

docker-yml() {
  /usr/bin/docker inspect -f $'
    {{.Name}}:
        image: {{.Config.Image}}
        container_name: {{.Name}}
        hostname: {{.Config.Hostname}}
        entrypoint: {{json .Config.Entrypoint}}
        {{- if .Config.Cmd}}
        command: {{range .Config.Cmd}}
            - {{.}}{{end}}
        {{- end}}
        mem_limit: {{printf "%s" .HostConfig.Memory}}
        cpu_shares: {{.HostConfig.CpuShares}}
        {{- if .NetworkSettings.Ports}}
        ports: {{range $p, $conf := .NetworkSettings.Ports}}
        {{- if $conf}}
            - "{{$p}}"{{end}}{{end}}
        {{- end}}
        {{- if .Config.Env}}
        environment: {{range .Config.Env}}
            - {{.}}{{end}}
        {{- end}}
        {{- if .Mounts}}
        volumes: {{range $key, $value := .Mounts}}
        {{- if $value}}
            - {{$value.Source}}:{{$value.Destination}}{{end}}{{end}}
        {{- end}}
        {{- if .Config.Labels}}
        labels: {{range $n, $v := .Config.Labels}}
            - {{$n}}: {{$v}}{{end}}
        {{- end}}
' $1
}

for i in $( /usr/bin/docker ps --format "{{.ID}}" ); do
   docker-yml ${i}
done

#{{- if .NetworkSettings.Ports}}
#ports: {{range $p, $conf := .NetworkSettings.Ports}}
#{{- if $conf}}
#    - "{{(index $conf 0).HostIp}}:{{(index $conf 0).HostPort}}:{{$p}}"{{end}}{{end}}
#{{- end}}