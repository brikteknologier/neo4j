#!/bin/bash

sed -i "s|#dbms.connectors.default_listen_address=0.0.0.0|dbms.connectors.default_listen_address=$HOSTNAME|g" /etc/neo4j/neo4j.conf
sed -i "s|#dbms.security.auth_enabled=false|dbms.security.auth_enabled=false|g" /etc/neo4j/neo4j.conf
echo "dump_configuration=true" >> /etc/neo4j/neo4j.conf
echo "dbms.pagecache.memory=230m" >> /etc/neo4j/neo4j.conf
echo "wrapper.java.initmemory=230" >> /etc/neo4j/neo4j.conf
echo "wrapper.java.maxmemory=230" >> /etc/neo4j/neo4j.conf

# doing this conditionally in case there is already a limit higher than what
# we're setting here. neo4j recommends at least 40000.
# 
# (http://neo4j.com/docs/1.6.2/configuration-linux-notes.html#_setting_the_number_of_open_files)
limit=`ulimit -n`
if [ "$limit" -lt 65536 ]; then
    ulimit -n 65536;
fi

trap "pkill -SIGTERM -f java; echo SIGTERMd java; exit" 15
    
/usr/bin/neo4j console &
wait
