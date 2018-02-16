#!/bin/bash
set -Eeuo pipefail

# Constants
declare -A ubuntu_versions
trusty=(6 7)
xenial=(7 8)
ubuntu_versions['trusty']=${trusty[@]}
ubuntu_versions['xenial']=${xenial[@]}

# Get latest swarm version
swarm_version=$(curl -k https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/maven-metadata.xml | sed  -n 's/.*<latest>\(.*\)<\/latest>/\1/p')
if [ -z "$swarm_version" ]; then
    echo 'No latest Swarm version could be detected.'
    exit 1
fi

# Ubuntu Dockerfiles
for ubuntu_version in ${!ubuntu_versions[@]}; do
    for java_version in ${ubuntu_versions[$ubuntu_version]}; do
        version=ubuntu/${ubuntu_version}/jre-${java_version}
        echo "Creating/Updating Dockerfile for $version..."
        mkdir -p $version
        cp ./swarm-entrypoint.sh $version/swarm-entrypoint.sh

        # TODO: Wait on support for build args in Dockerhub automated builds
        # and maintain one Dockerfile per OS
        cat > $version/Dockerfile << EOF
# This Dockerfile was autogenerated via update.sh in the root of this repository on $(date), do not modify it manually.
FROM ubuntu:${ubuntu_version}
ARG SWARM_CLIENT_VERSION=${swarm_version}
ARG JAVA_PACKAGE=openjdk-${java_version}-jre

EOF

        cat >> $version/Dockerfile << 'EOF'
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
EOF

    echo "Done."
    done
done

# Create tag for swarm version if it does not exist
set +e
git rev-parse -q --verify "refs/tags/${swarm_version}"
if [[ $? -ne 0 ]]; then
    echo 'New swarm version detected.'
    git diff-index --quiet HEAD --
    # Only tag on non-dirty state
    if [[ $? -eq 0 ]]; then
        git tag -a $swarm_version
    else
        echo 'Repository is in a dirty state, no tag will be created.'
    fi
else
    echo "Tag already exists for ${swarm_version}, manual intervention required."
fi