#!/bin/sh

# Argparsing based on https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
namespace="walt"
verbose=0

while getopts "h?:n:" opt; do
    case "$opt" in
    h|\?)
        printf "NOPE!"
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
./deploy.sh
cd ../../performance-data-storage/K8s
echo Deploying Performance Data Storage
./deploy.sh
cd ../../configui/K8s
echo Deploying Configuration UI
./deploy.sh
cd ../..
