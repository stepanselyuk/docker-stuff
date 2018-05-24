#!/usr/bin/env bash

docker-yml() {
  docker inspect -f $'
{{.Name}}
  image: {{.Config.Image}}
  entrypoint: {{json .Config.Entrypoint}}
  environment: {{range .Config.Env}}
    - {{.}}{{end}}
' $1
}

for i in $( docker ps --format "{{.ID}}" ); do
   docker-yml $i
done