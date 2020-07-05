# WALT
WALT (Web API Load Tester) is a realistic load generator for web applications. It consists of 6 microservices that deal with different tasks in the system. Their code is spread out to different subprojects.  
The scripts in this project make starting all services for development or productive usage easier. The docker-compose.yml contains a configuration that can bring up performance data storage and its required database with persistent storage, request generator, an apache serving the frontend and a correctly configured mqtt broker with a single command.  
Also, there is a script that automatically deploys all components into a Kubernetes cluster.

## Preparations
First of all, setup docker and docker-compose or Kubernetes, respectively.  
Second, after cloning this project, you need to initialise the contained submodules that hold WALTs components. Run
```bash
git submodule init  
git submodule update  
```  
See the [Git documentation](https://git-scm.com/book/en/v2/Git-Tools-Submodules) for reference.


## PDGF preparation (do this once)
Acquire PDGF and a valid license from [bankmark](https://www.bankmark.de/). Place it one directory up in the hierarchy in a pdgf directory (../pdgf). The structure of the directory should look something like this:
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
		<outputDir>/output/</outputDir>
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

Run docker-compose up to start WALT using the latest images from [Docker Hub](https://hub.docker.com/u/worldofjarcraft). Alternatively, use the provided script deploy-docker-compose.sh to build the images from source. It builds all components and starts them in detached state in docker-compose.  
Re-run this script every time one of the components is changed. Alternatively, you can change to the *Docker* subdirectory of the respective component and run build.sh.

### Running the services
Run
```bash
docker-compose up
```
Hint: Refer to the docker-compose documentation for additional flags supported by docker-compose up.  
The frontend should be accessible at http://localhost:3000 and http://[*YOUR PUBLIC IP*]:3000.

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
Run the deploy-kubernetes.sh script to deploy all components of WALT into a Kubernetes cluster. It assumes a working docker and kubectl command to be present and a docker registry running at *localhost:5000.* The option -r can be used to use a different docker registry.
Furthermore, you might want to replace the used address for Configuration UI (configui) with an actual domain. Change the line *host: configui* in configuration-ui/K8s/manifests/configui.yaml accordingly.  
Finally, use the option -d to build all images from source. If omited, the latest images from [Docker Hub](https://hub.docker.com/u/worldofjarcraft) will be used.
