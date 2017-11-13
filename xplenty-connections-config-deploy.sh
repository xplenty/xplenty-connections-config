#!/bin/bash
#
# Installs Maxmind GEO database files
#
# Exit if anything fails

ENVIRONMENT=$1
VERSION=$(cat ./version)
echo "Using version: ${VERSION}"

echo
echo "Creating POM file"
cat << EOF > xplenty-connections-config-${VERSION}.pom
<?xml version="1.0" encoding="UTF-8"?><project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.xplenty</groupId>
  <artifactId>xplenty-connections-config</artifactId>
  <version>${VERSION}</version>
  <description>Configuration of supported connections in xplenty</description>
</project>
EOF

echo "Copying JSON configuration file"
cp xplenty-connections-config.json xplenty-connections-config-${VERSION}.json

# Upload to jfrog repository
echo "Deploying JSON configuration file"
curl --show-error --fail -u ${ARTIFACTORY_USERNAME}:${ARTIFACTORY_PASSWORD} -X PUT "https://xplenty.jfrog.io/xplenty/${ENVIRONMENT}/com/xplenty/xplenty-connections-config/${VERSION}/" -T xplenty-connections-config-${VERSION}.json
return_code=$?
if [ "${return_code}" -eq "0" ]; then
  echo "Deploying POM file"
  curl --show-error --fail -u ${ARTIFACTORY_USERNAME}:${ARTIFACTORY_PASSWORD} -X PUT "https://xplenty.jfrog.io/xplenty/${ENVIRONMENT}/com/xplenty/xplenty-connections-config/${VERSION}/" -T xplenty-connections-config-${VERSION}.pom
  return_code=$?
fi

echo "Removing temp files"
rm xplenty-connections-config-${VERSION}.json
rm xplenty-connections-config-${VERSION}.pom

echo "Exiting"
exit ${return_code}