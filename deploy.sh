#!/bin/bash

set -e
set -u
set -o pipefail
set -o posix

export account=hubcapp
export domain=hubc.app
export domain_clean=hubc-app
export port=8043

export git_hash=$(git rev-parse --short HEAD)
export repository=registry.digitalocean.com/hubcapp/static
export latest_tag="$repository:$domain"
export hashed_tag="$latest_tag-$git_hash"

docker build . -t "$hashed_tag"
docker tag "$hashed_tag" "$latest_tag"
docker push "$hashed_tag"
docker push "$latest_tag"

for file in kube/*.yaml; do
    cat "$file"
    echo
    echo ---
    echo
done | envsubst | kubectl apply -f -
