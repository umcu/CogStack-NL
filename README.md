# CogStack-NL
This repository is a fork of [CogStack-NiFi](https://github.com/CogStack/CogStack-NiFi) and includes a minimum Docker Compose deployment to deploy the essential components to process Dutch electronic health records.

Some of the additions in this fork compared to the original repository:
- Dutch test data.
- Pseudonimization based on DEDUCE.
- MedCATService image that includes the Dutch spaCy model. 
- MedCAT configuration suitable for Dutch medical language.
- Apache NiFi template of a dataflow that extracts data from a MySQL database, runs it through pseudonomization and MedCAT, and saves the output in OpenSearch.

## Table of Contents
- [Installation](#installation)
- [Apache NiFi](#apache-nifi)
- [Dutch MedCAT](#dutch-medcat)
- [Deidentification](#deidentification)
- [OpenSearch and OpenSearch Dashboards](#opensearch-and-opensearch-dashboards)
- [Development](#development)

## Installation
1. Clone this repository.
2. Navigate to `deploy/`.
3. Create an `.env` file:
```bash
cp .env-example example
```
4. Start the docker containers
```bash
docker-compose up
```

## Apache NiFi
Apache NiFi is used in this project to control data flows. This repository uses the official Apache NiFi Docker image, while the CogStack-NiFi repository creates a custom Docker image to include some specific configuration and examples. This repository attempts to provide a minimal working deployment, so for simplicity we use the official Apache NiFi image.

For site-specific configuration, take a look at how configuration files are mounted as Docker volume:
- [security/nifi.env-example]()
- [nifi/conf/nifi.properties]()

Additional documentation:
- https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html
- https://hub.docker.com/r/apache/nifi

## Dutch MedCAT
Using Dutch MedCAT models requires specification of a Dutch MedCAT language pack.
[TODO]: Update MedCATService configuration, so that it can use language packs.
[TODO]: Add instructuctions how to install and use Dutch MedCAT.

## Deidentification
This repository used [DEDUCE](https://github.com/umcu/deduce-service) for deidentification of Dutch medical texts texts.

## OpenSearch and OpenSearch Dashboards
For site-specific configuration, take a look at how configuration files are mounted as Docker volume:
- [services/elasticsearch/config/elasticsearch_opensearch.yml]()

Additional documentation:
- https://hub.docker.com/r/opensearchproject/opensearch
- https://opensearch.org/docs/latest/opensearch/install/docker/

## Development
Ideally changes from [CogStack-NiFi](https://github.com/CogStack/CogStack-NiFi) are regulary merged into this fork. Therefore changes that are not specific for the Dutch deployment should go into the original repository, and will then be end up in this repository as well.
