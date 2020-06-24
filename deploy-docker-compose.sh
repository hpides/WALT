#!/bin/sh
cd request-generator/Docker
echo Building request generator
./build.sh || exit $?
cd ../..
cd performance-data-storage/Docker
echo Building performance data storage
./build.sh || exit $?
cd ../..
cd configuration-ui/Docker
echo Building configuration ui
./build.sh || exit $?
cd ../..
docker-compose up -d || exit $?
