#!/bin/bash

#Start STOMP
nohup /opt/openmq/mq/bin/imqbrokerd -startRmiRegistry -rmiRegistryPort 1616 -port 7676 -vmargs "-server -Xms1g -Xmx5g -XX:MaxMetaspaceSize=1g -XX:-UseGCOverheadLimit -Djava.io.tmpdir=/tmp" > /dev/null 2>&1 &

sleep 10

#README: 
#./imqcmd don't allow to create destination with the name, that exists in mq. 
#This script doesn't update configuration of existed destination. 
#So, there is no problem to run this script on correct mq configuration

echo ----------------------------------------------------------------------------------------------
echo This script creates destinations: 
echo DASHBOARD.QUEUE
echo DASHBOARD_CACHE.QUEUE
echo DASHBOARD.CACHE.DEAD.QUEUE
echo DASHBOARD.INTERNAL.FAILURE.QUEUE
echo updates destination:
echo mq.sys.dmq
echo with special configurations for CI-Dashboard. Password required for creating may be: admin.
echo ----------------------------------------------------------------------------------------------
echo Please enter absolute path to directoty, that contains imqcmd, for example: /opt/openmq/mq/bin

echo creating DASHBOARD.QUEUE dst
sh /opt/openmq/mq/bin/imqcmd -f create dst -t q -n DASHBOARD.QUEUE -o maxNumMsgs=500000 -o maxBytesPerMsg=50m -o maxTotalMsgBytes=10000m -o limitBehavior=REJECT_NEWEST -o maxNumProducers=300 -o useDMQ=true -u admin -passfile /opt/files/pass.file

echo creating DASHBOARD_CACHE.QUEUE dst
sh /opt/openmq/mq/bin/imqcmd -f create dst -t q -n DASHBOARD_CACHE.QUEUE -o maxNumMsgs=250000 -o maxBytesPerMsg=51m -o maxTotalMsgBytes=10000m -o limitBehavior=REJECT_NEWEST -o maxNumProducers=-1 -o useDMQ=true -u admin -passfile /opt/files/pass.file

echo creating DASHBOARD.CACHE.DEAD.QUEUE
sh /opt/openmq/mq/bin/imqcmd -f create dst -t q -n DASHBOARD.CACHE.DEAD.QUEUE -o maxNumMsgs=250000 -o maxBytesPerMsg=51m -o maxTotalMsgBytes=10000m -o limitBehavior=REJECT_NEWEST -o maxNumProducers=-1 -o useDMQ=true -u admin -passfile /opt/files/pass.file

echo creating DASHBOARD.INTERNAL.FAILURE.QUEUE
sh /opt/openmq/mq/bin/imqcmd -f create dst -t q -n DASHBOARD.INTERNAL.FAILURE.QUEUE -o maxNumMsgs=250000 -o maxBytesPerMsg=51m -o maxTotalMsgBytes=10000m -o limitBehavior=REJECT_NEWEST -o maxNumProducers=-1 -o useDMQ=true -u admin -passfile /opt/files/pass.file

echo updating mq.sys.dmq
sh /opt/openmq/mq/bin/imqcmd -f update dst -t q -n mq.sys.dmq -o maxNumMsgs=250000 -o maxBytesPerMsg=51m -o maxTotalMsgBytes=10000m -o limitBehavior=REMOVE_OLDEST -u admin -passfile /opt/files/pass.file

echo
echo Finished updating destinations for CI-Dashboard

tail -f -n +1 /opt/openmq/mq/var/instances/imqbroker/log/log.txt