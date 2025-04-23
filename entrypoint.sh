#!/bin/bash

if [ ! -e ./initialized ]; then
    if [ "$AZDEVOPS_AGNT" == "devopsagent" ]; then
        AZDEVOPS_AGNT="$(hostname)"
    fi
    echo "Setting up Azure DevOps Agent..."
    ./config.sh  --unattended --url $AZDEVOPS_URL --auth pat --token $AZDEVOPS_PAT --pool $AZDEVOPS_POOL --agent $AZDEVOPS_AGNT --work $AZDEVOPS_WORKDIR --acceptTeeEula
    touch ./initialized
    ./run.sh
else
    ./run.sh
fi