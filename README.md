![Create and publish Docker image](https://github.com/peanutsguy/adopt/actions/workflows/main.yml/badge.svg)

A simple, ``debian-slim`` based, Docker image intended to run as an Azure DevOps Self Hosted Agent for Terraform deployments.

## Included Packages

- Azure CLI
- Powershell
- Terraform
- Azure DevOps Agent

## Usage

Using ``docker``
```bash
docker run \
-e AZDEVOPS_URL=https://myaccount.visualstudio.com \
-e AZDEVOPS_PAT=myToken \
-e AZDEVOPS_POOL=Default \
-e AZDEVOPS_AGNT=AgentName \
-e AZDEVOPS_WORKDIR=_work \
-v $(pwd)/work.b:/app/_work \
--name devopsagent \
-h devopsagent \
ghcr.io/peanutsguy/adopt
```

Using ``docker compose``
```docker-compose
services:
  devopsagent:
    image: ghcr.io/peanutsguy/adopt
    environment:
      - AZDEVOPS_URL=https://myaccount.visualstudio.com
      - AZDEVOPS_PAT=myToken
      - AZDEVOPS_POOL=Default
      - AZDEVOPS_AGNT=AgentName
      - AZDEVOPS_WORKDIR=_work
    volumes:
      - $(pwd)/work:/app/_work
```

|Variable|Description|
|-|-|
|AZDEVOPS_URL|The url of your Azure DevOps Organization|
|AZDEVOPS_PAT|Your [Personal Access Token (PAT)](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/personal-access-token-agent-registration?view=azure-devops)|
|AZDEVOPS_POOL|The pool to which the agent will be added|
|AZDEVOPS_AGNT|Name the agent will use, which will be shown in Azure DevOps|
|AZDEVOPS_WORKDIR|Work directory where job data is stored. Defaults to `_work` under the root of the agent directory. The work directory is owned by a given agent and should not be shared between multiple agents.|

[More info](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/linux-agent?view=azure-devops&tabs=IP-V4#unattended-config)