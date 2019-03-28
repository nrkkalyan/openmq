FROM ringcentral/jdk:8u202-alpine3.8
LABEL maintainer="john.lin@ringcentral.com"

ENV OPENMQ_VERSION=5.1
ENV OPENMQ_ARCHIVE=openmq5_1-binary-linux.zip

RUN cd /opt/openmq/ && \
    wget "http://download.java.net/mq/open-mq/${OPENMQ_VERSION}/latest/${OPENMQ_ARCHIVE}" 2>/dev/null && \
    unzip $OPENMQ_ARCHIVE

ADD /config/config.properties /opt/openmq/MessageQueue${OPENMQ_VERSION}/var/mq/instances/imqbroker/props/config.properties

# portmapper & broker
EXPOSE 7676
# jms service
EXPOSE 7677
# ssljms service
#EXPOSE 7678
# admin service
#EXPOSE 7679
# ssladmin service
#EXPOSE 7680

CMD ["/opt/openmq/MessageQueue${OPENMQ_VERSION}/mq/bin/imqbrokerd", "-vmargs","-autorestart"]