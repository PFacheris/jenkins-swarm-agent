#!/bin/bash
set -o errexit

swarm_parameters=""

function check_variable(){
    local key=$1
    local val=${!key}
    if [ -n "$val" ]; then
        # Lowercase key, then replace all instances of '_x' with 'X'
        local arg=$(echo "${key,,}" | sed -z 's/\_\([a-z]\)/\U\1/g')
        if [ "$val" = "true" ]; then
            swarm_parameters="${swarm_parameters} -${arg}"
        elif [ "$val" = "false" ]; then
            :
        else
            swarm_parameters="${swarm_parameters} -${arg} '${val}'"
        fi
    fi
}

check_variable 'SWARM_AUTO_DISCOVERY_ADDRESS'
check_variable 'SWARM_CANDIDATE_TAG'
check_variable 'SWARM_DELETE_EXISTING_CLIENTS'
check_variable 'SWARM_DESCRIPTION'
check_variable 'SWARM_DISABLE_CLIENTS_UNIQUE_ID'
check_variable 'SWARM_DISABLE_SSL_VERIFICATION'
check_variable 'SWARM_EXECUTORS'
check_variable 'SWARM_FSROOT'
check_variable 'SWARM_LABELS'
check_variable 'SWARM_LABELS_FILE'
check_variable 'SWARM_LOG_FILE'
check_variable 'SWARM_MASTER'
check_variable 'SWARM_MAX_RETRY_INTERVAL'
check_variable 'SWARM_MODE'
check_variable 'SWARM_NAME'
check_variable 'SWARM_NO_RETRY_AFTER_CONNECTED'
check_variable 'SWARM_PASSWORD'
check_variable 'SWARM_RETRY'
check_variable 'SWARM_RETRY_BACK_OFF_STRATEGY'
check_variable 'SWARM_RETRY_INTERVAL'
check_variable 'SWARM_SHOW_HOST_NAME'
check_variable 'SWARM_SSL_FINGERPRINTS'
check_variable 'SWARM_TUNNEL'
check_variable 'SWARM_USERNAME'

# Special case variables
if [ -n "$SWARM_TOOL_LOCATIONS" ]; then
    tool_parameters=""
    IFS=',' read -ra tools <<< "$SWARM_TOOL_LOCATIONS"
    for t in "${tools[@]}"; do
        tool_parameters="${tool_parameters} -t ${t}"
    done
    swarm_parameters="${swarm_parameters} ${tool_parameters}"
fi

java -jar /usr/share/jenkins/swarm-client.jar $swarm_parameters
