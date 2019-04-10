#!/bin/bash

nohup /opt/openmq/mq/bin/imqbrokerd -startRmiRegistry -rmiRegistryPort 1616 -port 7676 -vmargs "-server -Xms1g -Xmx5g -XX:MaxMetaspaceSize=1g -XX:-UseGCOverheadLimit -Djava.io.tmpdir=/tmp" > /dev/null 2>&1 &

sleep 10

# creating DASHBOARD.QUEUE dst
/opt/openmq/mq/bin/imqcmd -f create dst -t q -n DASHBOARD.QUEUE -o maxNumMsgs=500000 -o maxBytesPerMsg=50m -o maxTotalMsgBytes=10000m -o limitBehavior=REJECT_NEWEST -o maxNumProducers=300 -o useDMQ=true -u admin -passfile /opt/files/pass.file

# creating DASHBOARD_CACHE.QUEUE dst
/opt/openmq/mq/bin/imqcmd -f create dst -t q -n DASHBOARD_CACHE.QUEUE -o maxNumMsgs=250000 -o maxBytesPerMsg=51m -o maxTotalMsgBytes=10000m -o limitBehavior=REJECT_NEWEST -o maxNumProducers=-1 -o useDMQ=true -u admin -passfile /opt/files/pass.file

# creating DASHBOARD.CACHE.DEAD.QUEUE
/opt/openmq/mq/bin/imqcmd -f create dst -t q -n DASHBOARD.CACHE.DEAD.QUEUE -o maxNumMsgs=250000 -o maxBytesPerMsg=51m -o maxTotalMsgBytes=10000m -o limitBehavior=REJECT_NEWEST -o maxNumProducers=-1 -o useDMQ=true -u admin -passfile /opt/files/pass.file

# creating DASHBOARD.INTERNAL.FAILURE.QUEUE
/opt/openmq/mq/bin/imqcmd -f create dst -t q -n DASHBOARD.INTERNAL.FAILURE.QUEUE -o maxNumMsgs=250000 -o maxBytesPerMsg=51m -o maxTotalMsgBytes=10000m -o limitBehavior=REJECT_NEWEST -o maxNumProducers=-1 -o useDMQ=true -u admin -passfile /opt/files/pass.file

# updating mq.sys.dmq
/opt/openmq/mq/bin/imqcmd -f update dst -t q -n mq.sys.dmq -o maxNumMsgs=250000 -o maxBytesPerMsg=51m -o maxTotalMsgBytes=10000m -o limitBehavior=REMOVE_OLDEST -u admin -passfile /opt/files/pass.file

tail -f /opt/openmq/mq/var/instances/imqbroker/log/log.txt