FROM circleci/python:latest
WORKDIR /tmp
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
RUN sudo apt-get -y -qq install software-properties-common apt-transport-https make ninja-build libopenblas-dev
RUN sudo pip install meson semver
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && \
    sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
RUN curl -fsSLO https://packages.microsoft.com/config/debian/9/prod.list && \
    sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
    sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
RUN sudo add-apt-repository "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-8 main" && sudo add-apt-repository universe
RUN sudo apt-get -y -qq update
RUN sudo apt-get -y -qq install dotnet-sdk-2.2 clang-8 lldb-8 lld-8
ENV DMD 2.091.0
RUN curl -fsSLO --retry 3 "http://downloads.dlang.org/releases/2.x/$DMD/dmd_$DMD-0_amd64.deb" && \
    sudo dpkg -i dmd_$DMD-0_amd64.deb &&\
    rm dmd_$DMD-0_amd64.deb
ENV CC="clang-8" CXX="clang++-8"
RUN dub fetch dtools && dub build dtools:tests_extractor --build=release
WORKDIR /
COPY docgen ./
COPY web ./
