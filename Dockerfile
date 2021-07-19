FROM golang:alpine3.13

LABEL MAINTAINER "Elsvent Hong <elsvent@gmail.com>"
LABEL SOURCE "https://github.com/elsvent/workspace"

ARG HELMVERSION

ENV BASE_URL="https://get.helm.sh"

RUN apk update 
RUN    apk add --no-cache \
        alpine-sdk 
        
RUN    apk add --no-cache \
        ca-certificates \
        man-db \
        curl 

RUN        apk update && \
    apk add --no-cache \
        docker \
        openrc \
        vim \
        tmux \
        dialog \
        #python \
        python3 \
        py3-pip \
        git \
        #gh \
        jq \
        sudo \
        lynx \
        shellcheck \
        figlet \
        sl \
        tree \
        nmap \
        ed \
        bc \
        #iputils-ping \
        bind-tools \
        htop \
        #libncurses5 \
        #libcurses-perl \
        net-tools \
        openssh \
        sshpass \
        sshfs \
        rsync \
        #cifs-utils \
        #samba-client \
        bash-completion \
        #make \
        wget \
        less \
        hyperfine

# Install helm
RUN case `uname -m` in \
        x86_64) ARCH=amd64; ;; \
        armv7l) ARCH=arm; ;; \
        aarch64) ARCH=arm64; ;; \
        ppc64le) ARCH=ppc64le; ;; \
        s390x) ARCH=s390x; ;; \
        *) echo "un-supported arch, exit ..."; exit 1; ;; \
    esac && \
    wget ${BASE_URL}/helm-v${HELMVERSION}-linux-${ARCH}.tar.gz -O - | tar -xz && \
    mv linux-${ARCH}/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-${ARCH}

RUN chmod +x /usr/bin/helm

# Install lolcat in testing repository
RUN apk add lolcat --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/

# Not sure this cpan section
#    cpan -I Term::Animation && \

COPY ./files/. ./Dockerfile /

WORKDIR /usr/share/rwxrob/workspace 

RUN rc-update add docker boot
RUN /usr/share/workspace/.local/bin/install-kubectl

ENTRYPOINT ["sh","/entry"]
