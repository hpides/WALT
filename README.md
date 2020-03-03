# Whole system config
This script makes starting all services for development or productive usage easier. The docker-compose.yml contains a configuration that can bring up performance data storage and its required database with persistent storage, request generator, an apache serving the frontend and a correctly configured mqtt broker with a single command.

## Preparations
First of all, setup docker and docker-compose.
### pdgf (do this once)
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
├── run1.sh
├── run2.sh
├── run3.sh
├── Speedtest.xlsx
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
		<!-- <outputDir>/mnt/d/OneDrive/Bachelorprojekt/output/</outputDir>-->
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

### other services (do this every time one of them is changed)
- clone all other services of the project
- cd into the respective folder of each  project
- cd into the Docker subdirectory
- run build.sh

## Running the services
Run
```bash
docker-compose up
```
Hint: Refer to the docker-compose documentation for additional flags supported by docker-compose up.  
The frontend should be accessible at http://localhost:3000 and http://[*YOUR IP*]:3000.

## Stopping the services
Run
```bash
docker-compose down
```.
Use the -v flag to destroy all persistant data.
