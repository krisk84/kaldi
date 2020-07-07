# syntax=docker/dockerfile:experimental

FROM nvcr.io/nvidia/l4t-base:r32.4.2

ENV CPPFLAGS="-I/usr/include"
ENV CXXFLAGS="-I/usr/include"

# ccache
ENV CCACHE_DIR=/ccache
ENV CC="/usr/local/bin/gcc-6"
ENV CXX="/usr/local/bin/g++-6"

# Parallel make by default
ENV MAKEOPTS="-j8"

WORKDIR /opt

COPY jetson-ota-public.asc /etc/apt/trusted.gpg.d/jetson-ota-public.asc

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

RUN echo 'deb https://repo.download.nvidia.com/jetson/common r32.4 main' > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
RUN echo 'deb https://repo.download.nvidia.com/jetson/t194 r32.4 main' >> /etc/apt/sources.list.d/nvidia-l4t-apt-source.list

RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt apt-get update

# Jetson CUDA Support
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt apt-get install -y --no-install-recommends \
        libcublas-dev \
        cuda-nvcc-10-2 \
        cuda-cusparse-dev-10-2 \
        cuda-cudart-dev-10-2 \
        cuda-curand-dev-10-2 \
        cuda-cufft-dev-10-2 \
        cuda-tools-10-2 \
        cuda-cusolver-dev-10-2 \
        cuda-libraries-dev-10-2 \
        libcudnn8-dev \
        tensorrt \
        libnvinfer-dev \
        libnvonnxparsers-dev \
        libnvparsers-dev \
        python3-libnvinfer-dev

RUN ln -s /usr/local/cuda-10.2 /usr/local/cuda

RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt apt-get update && apt-get install -y --no-install-recommends \
        gcc-6 g++-6 libgfortran-6-dev ccache \
        make \
        automake \
        autoconf \
        bzip2 \
        unzip \
        wget \
        sox \
        libtool \
        git \
        subversion \
        python2.7 \
        python3 \
        zlib1g-dev \
        gfortran \
        ca-certificates \
        patch \
        ffmpeg \
	vim && \
    rm -rf /var/lib/apt/lists/*

# use ccache (make it appear in path earlier then /usr/bin/gcc etc)
RUN for p in gcc-6 g++-6 cc c++; do ln -vs /usr/bin/ccache /usr/local/bin/$p;  done

RUN git clone --depth 1 https://github.com/kaldi-asr/kaldi.git /opt/kaldi

RUN --mount=type=cache,target=/ccache/ cd /opt/kaldi/tools && ./extras/install_openblas.sh

RUN --mount=type=cache,target=/ccache/ cd /opt/kaldi/tools && make

RUN --mount=type=cache,target=/ccache/ cd /opt/kaldi/src && ./configure --shared --use-cuda

RUN --mount=type=cache,target=/ccache/ cd /opt/kaldi/src && make depend

RUN --mount=type=cache,target=/ccache/ cd /opt/kaldi/src && make

RUN --mount=type=cache,target=/ccache/ ccache -s

WORKDIR /opt/kaldi/

