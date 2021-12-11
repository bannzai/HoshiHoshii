#! /bin/bash 
set -eu
set -o pipefail

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"
INFO_PLIST_PATH="$(cd $SCRIPT_DIR && cd ../HoshiHoshii && pwd -P)"

set +e
cp -i $INFO_PLIST_PATH/Info.plist.sample $INFO_PLIST_PATH/Info.plist 
set -e

printf "Start to replace from GITHUB_NOTIFICATION_MANAGER_URL_SCHEMA to %s for %s\n" $GITHUB_NOTIFICATION_MANAGER_URL_SCHEMA $INFO_PLIST_PATH/Info.plist

sed -i '' -e "s;GITHUB_NOTIFICATION_MANAGER_URL_SCHEMA;$GITHUB_NOTIFICATION_MANAGER_URL_SCHEMA;" $INFO_PLIST_PATH/Info.plist
