FROM openjdk:8
LABEL maintainer="nrkkalyan"

ENV OPENMQ_VERSION=5.1.2
ENV OPENMQ_ARCHIVE=openmq5_1_2.zip

ADD /config/config.properties /opt/openmq/mq/var/instances/imqbroker/props/config.properties

ADD files /opt/files

RUN cd /opt/openmq/ && \
    wget "https://download.oracle.com/mq/open-mq/${OPENMQ_VERSION}/latest/${OPENMQ_ARCHIVE}" 2>/dev/null && \
    unzip ${OPENMQ_ARCHIVE} && \
    rm -f ${OPENMQ_ARCHIVE}

RUN /opt/openmq/mq/bin/imqbrokerd -init && /opt/openmq/mq/bin/imqusermgr add -u jsclient -p jsclient -g admin

# encode password
RUN /opt/openmq/mq/bin/imqusermgr encode -f -src /opt/files/tmp_pass.file -target /opt/files/pass.file && rm -f /opt/files/tmp_pass.file

# portmapper & broker
EXPOSE 7676
# stomp service
EXPOSE 7677

ADD ./startup.sh ./
RUN chmod +x ./startup.sh
ENTRYPOINT ["./startup.sh"]
