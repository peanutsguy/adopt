FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir /app
WORKDIR /app
RUN useradd -s /bin/bash -d /app devopsagent
RUN chown -R devopsagent:devopsagent /app

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends wget apt-transport-https software-properties-common jq python-is-python3 python3-venv gpg dpkg curl iputils-ping

RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

RUN wget -q "https://packages.microsoft.com/config/debian/$(lsb_release -rs)/packages-microsoft-prod.deb" && dpkg -i packages-microsoft-prod.deb && rm packages-microsoft-prod.deb

RUN apt-get update && apt-get install -y --no-install-recommends powershell terraform

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

USER devopsagent

RUN version="$(curl -fsSLI -o /dev/null -w "%{url_effective}" https://github.com/microsoft/azure-pipelines-agent/releases/latest | rev | cut -d'/' -f1 | rev | cut -d'v' -f2)" && package="vsts-agent-linux-x64-$version.tar.gz" && url="https://download.agent.dev.azure.com/agent/$version/$package" && wget -q $url -O vsts-agent-linux-x64.tgz && tar -xvf vsts-agent-linux-x64.tgz && rm vsts-agent-linux-x64.tgz

COPY --chown=devopsagent:devopsagent --chmod=+x entrypoint.sh ./entrypoint.sh

ENV AZDEVOPS_AGNT=devopsagent
ENV AZDEVOPS_WORKDIR=_work

ENTRYPOINT ["./entrypoint.sh"]
