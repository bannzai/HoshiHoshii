#!/bin/bash
set -eu

echo 'Start `Apollo`'

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"
APOLLO_CODGEN_DIR="$(cd $SCRIPT_DIR && cd ApolloCodegen && pwd -P)"

# ApolloCodegen uses relative paths. So, move the path
cd $APOLLO_CODGEN_DIR
xcrun -sdk macosx swift run ApolloCodegen 
cd -
