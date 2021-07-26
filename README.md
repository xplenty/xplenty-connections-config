# xplenty-connections-config
Xplenty Connection Configurations

## Contribute

We’re eager to have your help in improving this app. If you have an idea for a change, start by opening a new [Issue](https://github.com/xplenty/xplenty-connections-config/issues) so we can discuss and help guide your contribution to the right location. If you have corrections, we'd be glad to receive them via a [Pull Request](https://help.github.com/articles/using-pull-requests). 

### Clone the repository

```sh
$ git clone git@github.com:xplenty/xplenty-connections-config.git
$ cd xplenty-connections-config
```
### Artifactory configuration

When deploying the configuration `.json` file to artifactory it should be deployed using an incremented version and the following IDs:

```xml
  <groupId>com.xplenty</groupId>
  <artifactId>xplenty-connections-config</artifactId>
```

### Deploying to artifacotry

Deploying to artifactory for use of the xplenty system can be done either using the jfrog.io web UI or using included `xplenty-connections-config-deploy.sh` file. this file will craete a require POM file and will delete it when done deploying.
This first requires setting jfrog credentials:

```sh
$ export ARTIFACTORY_USERNAME=<some user name>
$ export ARTIFACTORY_PASSWORD=<some password>
```

Then increment the version in `version` file.
then deploy using a command terminal.

if deploying a staging version of xplenty-connections-config:

```sh
$ ./xplenty-connections-config-deploy.sh "sharelib-stg"
```

if deploying a production version of xplenty-connections-config:

```sh
$ ./xplenty-connections-config-deploy.sh "sharelib"
```


### Configuring a new authentication

To add a new authentication scheme to xplenty add a new key to `xplenty-connections-config.json` with the name used for the connection type in xplenty-core. To this new key add 2 more keys, an `auth_strategy` key and object with the key `type` with a value of the fully qualified name of the java class which implements this scheme and a `config` key which will describe the dictionary which will be passed to the `initialize(Map<String, Object> config)` method of the java class that is described in the `type` key.

the resulting object should look like this:

```
  "some_xplenty_connection_name": {
    "auth_strategy": {
      "type": "com.xplenty.connections.strategies.auth.SomeAuthStrategy",
      "config": {
        "some_configuration_used_by_someauthstrategy": {
          "some_key" : "some_value"
        }
      }
    }
```

It is worth mentioning that a class `com.xplenty.connections.strategies.auth.CustomAuthStrategy` exists which uses simple configurable string replacement to generate authentication objects in request. It takes 2 optional configuration object: `query_params` and `headers`. both are used as key-value pairs and string replacenment is executed on both keys and values. so that the following connection:


```
  "some_xplenty_connection_name": {
    "auth_strategy": {
      "type": "com.xplenty.connections.strategies.auth.CustomAuthStrategy",
      "config": {
        "query_params": {
          "authentication_query_param" : "${access_key}"
        }
      }
    }
```

Would describe an authentication which adds a query param to the URL of each request where the parameter name is `authentication_query_param` and the value would be the `access_key` value described in the specific connection used.