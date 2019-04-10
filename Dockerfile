FROM ringcentral/jdk:8u202-alpine3.8
LABEL maintainer="john.lin@ringcentral.com"

ENV OPENMQ_VERSION=5.1.2
ENV OPENMQ_ARCHIVE=openmq5_1_2.zip

ADD /config/config.properties /opt/openmq/mq/var/instances/imqbroker/props/config.properties

ADD files /opt/

RUN cd /opt/openmq/ && \
    wget "https://download.oracle.com/mq/open-mq/${OPENMQ_VERSION}/latest/${OPENMQ_ARCHIVE}" 2>/dev/null && \
    unzip ${OPENMQ_ARCHIVE} && \
    rm -f ${OPENMQ_ARCHIVE}

RUN /opt/openmq/mq/bin/imqbrokerd -init && /opt/openmq/mq/bin/imqusermgr add -u jsclient -p jsclient -g admin

RUN /opt/openmq/mq/bin/imqusermgr encode -f -src /opt/files/tmp_pass.file -target /opt/files/pass.file && rm -f /opt/files/tmp_pass.file

# portmapper & broker
EXPOSE 7676
# stomp service
EXPOSE 7677

CMD /opt/openmq/mq/bin/imqbrokerd -startRmiRegistry -rmiRegistryPort 1616 -port 7676 -vmargs "-server -Xms1g -Xmx5g -XX:MaxMetaspaceSize=1g -XX:-UseGCOverheadLimit -Djava.io.tmpdir=/tmp"