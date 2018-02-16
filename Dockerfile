ARG DIST=xenial
FROM ubuntu:${DIST}

ARG SWARM_CLIENT_VERSION=3.9
ARG JAVA_PACKAGE=openjdk8-jre

RUN useradd -m jenkins
RUN mkdir -p /usr/share/jenkins && \
	chmod 777 /usr/share/jenkins

RUN apt-get update && apt-get install -y --force-yes git curl ${JAVA_PACKAGE} 
RUN curl -k -o /usr/share/jenkins/swarm-client.jar \
    https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_CLIENT_VERSION}/swarm-client-${SWARM_CLIENT_VERSION}.jar

ADD swarm-entrypoint.sh /usr/share/jenkins/swarm-entrypoint.sh

ENV SWARM_DELETE_EXISTING_CLIENTS=false
ENV SWARM_DESCRIPTION='Basic Jenkins Swarm Agent'
ENV SWARM_DISABLE_CLIENTS_UNIQUE_ID=false
ENV SWARM_DISABLE_SSL_VERIFICATION=false
ENV SWARM_EXECUTORS=2
ENV SWARM_FSROOT=/usr/share/jenkins
ENV SWARM_LABELS='default-worker'
ENV SWARM_MASTER='http://jenkins:8080'
ENV SWARM_NAME='default-worker'
ENV SWARM_NO_RETRY_AFTER_CONNECTED=false
ENV SWARM_RETRY=60

USER jenkins

ENTRYPOINT ["/usr/share/jenkins/swarm-entrypoint.sh"]
