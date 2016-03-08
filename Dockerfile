FROM jenkins:latest

USER root

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Update repos
RUN apt-key update && apt-get update && apt-get -y --force-yes upgrade

# Install android AAPT dependencies
RUN apt-get -y --force-yes install make lib32stdc++6 lib32z1 g++

# Debian config
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
            build-essential \
            curl \
            git \
            groff \
            libgmp-dev \
            libmpc-dev \
            libmpfr-dev \
            m4 \
            ocaml \
            pkg-config \
            python-software-properties \
            rsync \
            software-properties-common \
            unzip \
            zlib1g-dev

# Install OPAM
RUN curl -sL \
      https://github.com/ocaml/opam/releases/download/1.2.2/opam-1.2.2-x86_64-Linux \
      -o /usr/local/bin/opam && \
    chmod 755 /usr/local/bin/opam

RUN opam init -y --comp=4.02.3 && \
    opam install -y extlib.1.5.4 atdgen.1.6.0 javalib.2.3.1 sawja.1.5.1

# Download the latest Infer release
RUN INFER_VERSION=$(curl -s https://api.github.com/repos/facebook/infer/releases \
      | grep -e '^[ ]\+"tag_name"' \
      | head -1 \
      | cut -d '"' -f 4); \
    cd /opt && \
    curl -sL \
      https://github.com/facebook/infer/releases/download/${INFER_VERSION}/infer-linux64-${INFER_VERSION}.tar.xz | \
    tar xJ && \
    rm -f /infer && \
    ln -s ${PWD}/infer-linux64-$INFER_VERSION /infer

# Compile Infer
RUN cd /infer && \
    eval $(opam config env) && \
    ./configure && \
    make -C infer clang java

# Install Infer
ADD infer /infer/infer/lib/python/
RUN chmod 777 /infer/infer/lib/python/infer
ENV INFER_HOME /infer/infer
ENV PATH ${INFER_HOME}/bin:${PATH}

# Add private key for git, if needed
# ADD id_rsa /root/.ssh/
# ADD id_rsa.pub /root/.ssh/
# RUN chmod 600 /root/.ssh/id_rsa

# Set android sdk
ENV ANDROID_HOME /android-sdk/android-sdk-linux
ENV PATH $ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH
