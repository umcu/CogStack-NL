# CogStack-NL
This repository is a fork of [CogStack-NiFi](https://github.com/CogStack/CogStack-NiFi) and includes a minimal Docker Compose deployment to deploy the essential components to process Dutch electronic health records.

Additions in this fork compared to the original repository:
- Dutch test data.
- De-identification using DEDUCE.
- MedCATService image with configuration for Dutch spaCy model.
- MedCAT models and configuration suitable for Dutch language.
- Apache NiFi template of a data-flow that:
  - Extracts data from a database
  - Applies de-identification method DEDUCE
  - Applies entity recognition and linking using MedCAT
  - Saves the output in OpenSearch

The upstream repository contains components and configuration which are not required for a minimal deployment for processing Dutch documents, so these components and configurations are omitted from deployment plan of this fork. Examples of omitted components: Apache Tika, Jupyter Hub and unused NLP methods for English language.

Documentation for starting the Dutch CogStack components has been added on top of the original README. The complete CogStack-Nifi documentation, which includes a security section useful for production deployment, can be found at https://cogstack-nifi.readthedocs.io.

## Table of Contents
- [Deployment](#deployment)
- [Apache NiFi](#apache-nifi)
- [De-identification](#de-identification)
- [MedCAT](#medcat)
- [OpenSearch and OpenSearch Dashboards](#opensearch-and-opensearch-dashboards)
- [Fork maintenance](#fork-maintenance)

## Deployment
The upstream CogStack-NiFi repository uses `Makefile`, `services.yml` and component `.env` files to configure and deploy the CogStack components. While rebasing on the upstream branch, we often ran into merge conflicts for `services.yml` because it contained site specific configuration. Therefore this repository contains an independent `docker-compose.yml` and `.env-example`-file  which should be flexible enough to work without changes at different sites, because all configuration can be set in a git-ignored `.env`-file.

To deploy the CogStack-NL components:
1. Clone this repository.
1. Navigate to `deploy/`.
1. Create an `.env` file
```bash
cp .env-example .env
```
1. For site specific configuration, modify `.env`
1. Start the docker containers
```bash
docker-compose up -d
```

## Apache NiFi
Apache NiFi is used to create and control data-flows. This repository uses the official Apache NiFi Docker image, while CogStack-NiFi creates a custom Docker image to include some specific configuration (see [`nifi/conf/nifi.properties`](nifi/conf/nifi.properties)). This repository attempts to provide a minimal working deployment, so for simplicity the official Apache NiFi image is used.

### Test flow with data from database
A test flow is provided that reads data from a database, to mimic how data could be read from a production database. To run the test NiFi flow with Dutch sample documents:
1. Start the NiFi container.
1. Navigate to NiFi in a browser (default: http://localhost:8080/nifi/).
1. From the top menu bar, select Template and select `NL Test flow`.
1. Configure the database en OpenSearch password in the controller services.
1. Enable the controller services.
1. Start the flow. To check the steps one by one, it is often useful to use the "Run Once"-functionality from the context menu of a NiFi processor.

### Data from CSV
During implementation of CogStack, it could be useful to read data from a CSV instead of a database. This repository currently does not contain a template for reading from CSV. Such as template can be made using the ListFile, GetFile and SplitRecords (with CSVReader and JSONRecordSetWriter) processors. 

The current Docker Compose file does contain a way to get a CSV file into NiFi. This is done by mounting a local directory to `/staging_data/`. By default, `./services/dutch-samples/` is mounted, which contains test data file `dutch-samples.csv`. The mounted folder can be changed with `NIFI_STAGING_DIR` in `.env`.

### Site specific configuration
For site-specific configuration, such as configuring TLS, environment variables can be provided which are used in the NiFi startup script ([start.sh](https://github.com/apache/nifi/blob/main/nifi-docker/dockerhub/sh/start.sh)).

An example with default values for running NiFi without HTTPS is provided in [`security/nifi.env-example`](security/nifi.env-example). For making site-specific changes, it's best to create a `nifi.env` file:
```bash
cd security
cp nifi.env-example nifi.env
```
Also make sure to change `NIFI_ENV_FILE=../security/nifi.env-example` to `NIFI_ENV_FILE=../security/nifi.env` in `deploy/.env`.

Additional documentation:
- https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html
- https://nifi.apache.org/docs/nifi-docs/html/getting-started.html
- https://hub.docker.com/r/apache/nifi

## De-identification
This repository uses [DEDUCE service](https://github.com/umcu/deduce-service) for de-identification of Dutch medical texts.

To test the functionality, visit URL where you have it running (default http://localhost:5001) or send an API request from the command line:
```bash
curl -X 'POST' 'localhost:5001/deidentify' -H 'accept: application/json' -H 'Content-Type: application/json' -d '{"text": "Jan Jansen is ziek.", "id": "001"}'
```

## MedCAT
This repository uses [MedCAT service](https://github.com/CogStack/MedCATservice) for named entity recognition, linking and context detection of documents with MedCAT.

Using MedCAT for Dutch language requires Dutch models, which can be configured in two ways:
1. By providing the `vocab.dat` and `cdb.dat` models. The default configuration of this repository is using this approach. For testing and demonstration purposes, sample models based on mock data are provided, see [`services/nlp-services/applications/medcat/models/umls-dutch-sample`](services/nlp-services/applications/medcat/models/umls-dutch-sample). Note that this requires a Dutch spaCy model, which is installed in the used fork of MedCAT service (see MedCAT section in `deploy/docker-compose.yml`)
2. By providing a MedCAT model pack, which includes MedCAT's `vocab.dat` and `cdb.dat` model files, spaCy models and MedCAT biLSTM models for context detection such as negation. spaCy models are relatively large (>17MB), so this approach is not used as default configuration of this repository.

### Configuring a model pack
1. Download a model pack from https://github.com/CogStack/MedCAT.
1. Place it in a directory which can be mounted to Docker and rename it to `model_pack.zip`.
1. In `services/nlp-services/applications/medcat/config/env_app` uncomment the `APP_MEDCAT_MODEL_PACK` property.
1. In `deploy/.env` point `LOCAL_MEDCAT_MODEL_DIR` to the directory containing the model pack.
1. (Re)start the MedCAT container.

### Testing MedCAT
Testing the MedCAT web service can be done from the terminal using
```bash
curl -X 'POST' 'localhost:5000/api/process' -H 'Content-Type: application/json' -d '{"content":{"text":"Gebruikelijke behandelingen voor kanker zijn onder meer chirurgie, chemotherapie en radiotherapie."}}'
```
This should return a JSON containing linked entities.

### Additional MedCAT service configuration
Additional configuration and usage examples can be found at https://github.com/CogStack/MedCATservice.

## OpenSearch and OpenSearch Dashboards
To test whether the OpenSearch instance is up, run the following command, which contains the default username and password:
```bash
curl -u admin:admin "http://localhost:9200/_cat/shards?v"
```

This should return something like:
```bash
index                shard prirep state   docs  store ip         node
.opendistro_security 0     p      STARTED    9 59.9kb 172.25.0.2 80dff132d75e
.kibana_1            0     p      STARTED    1    5kb 172.25.0.2 80dff132d75e
```

When OpenSearch Dashboards is up and data is loaded, create an index pattern and view the data in the Discover-view.

For site-specific configuration, take a look at the congfiguration file which can be mounted as Docker volume:
- [services/elasticsearch/config/elasticsearch_opensearch.yml](services/elasticsearch/config/elasticsearch_opensearch.yml)

Additional documentation:
- https://hub.docker.com/r/opensearchproject/opensearch
- https://opensearch.org/docs/latest/opensearch/install/docker/

## Fork maintenance
To keep this fork up to date with minimal effort, while being flexible to adjust changes for a local instance, we try to:
- Rebase this repository often on the upstream repository [CogStack-NiFi](https://github.com/CogStack/CogStack-NiFi)
- Changes that are not specific for the Dutch deployment should go into CogStack-NiFi repository. 
- Changes that are specific for the Dutch deployment should go into this repository.
- Changes that are specific for the local institute should go into a local fork. Ideally the CogStack-Nifi repository and CogStack-NL repository are configurable enough so that the local fork contains as few changes as possible.

# Original README

# Introduction
This repository proposes a possible next step for the free-text data processing capabilities implemented as [CogStack-Pipeline](https://github.com/CogStack/CogStack-Pipeline), shaping the solution more towards Platform-as-a-Service.

CogStack-NiFi contains example recipes using [Apache NiFi](https://nifi.apache.org/) as the key data workflow engine with a set of services for documents processing with NLP. 
Each component implementing key functionality, such as Text Extraction or Natural Language Processing, runs as a service where the data routing between the components and data source/sink is handled by Apache NiFi.
Moreover, NLP services are expected to implement an uniform RESTful API to enable easy plugging-in into existing document processing pipelines, making it possible to use any NLP application in the stack.

## Important

Please note that the project is under constant improvement, brining new features or services that might impact current deployments, please be aware as this might affect you, the user, when making upgrades, so be sure to check the release notes and the documentation beforehand. 

# Asking questions
Feel free to ask questions on the github issue tracker or on our [discourse website](https://discourse.cogstack.org) which is frequently used by our development team!
<br>

# Project organisation
The project is organised in the following directories:
- [`nifi`](./nifi) - custom Docker image of Apache NiFi with configuration files, drivers, example workflows and custom user resources.
- [`security`](./security) - scripts to generate SSL keys and certificates for Apache NiFi and related services (when needed) with other security-related requirements.
- [`services`](./services) - available services with their corresponding configuration files and resources.
- [`deploy`](./deploy) - an example deployment of Apache NiFi with related services.
- [`scripts`](./scripts) - helper scripts containing setup tools, sample ES ingestion, bash ingestion into DB samples etc.
- [`data`](./data) - any data that you wish to ingest should be placed here.

# Documentation and getting started
Official documentation now available [here](https://cogstack-nifi.readthedocs.io/en/latest/).

As a good starting point, [deployment](https://cogstack-nifi.readthedocs.io/en/latest/deploy/main.html) walks through an example deployment with some workflow examples.

All issues are tracked in [README](https://cogstack-nifi.readthedocs.io/en/latest/deploy/main.html), check that section before opening a bug report ticket.

# Important news and updates

Please check [IMPORTANT_NEWS](https://cogstack-nifi.readthedocs.io/en/latest/news.html) for any major changes that might affect your deployment and <strong>security problems</strong> that have been discovered.
