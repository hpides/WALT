# Whole system config
This scripts make starting all services for development or productive usage easier. The docker-compose.yml contains a configuration that can bring up performance data storage and its required database with persistent storage, request generator, an apache serving the frontend and a correctly configured mqtt broker with a single command.  
Also, there is a script that automatically deploys all components into a Kubernetes cluster.

## Preparations
First of all, setup docker and docker-compose or Kubernetes, respectively.  
Second, after cloning this project, you need to initialise the contained submodules that hold WALTs components. Run
```bash
git submodule init  
git submodule update  
```  
See the (GIT configuration)[https://git-scm.com/book/en/v2/Git-Tools-Submodules] for reference.


## PDGF preparation (do this once)
Acquire PDGF and a valid license. Place it one directory up in the hierarchy in a pdgf directory (../pdgf). The structure of the directory should look something like this:
```
├── config
│   ├── customer-output.xml
├── Constants.properties
├── dicts
    ...
├── documents
    ...
├── extlib
    ...
├── LICENSE.txt
├── Log4j.xml
├── logs
├── output
├── pdgf.jar
└── THIRD-PARTY-LICENSE.txt
```
With the following being the content of config/customer-output.xml:
```xml
<?xml version="1.0" encoding="UTF-8"?>

<!--
/*******************************************************************************
 * Copyright (c) 2013, bankmark and/or its affiliates. All rights reserved.
 * bankmark UG PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 *
 *
 ******************************************************************************/
-->
<generation>

	<!-- DEFAULT Scheduler for all Tables, if no table specific scheduler is specified-->
	<scheduler name="DefaultScheduler"></scheduler>
	<!-- DEFAULT output for all Tables, if no table specific output is specified-->
	<output name="CSVRowOutput">
		<fileTemplate>outputDir + table.getName() + fileEnding</fileTemplate>
		<outputDir>/pdgf/output/</outputDir>
		<fileEnding>.csv</fileEnding>
		<charset>UTF-8</charset>
		<sortByRowID>true</sortByRowID>
	</output>

	<schema name="default">
		<tables>
		</tables>
	</schema>

</generation>

```

## Using docker-compose

### other services preparation (do this every time one of them is changed)
- clone all other services of the project
- cd into the respective folder of each  project
- cd into the Docker subdirectory
- run build.sh

### Running the services
Run
```bash
docker-compose up
```
Hint: Refer to the docker-compose documentation for additional flags supported by docker-compose up.  
The frontend should be accessible at http://localhost:3000 and http://[*YOUR IP*]:3000.

### Stopping the services
Run
```bash
docker-compose down
```
Use the -v flag to destroy all persistent data.

## Using Kubernetes

Please replace *path: /home/worldofjarcraft/pdgf* in *request-generator/K8s/manifests/persistentVolume.yaml* by the installation directory of your PDGF instance if you would like to mount PDGF into the cluster from the local file system. If you use a multi-node cluster and only one node has a PDGF installation, execute the Kubernetes setup on this node.  
Alternatives to this PDGF mounting might be using a different kind of PV (e.g. a Gluster volume) which requires adapting Request Generator's Kubernetes configurations accordingly. Also, one could add copying PDGF into Request Generator's container to the Dockerfile of Request Generator.  
Note that Performance Data Storage currently is shipped with a PostgreSQL database that also needs persistent storage. Performance Data Storage is optional however, WALT can work without it.  
Run the deploy-kubernetes.sh script to deploy all components of WALT into a Kubernetes cluster. It assumes a working docker and kubectl command to be present and a docker registry running at *localhost:5000.* Again, you will need to adapt the configuration scripts if your configuration differs.



