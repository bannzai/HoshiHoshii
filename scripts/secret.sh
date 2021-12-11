#! /bin/bash 
set -eu
set -o pipefail

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"
SECRET_PATH="$(cd $SCRIPT_DIR && cd ../HoshiHoshii && pwd -P)"

set +e
cp -i $SECRET_PATH/Secret.swift.sample $SECRET_PATH/Secret.swift
set -e

echo 'Start replacing secret values'

sed -i '' -e "s;GITHUB_NOTIFICATION_MANAGER_URL_SCHEMA;$GITHUB_NOTIFICATION_MANAGER_URL_SCHEMA;" $SECRET_PATH/Secret.swift
sed -i '' -e "s/GITHUB_CLIENT_ID/$GITHUB_CLIENT_ID/" $SECRET_PATH/Secret.swift
sed -i '' -e "s/GITHUB_CLIENT_SECRET/$GITHUB_CLIENT_SECRET/" $SECRET_PATH/Secret.swift
