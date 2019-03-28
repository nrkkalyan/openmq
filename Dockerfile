FROM ringcentral/jdk:8u202-alpine3.8
LABEL maintainer="john.lin@ringcentral.com"

ENV OPENMQ_VERSION 5.1
ENV OPENMQ_ARCHIVE openmq5_1-binary-linux.zip

ADD /config/config.properties /opt/openmq/var/mq/instances/imqbroker/props/config.properties

RUN useradd -d /home/openmq -u 1001 -s /bin/bash openmq && \
    chown -R openmq:openmq /opt/openmq

#    mkdir -p /opt/openmq && \

USER openmq
RUN cd /opt/openmq/ && \
    curl -v -o $OPENMQ_ARCHIVE http://download.java.net/mq/open-mq/$OPENMQ_VERSION/latest/$OPENMQ_ARCHIVE && \
    unzip $OPENMQ_ARCHIVE

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

CMD ["/opt/openmq/mq/bin/imqbrokerd", "-vmargs","-autorestart", "-Xss228m"]