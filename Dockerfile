FROM mcr.microsoft.com/dotnet/sdk:6.0
WORKDIR /tmp
RUN apt-get -y -qq update
RUN apt-get -y -qq install python3-pip software-properties-common apt-transport-https make ninja-build libopenblas-dev xz-utils clang lldb lld
RUN pip install meson semver
ENV DMD_tools=2.102.2 LDC=1.32.0 CC=clang CXX=clang++
RUN curl -fsS https://dlang.org/install.sh | bash -s install ldc -p /usr/local/dlang
ENV PATH=/usr/local/dlang/ldc-$LDC/bin:$PATH
COPY dtools_tests_extractor /usr/local/bin
RUN chmod +x /usr/local/bin/dtools_tests_extractor
COPY docgen /repo/docgen
COPY web /repo/web
COPY meson_options.txt.1 /repo/meson_options.txt.1
COPY meson.build.1 /repo/meson.build.1
WORKDIR /repo
