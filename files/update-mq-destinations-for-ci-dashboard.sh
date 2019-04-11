#!/bin/bash

echo ----------------------------------------------------------------------------------------------
echo This script updates destinations: 
echo DASHBOARD.QUEUE
echo DASHBOARD_CACHE.QUEUE
echo DASHBOARD.CACHE.DEAD.QUEUE
echo DASHBOARD.INTERNAL.FAILURE.QUEUE
echo mq.sys.dmq
echo with special configurations for CI-Dashboard. Password required for creating may be: admin.
echo ----------------------------------------------------------------------------------------------
echo Please enter absolute path to directoty, that contains imqcmd, for example: /opt/openmq/mq/bin
read path_to_directory

echo updating DASHBOARD.QUEUE
sh /opt/openmq/mq/bin/imqcmd update dst -t q -n DASHBOARD.QUEUE -o maxNumMsgs=500000 -o maxBytesPerMsg=50m -o maxTotalMsgBytes=10000m -o limitBehavior=REJECT_NEWEST -o maxNumProducers=300 -o useDMQ=true -u admin

echo updating DASHBOARD_CACHE.QUEUE
sh /opt/openmq/mq/bin/imqcmd update dst -t q -n DASHBOARD_CACHE.QUEUE -o maxNumMsgs=250000 -o maxBytesPerMsg=51m -o maxTotalMsgBytes=10000m -o limitBehavior=REJECT_NEWEST -o maxNumProducers=-1 -o useDMQ=true -u admin

echo updating DASHBOARD.CACHE.DEAD.QUEUE
sh /opt/openmq/mq/bin/imqcmd update dst -t q -n DASHBOARD.CACHE.DEAD.QUEUE -o maxNumMsgs=250000 -o maxBytesPerMsg=51m -o maxTotalMsgBytes=10000m -o limitBehavior=REJECT_NEWEST -o maxNumProducers=-1 -o useDMQ=true -u admin

echo updating DASHBOARD.INTERNAL.FAILURE.QUEUE
sh /opt/openmq/mq/bin/imqcmd update dst -t q -n DASHBOARD.INTERNAL.FAILURE.QUEUE -o maxNumMsgs=250000 -o maxBytesPerMsg=51m -o maxTotalMsgBytes=10000m -o limitBehavior=REJECT_NEWEST -o maxNumProducers=-1 -o useDMQ=true -u admin

echo updating mq.sys.dmq
sh /opt/openmq/mq/bin/imqcmd update dst -t q -n mq.sys.dmq -o maxNumMsgs=250000 -o maxBytesPerMsg=51m -o maxTotalMsgBytes=10000m -o limitBehavior=REMOVE_OLDEST -u admin

echo
echo Finished updating destinations for CI-Dashboard