FROM circleci/python:latest
WORKDIR /tmp
RUN sudo apt-get -y -qq install apt-transport-https make ninja-build libopenblas-dev libclang-dev clang
RUN sudo pip install meson
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && \
    sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
RUN curl -fsSLO https://packages.microsoft.com/config/debian/9/prod.list && \
    sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
    sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
RUN sudo apt-get -y -qq update
RUN sudo apt-get -y -qq install dotnet-sdk-2.2
ENV DMD 2.085.1
RUN curl -fsSLO --retry 3 "http://downloads.dlang.org/releases/2.x/$DMD/dmd.$DMD.linux.tar.xz" && \
    tar xf dmd.$DMD.linux.tar.xz &&\
    sudo cp -rf dmd2/linux/* /usr/local
RUN sudo rm -rf /tmp
