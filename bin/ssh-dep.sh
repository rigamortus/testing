#!/usr/bin/env bash
set -euo pipefail
port=${port:-80}
prod="${shipit_prod_user:-$shipit_prod_user}"@"${shipit_prod_host:-$shipit_prod_host}"
staging="${shipit_staging_user:-$shipit_staging_user}"@"${shipit_staging_host:-$shipit_staging_host}"
image=${image:-rigamortus/newdocker234:15}
if [[ "$target" = "staging" ]]; then
    targetEnv="$staging"
else
    targetEnv="$prod"
fi
ssh -i "$keyfile" -o StrictHostKeyChecking=no "$targetEnv" <<EOF
set -euo pipefail
cd testing
git fetch
git reset --hard HEAD
git checkout -f origin/"$GIT_BRANCH"
docker pull "$image"
set -a
DOCKER_IMAGE="$image"
PORT="$port"
bin/restart.sh
EOF
