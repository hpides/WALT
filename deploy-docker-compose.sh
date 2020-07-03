#!/bin/sh
#
# WALT - A realistic load generator for web applications.
#
# Copyright 2019-2020 Eric Ackermann <eric.ackermann@student.hpi.de>, Hendrik
# Bomhardt <hendrik.bomhardt@student.hpi.de>, Benito Buchheim
# <benito.buchheim@student.hpi.de>, Juergen Schlossbauer
# <juergen.schlossbauer@student.hpi.de>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# no pushing to the docker registry
unset deploy
# make sure the output dir exists 
mkdir pdgf-output 2>/dev/null
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
cd material-pdgf/Docker
echo Building material pdgf ui
./build.sh || exit $?
cd ../.
docker-compose up -d || exit $?
