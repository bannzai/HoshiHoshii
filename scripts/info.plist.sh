#! /bin/bash 
set -eu
set -o pipefail

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"
INFO_PLIST_PATH="$(cd $SCRIPT_DIR && cd ../HoshiHoshii && pwd -P)"

set +e
cp -i $INFO_PLIST_PATH/Info.plist.sample $INFO_PLIST_PATH/Info.plist 
set -e


sed -i '' -e "s;OAUTH_CALL_BACK_URL_SCHEME;$OAUTH_CALL_BACK_URL_SCHEME;" $INFO_PLIST_PATH/Info.plist
