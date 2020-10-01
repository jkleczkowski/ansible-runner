FROM debian:bullseye
#LABEL maintainer "Jacek Kleczkowski <jacek@ksoft.biz>"

#RUN apt-get remove --purge -y $BUILD_PACKAGES $(apt-mark showauto) && rm -rf /var/lib/apt/lists/*
VOLUME /ansible

ENV DOCKER_HOST "unix:///var/run/docker.sock"
ENV DOCKER_BIN "/usr/bin/docker"
ENV DOCKER_IN_DOCKER start
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

EXPOSE 9090
# RUN  cat /opt/buildagent/bin/agent.sh
ENTRYPOINT [ "/bin/bash","/run-services.sh" ]

WORKDIR /

RUN apt-get update 

RUN apt-get install -y \
    wget curl mc \
    unzip \
    git \
    mercurial \
    openjdk-11-jdk \
    apt-transport-https \
    apt-utils \
    lxc \
    iptables \
    ca-certificates \
    ssh \
    docker.io \
    --no-install-recommends

#RUN    apt-get update 


# install ansible & maven
#RUN add-apt-repository ppa:ansible/ansible-2.9 && \
#RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libkrb5-dev \
    python3-pip \
    krb5-user 

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install ansible pywinrm  pywinrm[kerberos]  kerberos requests requests-kerberos openshift && \
    python3 -m pip install --upgrade setuptools 

RUN ansible-galaxy collection install \
    community.kubernetes \
    community.crypto \
    community.general \
    community.libvirt

#RUN ansible-galaxy collection install community.kubernetes && \
#    ansible-galaxy collection install community.crypto && \
#    ansible-galaxy collection install community.general && \
#    ansible-galaxy collection install community.libvirt

RUN apt-get clean

COPY root/ /
RUN chmod 0755 /run-*.sh /services/*

#ARG CORE_VERSIONS="dotnet-sdk-2.1 dotnet-sdk-2.2 dotnet-sdk-3.0 dotnet-sdk-3.1"
# Install PowerShell global tool
#ENV POWERSHELL_VERSION=7.0.0-rc.1 \
#    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetCoreSDK-Debian-10

#RUN curl -SL --output PowerShell.Linux.x64.$POWERSHELL_VERSION.nupkg https://pwshtool.blob.core.windows.net/tool/$POWERSHELL_VERSION/PowerShell.Linux.x64.$POWERSHELL_VERSION.nupkg \
    # && powershell_sha512='0fb0167e13560371bffec38a4a87bf39377fa1a5cc39b3a078ddec8803212bede73e5821861036ba5c345bd55c74703134c9b55c49385f87dae9e2de9239f5d9' \
    # && echo "$powershell_sha512  PowerShell.Linux.x64.$POWERSHELL_VERSION.nupkg" | sha512sum -c - \
#    && mkdir -p /usr/share/powershell \
#    && dotnet tool install --add-source / --tool-path /usr/share/powershell --version $POWERSHELL_VERSION PowerShell.Linux.x64 \
#    && rm PowerShell.Linux.x64.$POWERSHELL_VERSION.nupkg \
#    && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
#    && chmod 755 /usr/share/powershell/pwsh \
    # To reduce image size, remove the copy nupkg that nuget keeps.
#    && find /usr/share/powershell -print | grep -i '.*[.]nupkg$' | xargs rm \
#    && rm -f -r /tmp/*

#dodanie kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl


RUN apt-get upgrade -y 


WORKDIR /ansible
