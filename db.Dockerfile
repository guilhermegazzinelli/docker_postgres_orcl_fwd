
ARG postgres_version=13

FROM postgres:$postgres_version

ARG oracle_fdw_version=2_3_0

ARG instantclient_version=21_3

ADD ./src/instantclient_21_3.tar.xz /opt/oracle

ADD ./src/oracle_fdw_2_3_0.tar.xz /tmp/

ENV ORACLE_HOME=/opt/oracle/instantclient_21_3  PATH=/opt/oracle/instantclient_21_3:/opt/oracle/instantclient_21_3/sdk/include:$PATH

RUN apt-get update && apt-get install build-essential postgresql-server-dev-all libaio1 -y \
      && cd /tmp/oracle_fdw_2_3_0 \
      && make && make install \
      && apt-get purge build-essential postgresql-server-dev-all -y \
      && apt-get clean \
      && rm -rf /var/cache/apt/archives/* \
      && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
      && truncate -s 0 /var/log/*log 

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_21_3:$LD_LIBRARY_PATH
# RUN ldconfig


