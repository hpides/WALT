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

# Argparsing based on https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
namespace="walt"
verbose=0

while getopts "h?:n:" opt; do
    case "$opt" in
    h|\?)
        printf "Deploy all components of WALT to a Kubernetes cluster. Use the -n option of this script to set the namespace to be used. Default namespace is \"walt\".\n"
        exit 0
        ;;
    n)  namespace=$OPTARG
        ;;
    esac
done

echo Using Namespace $namespace
export NAMESPACE=$namespace
kubectl get ns | grep $NAMESPACE || kubectl create ns $NAMESPACE
cd request-generator/K8s
echo Deploying Request Generator
./deploy.sh || exit $?
cd ../../performance-data-storage/K8s
echo Deploying Performance Data Storage
./deploy.sh || exit $?
cd ../../configuration-ui/K8s
echo Deploying Configuration UI
./deploy.sh || exit $?
cd ../../material-pdgf/K8s
echo Deploying Material PDGF UI
./deploy.sh || exit $?
cd ../..
