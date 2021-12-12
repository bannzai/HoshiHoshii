#! /bin/bash 
set -eu
set -o pipefail

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"
SECRET_PATH="$(cd $SCRIPT_DIR && cd ../HoshiHoshii && pwd -P)"

set +e
cp -i $SECRET_PATH/Secret.swift.sample $SECRET_PATH/Secret.swift
set -e

echo 'Start replacing secret values'

sed -i '' -e "s;APP_GITHUB_OAUTH_CALLBACK_URL;$APP_GITHUB_OAUTH_CALLBACK_URL;" $SECRET_PATH/Secret.swift
