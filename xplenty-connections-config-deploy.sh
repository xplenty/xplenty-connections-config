#!/bin/bash
#
# Installs Maxmind GEO database files
#
# Exit if anything fails
set -e

DATE=$(date "+%Y%m%d")
ENVIRONMENT=$1

cat << EOF > xplenty-connections-config-${DATE}.pom
<?xml version="1.0" encoding="UTF-8"?><project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.xplenty</groupId>
  <artifactId>xplenty-connections-config</artifactId>
  <version>${DATE}</version>
  <description>Configuration of supported connections in xplenty</description>
</project>
EOF

mv xplenty-connections-config.json xplenty-connections-config-${DATE}.json

# Upload GeoIPCountry to jfrog repository
curl -u ${ARTIFACTORY_USERNAME}:${ARTIFACTORY_PASSWORD} -X PUT "https://xplenty.jfrog.io/xplenty/${ENVIRONMENT}/com/xplenty/xplenty-connections-config/${DATE}/" -T xplenty-connections-config-${DATE}.json
curl -u ${ARTIFACTORY_USERNAME}:${ARTIFACTORY_PASSWORD} -X PUT "https://xplenty.jfrog.io/xplenty/${ENVIRONMENT}/com/xplenty/xplenty-connections-config/${DATE}/" -T xplenty-connections-config-${DATE}.pom
