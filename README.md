# CogStack-NL
This repository is a fork of [CogStack-NiFi](https://github.com/CogStack/CogStack-NiFi) and includes a minimum Docker Compose deployment to deploy the essential components to process Dutch electronic health records.

Some of the additions in this fork compared to the original repository:
- Dutch test data.
- Deidentification using DEDUCE.
- MedCATService image with configuration for Dutch spaCy model .
- MedCAT models and configuration suitable for Dutch language.
- Apache NiFi template of a dataflow that:
   - Extracts data from a MySQL database
   - Applies deidentification method DEDUCE
   - Applies entity recognition and linking using MedCAT
   - Saves the output in OpenSearch

The original README.md of CogStack-NiFi can be found as [ORIGINAL_README.md](ORIGINAL_README.md). Official CogStack-Nifi documentation, which includes a security section useful for production deployment, can be found at https://cogstack-nifi.readthedocs.io.

## Table of Contents
- [Installation](#installation)
- [Apache NiFi](#apache-nifi)
- [Deidentification](#deidentification)
- [MedCAT](#medcat)
- [OpenSearch and OpenSearch Dashboards](#opensearch-and-opensearch-dashboards)
- [Development](#development)

## Installation
1. Clone this repository.
2. Navigate to `deploy/`.
3. Create an `.env` file:
```bash
cp .env-example .env
```
4. Start the docker containers
```bash
docker-compose up
```

## Apache NiFi
Apache NiFi is used in this project to control data flows. This repository uses the official Apache NiFi Docker image, while the CogStack-NiFi repository creates a custom Docker image to include some specific configuration (see [`nifi/conf/nifi.properties`](nifi/conf/nifi.properties)). This repository attempts to provide a minimal working deployment, so for simplicity we use the official Apache NiFi image.

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

## Deidentification
This repository uses [DEDUCE](https://github.com/umcu/deduce-service) for deidentification of Dutch medical texts texts.

To test the functionality, visit URL where you have it running (default http://localhost:5001) or send an API request from the command line:
```bash
curl -X 'POST' 'localhost:5001/deidentify' -H 'accept: application/json' -H 'Content-Type: application/json' -d '{"text": "Jan Jansen is ziek.", "id": "001"}'
```

## MedCAT
Using MedCAT for Dutch languages requires Dutch models, which can be configured in two ways:
1. Providing individual models, such as `vocab.dat` and `cdb.dat`. In this case, the language specific spaCy model should be installed as well. These can be provided to Docker Compose when building the docker-image. For testing and demonstration, models based on sample data are provided in this repository, see [`services/nlp-services/applications/medcat/models/umls-dutch-sample`](services/nlp-services/applications/medcat/models/umls-dutch-sample).
2. Providing a MedCAT model pack. All models, including spaCy models, are included in this model pack. spaCy models are relatively large (>17MB), so this approach was not used for testing and demonstration purposes of this repo.

Testing MedCAT can be done using:
```bash
curl -X 'POST' 'localhost:5000/api/process' -H 'Content-Type: application/json' -d '{"content":{"text":"Gebruikelijke behandelingen voor kanker zijn onder meer chirurgie, chemotherapie en radiotherapie."}}'
```
This should return a JSON containing linked entities.

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

For site-specific configuration, take a look at the congfiguration file which can be mounted as Docker volume:
- [services/elasticsearch/config/elasticsearch_opensearch.yml](services/elasticsearch/config/elasticsearch_opensearch.yml)

Additional documentation:
- https://hub.docker.com/r/opensearchproject/opensearch
- https://opensearch.org/docs/latest/opensearch/install/docker/

## Development
Ideally changes from [CogStack-NiFi](https://github.com/CogStack/CogStack-NiFi) are regulary merged into this fork. Therefore changes that are not specific for the Dutch deployment should go into the original repository, and will then be end up in this repository as well.
