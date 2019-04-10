FROM ringcentral/jdk:8u202-alpine3.8
LABEL maintainer="john.lin@ringcentral.com"

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

# creating DASHBOARD.QUEUE dst
RUN /opt/openmq/mq/bin/imqcmd -f create dst -t q -n DASHBOARD.QUEUE -o maxNumMsgs=500000 -o maxBytesPerMsg=50m -o maxTotalMsgBytes=10000m -o limitBehavior=REJECT_NEWEST -o maxNumProducers=300 -o useDMQ=true -u admin -passfile /opt/files/pass.file

# creating DASHBOARD_CACHE.QUEUE dst
RUN /opt/openmq/mq/bin/imqcmd -f create dst -t q -n DASHBOARD_CACHE.QUEUE -o maxNumMsgs=250000 -o maxBytesPerMsg=51m -o maxTotalMsgBytes=10000m -o limitBehavior=REJECT_NEWEST -o maxNumProducers=-1 -o useDMQ=true -u admin -passfile /opt/files/pass.file

# creating DASHBOARD.CACHE.DEAD.QUEUE
RUN /opt/openmq/mq/bin/imqcmd -f create dst -t q -n DASHBOARD.CACHE.DEAD.QUEUE -o maxNumMsgs=250000 -o maxBytesPerMsg=51m -o maxTotalMsgBytes=10000m -o limitBehavior=REJECT_NEWEST -o maxNumProducers=-1 -o useDMQ=true -u admin -passfile /opt/files/pass.file

# creating DASHBOARD.INTERNAL.FAILURE.QUEUE
RUN /opt/openmq/mq/bin/imqcmd -f create dst -t q -n DASHBOARD.INTERNAL.FAILURE.QUEUE -o maxNumMsgs=250000 -o maxBytesPerMsg=51m -o maxTotalMsgBytes=10000m -o limitBehavior=REJECT_NEWEST -o maxNumProducers=-1 -o useDMQ=true -u admin -passfile /opt/files/pass.file

# updating mq.sys.dmq
RUN /opt/openmq/mq/bin/imqcmd -f update dst -t q -n mq.sys.dmq -o maxNumMsgs=250000 -o maxBytesPerMsg=51m -o maxTotalMsgBytes=10000m -o limitBehavior=REMOVE_OLDEST -u admin -passfile /opt/files/pass.file

# portmapper & broker
EXPOSE 7676
# stomp service
EXPOSE 7677

CMD /opt/openmq/mq/bin/imqbrokerd -startRmiRegistry -rmiRegistryPort 1616 -port 7676 -vmargs "-server -Xms1g -Xmx5g -XX:MaxMetaspaceSize=1g -XX:-UseGCOverheadLimit -Djava.io.tmpdir=/tmp"