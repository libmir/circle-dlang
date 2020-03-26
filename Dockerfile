FROM circleci/python:latest
WORKDIR /tmp
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
RUN sudo apt-get -y -qq install software-properties-common apt-transport-https make ninja-build libopenblas-dev xz-utils
RUN sudo pip install meson semver
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && \
    sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
RUN curl -fsSLO https://packages.microsoft.com/config/debian/9/prod.list && \
    sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
    sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
RUN sudo add-apt-repository "deb http://apt.llvm.org/buster/ llvm-toolchain-buster-10 main"
RUN sudo apt-get -y -qq update
RUN sudo apt-get -y -qq install dotnet-sdk-2.2 clang-10 lldb-10 lld-10
ENV DMD 2.091.0
RUN curl -fsSLO --retry 3 "http://downloads.dlang.org/releases/2.x/$DMD/dmd_$DMD-0_amd64.deb" && \
    sudo dpkg -i dmd_$DMD-0_amd64.deb &&\
    rm dmd_$DMD-0_amd64.deb
RUN curl -fsSLO --retry 3 "https://github.com/dlang/tools/archive/v$DMD.tar.gz" \
 && tar xf v$DMD.tar.gz \
 && cd tools-$DMD \
 && dub build --build=release :tests_extractor \
 && sudo cp dtools_tests_extractor /usr/local/bin \
 && cd .. \
 && rm -rf tolos-$DMD
ENV CC="clang-10" CXX="clang++-10"
WORKDIR /
COPY docgen ./
COPY web ./
