FROM registry.redhat.io/rhel7:latest

# Install first batch of pre-reqs
RUN yum install -y sudo && \
    yum install -y git && \
    yum install -y gcc-c++.x86_64 && \
    yum install -y make && \
    yum install -y wget

# Build gflags from source
RUN git clone https://github.com/gflags/gflags.git && \
    cd gflags && \
    git checkout v2.0 && \
    ./configure && make && sudo make install

# Add gflags location to the some paths
ENV CPATH=/usr/local/include
ENV LIBRARY_PATH=/usr/local/lib

# Install second batch of pre-reqs
RUN yum install -y snappy snappy-devel && \
    yum install -y zlib zlib-devel && \
    yum install -y bzip2 bzip2-devel && \
    yum install -y lz4.x86_64

# Make zstandard from source
RUN wget https://github.com/facebook/zstd/archive/v1.1.3.tar.gz && \
   mv v1.1.3.tar.gz zstd-1.1.3.tar.gz && \
   tar zxvf zstd-1.1.3.tar.gz && \
   cd zstd-1.1.3 && \
   make && sudo make install

# Make rocksdb from source
RUN wget https://github.com/facebook/rocksdb/archive/v6.4.6.tar.gz && \
    mv v6.4.6.tar.gz rocksdb-6.4.6.tar.gz && \
    tar zxvf rocksdb-6.4.6.tar.gz && \
    cd rocksdb-6.4.6 && \
    DEBUG_LEVEL=0 make shared_lib install-shared && \
    export LD_LIBRARY_PATH=/usr/local/lib && \
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/rocksdb-6.4.6 && \
    export LIBRARY_PATH=${LIBRARY_PATH}:/rocksdb-6.4.6

