# What is this image?
An implementation of Jenkins [Swarm](https://wiki.jenkins.io/display/JENKINS/Swarm+Plugin) agents on various operating system/Java version combinations, it works great as a base image for customizing a Jenkins worker for a Kubernetes deployment.

# Usage Guide

### Environment
A wrapper script enables environment variable based control of the swarm client jar cli options, see [here](https://wiki.jenkins.io/display/JENKINS/Swarm+Plugin). Generally names should logically map to options except in the case of `SWARM_TOOL_LOCATIONS`  which should be a comma-separated list mapping to multiple `--toolLocation` arguments:

| Environment Variable            | Default |
| ------------------------------- | ------- |
| SWARM_AUTO_DISCOVERY_ADDRESS    |         |
| SWARM_CANDIDATE_TAG             |         |
| SWARM_DELETE_EXISTING_CLIENTS   | false   |
| SWARM_DESCRIPTION               | Basic Jenkins Swarm Agent |
| SWARM_DISABLE_CLIENTS_UNIQUE_ID | false   |
| SWARM_DISABLE_SSL_VERIFICATION  | false   |
| SWARM_EXECUTORS                 | 2       |
| SWARM_FSROOT                    | /usr/share/jenkins |
| SWARM_LABELS                    | default-worker |
| SWARM_LABELS_FILE               |         |
| SWARM_LOG_FILE                  |         |
| SWARM_MASTER                    | http://jenkins:8080 |
| SWARM_MAX_RETRY_INTERVAL        |         |
| SWARM_MODE                      |         |
| SWARM_NAME                      | default-worker |
| SWARM_NO_RETRY_AFTER_CONNECTED  | false   |
| SWARM_PASSWORD                  |         |
| SWARM_RETRY                     | 60      |
| SWARM_RETRY_BACK_OFF_STRATEGY   |         |
| SWARM_RETRY_INTERVAL            |         |
| SWARM_SHOW_HOST_NAME            |         |
| SWARM_SSL_FINGERPRINTS          |         |
| SWARM_TUNNEL                    |         |
| SWARM_USERNAME                  |         |
| SWARM_TOOL_LOCATIONS            |         |

*Note that a value of `true` includes the flag without options.

### Example
```
 $ docker run -e SWARM_MASTER=http://jenkins.test.net -e SWARM_DISABLE_SSL_VERIFICATION=true -e SWARM_USERNAME=jdoe -e SWARM_PASSWORD=mypass swarm-client
Feb 16, 2018 10:57:04 PM hudson.plugins.swarm.Client main
INFO: Client.main invoked with: [-description Basic Jenkins Swarm Agent -disableSslVerification -executors 2 -fsroot /usr/share/jenkins -labels default-worker -master http://08.jenkins.dev.lax1.adnexus.net -name default-worker -password mypass -retry 60 -username jdoe]
Feb 16, 2018 10:57:04 PM hudson.plugins.swarm.Client run
INFO: Discovering Jenkins master
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
Feb 16, 2018 10:57:04 PM hudson.plugins.swarm.Client run
INFO: Attempting to connect to http://jenkins.test.net/ bf8c69be-2660-486e-ac1f-7caa257c5ef5 with ID 07b46f1b
Feb 16, 2018 10:57:05 PM hudson.plugins.swarm.SwarmClient getCsrfCrumb
SEVERE: Could not obtain CSRF crumb. Response code: 404
Feb 16, 2018 10:57:05 PM hudson.remoting.jnlp.Main createEngine
INFO: Setting up agent: default-worker-07b46f1b
Feb 16, 2018 10:57:05 PM hudson.remoting.jnlp.Main$CuiListener <init>
INFO: Jenkins agent is running in headless mode.
Feb 16, 2018 10:57:05 PM hudson.remoting.Engine startEngine
WARNING: No Working Directory. Using the legacy JAR Cache location: /home/jenkins/.jenkins/cache/jars
Feb 16, 2018 10:57:05 PM hudson.remoting.jnlp.Main$CuiListener status
INFO: Locating server among [http://jenkins.test.net/]
Feb 16, 2018 10:57:05 PM org.jenkinsci.remoting.engine.JnlpAgentEndpointResolver resolve
INFO: Remoting server accepts the following protocols: [JNLP4-connect, Ping]
Feb 16, 2018 10:57:05 PM hudson.remoting.jnlp.Main$CuiListener status
INFO: Agent discovery successful
  Agent address: jenkins.test.net
  Agent port:    44569
  Identity:      7a:df:d8:8f:5c:4c:c3:b7:5a:fd:dd:14:05:23:da:06
Feb 16, 2018 10:57:05 PM hudson.remoting.jnlp.Main$CuiListener status
INFO: Handshaking
Feb 16, 2018 10:57:05 PM hudson.remoting.jnlp.Main$CuiListener status
INFO: Connecting to jenkins.test.net:44569
Feb 16, 2018 10:57:05 PM hudson.remoting.jnlp.Main$CuiListener status
INFO: Trying protocol: JNLP4-connect
Feb 16, 2018 10:57:06 PM hudson.remoting.jnlp.Main$CuiListener status
INFO: Remote identity confirmed: 7a:df:d8:8f:5c:4c:c3:b7:5a:fd:dd:14:05:23:da:06
Feb 16, 2018 10:57:08 PM hudson.remoting.jnlp.Main$CuiListener status
INFO: Connected
```


# How does this repo work?
Running `./update.sh` in the root of this repo will automatically create Dockerfile's for the various distributions.

# Contributing
Pull requests are welcome. If you'd like to request additional operating system base images, please open an issue.
