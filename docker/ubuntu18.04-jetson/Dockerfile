
FROM nvcr.io/nvidia/l4t-base:r32.4.2
LABEL maintainer="kris@kriskinc.com"

ENV CPPFLAGS="-I/usr/include"
ENV CXXFLAGS="-I/usr/include"
ENV CC="gcc-6"
ENV CXX="g++-6"

RUN  apt-get update && apt-get install -y --no-install-recommends \
        gcc-6 g++-6 \
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
        libgfortran-6-dev \
        ca-certificates \
        patch \
        ffmpeg \
	vim && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/kaldi-asr/kaldi.git /opt/kaldi && \
    cd /opt/kaldi && \
    cd /opt/kaldi/tools && \
    # Build or install libopenblas-dev
    ./extras/install_openblas.sh && \
    make -j $(nproc) && \
    cd /opt/kaldi/src && \
    ./configure --shared --use-cuda && \
    make depend -j $(nproc) && \
    make -j $(nproc)

WORKDIR /opt/kaldi/

