FROM debian:jessie

MAINTAINER Benjamin Rokseth <benjamin.rokseth@kul.oslo.kommune.no>

# Set Virtuoso commit SHA to Virtuoso 7.2.4 (20/03/2017)
ENV VIRTUOSO_COMMIT a5d0a8fa3ce49fe60cfbe5bd2021a02daae23a32

# Install Virtuoso prerequisites and crudini Python lib
# download virtuoso from gitref
RUN apt-get update &&\
    apt-get install -y curl build-essential debhelper autotools-dev autoconf automake unzip wget net-tools \
    libtool flex bison gperf gawk m4 libssl-dev libreadline-dev libreadline-dev openssl &&\
    curl -sSk -o virtuoso.tar.gz https://codeload.github.com/openlink/virtuoso-opensource/legacy.tar.gz/${VIRTUOSO_COMMIT} &&\
    mkdir -p /virtuoso && tar -C /virtuoso --strip-components=1 -xzf virtuoso.tar.gz &&\
    rm -rf virtuoso.tar.gz &&\
    cd /virtuoso &&\
    ./autogen.sh &&\
    CFLAGS="-O2 -m64" && export CFLAGS && ./configure --disable-bpel-vad --enable-conductor-vad \
      --disable-dbpedia-vad --disable-demo-vad --disable-isparql-vad --disable-ods-vad --disable-sparqldemo-vad \
      --disable-syncml-vad --disable-tutorial-vad --with-readline --program-transform-name="s/isql/isql-v/" &&\
    make && make install &&\
    ln -s /usr/local/virtuoso-opensource/var/lib/virtuoso/ /var/lib/virtuoso &&\
    ln -s /var/lib/virtuoso/db /data &&\
    rm -rf /virtuoso &&\
    apt-get purge -y build-essential libtool flex bison m4 &&\
    apt-get autoremove -y &&\
    apt-get clean

# Add Virtuoso bin to the PATH
ENV PATH /usr/local/virtuoso-opensource/bin/:$PATH

# Add Virtuoso config
COPY virtuoso.ini /virtuoso.ini

# Add dump_nquads_procedure
COPY dump_nquads_procedure.sql /dump_nquads_procedure.sql

# Add Virtuoso log cleaning script
COPY clean-logs.sh /clean-logs.sh

# Add startup script
COPY virtuoso.sh /virtuoso.sh

# Add crudini tool
RUN apt-get install -y crudini && apt-get clean

# Add crudini tool
RUN apt-get install -y crudini && apt-get clean

VOLUME /data
WORKDIR /data
EXPOSE 8890
EXPOSE 1111

CMD ["/bin/bash", "/virtuoso.sh"]
