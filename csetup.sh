#!/bin/bash

sid="$1"
hid=`hostname -i`

if [[ -z "$1" ]]
then
    echo "Usage: ./csetup.sh <seed_ip>"
    exit 1
fi

echo "====================================================================================== Updating apt ======================================================================================"
sudo apt update
echo "====================================================================================== Installing JDK ===================================================================================="
sudo apt install openjdk-8-jre-headless -y

echo "====================================================================================== Setting up Java HOME Path ========================================================================="
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc
echo "export JRE_HOME=\$JAVA_HOME/jre" >> ~/.bashrc
echo "export PATH=\$PATH:\$JAVA_HOME/bin:\$JAVA_HOME/jre/bin" >> ~/.bashrc
source ~/.bashrc

echo "====================================================================================== Installing Cassandra 3.11.3 ========================================================================="
wget https://archive.apache.org/dist/cassandra/3.11.3/apache-cassandra-3.11.3-bin.tar.gz
tar -xvf apache-cassandra-3.11.3-bin.tar.gz
sudo mv apache-cassandra-3.11.3 /opt/
cd /opt/apache-cassandra-3.11.3

echo "====================================================================================== Installing python2.7 =================================================================================="
sudo apt install python2.7 -y

echo "====================================================================================== Modifying Parameters =================================================================================="

sed -i 's/^\s*cluster_name: .*/cluster_name: "production"/' /opt/apache-cassandra-3.11.3/conf/cassandra.yaml
sed -i "s/^\s*listen_address: .*/listen_address: \"$hid\"/" /opt/apache-cassandra-3.11.3/conf/cassandra.yaml
sed -i "s/^\s*          - seeds: .*/          - seeds: \"$sid\"/" /opt/apache-cassandra-3.11.3/conf/cassandra.yaml
sed -i 's/^\s*endpoint_snitch: .*/endpoint_snitch: GossipingPropertyFileSnitch/' /opt/apache-cassandra-3.11.3/conf/cassandra.yaml
sed -i "s/^\s*rpc_address: .*/rpc_address: $hid/" /opt/apache-cassandra-3.11.3/conf/cassandra.yaml

sed -i 's/^\s*dc=.*/dc=us-east-1/' /opt/apache-cassandra-3.11.3/conf/cassandra-rackdc.properties

echo 'JVM_OPTS="$JVM_OPTS -Djava.rmi.server.hostname='"${hid}"'"' >> /opt/apache-cassandra-3.11.3/conf/cassandra-env.sh

echo "====================================================================================== Setting up alias ======================================================================================="
echo "alias nodetool='/opt/apache-cassandra-3.11.3/bin/nodetool -Dcom.sun.jndi.rmiURLParsing=legacy'" >> ~/.bashrc
echo "alias cqlsh='/opt/apache-cassandra-3.11.3/bin/cqlsh `hostname -i` -u cassandra -p cassandra'"   >> ~/.bashrc
echo "alias l='cd /opt/apache-cassandra-3.11.3/logs'" >> ~/.bashrc
echo "alias c='cd /opt/apache-cassandra-3.11.3/conf'" >> ~/.bashrc
echo "alias d='cd /opt/apache-cassandra-3.11.3/data'" >> ~/.bashrc
echo "alias start='/opt/apache-cassandra-3.11.3/bin/cassandra -R'" >> ~/.bashrc
echo "alias stop='/opt/apache-cassandra-3.11.3/bin/nodetool -Dcom.sun.jndi.rmiURLParsing=legacy stopdaemon'" >> ~/.bashrc
source ~/.bashrc


echo "====================================================================================== verify parameters ======================================================================================="
egrep 'cluster_name|listen_address|broadcast_address|rpc_address|seeds|endpoint_snitch' /opt/apache-cassandra-3.11.3/conf/cassandra.yaml | grep -v '^#'
grep 'rmi.server' /opt/apache-cassandra-3.11.3/conf/cassandra-env.sh
egrep 'rack|dc' /opt/apache-cassandra-3.11.3/conf/cassandra-rackdc.properties


echo "====================================================================================== Downloading scripts ======================================================================================"
wget https://raw.githubusercontent.com/shrrikanthr/cass-scripts/refs/heads/main/create_ks.cql
wget https://raw.githubusercontent.com/shrrikanthr/cass-scripts/refs/heads/main/insert_1.cql
wget https://raw.githubusercontent.com/shrrikanthr/cass-scripts/refs/heads/main/insert_2.cql
wget https://raw.githubusercontent.com/shrrikanthr/cass-scripts/refs/heads/main/archive_commitlogs.sh
wget https://raw.githubusercontent.com/shrrikanthr/cass-scripts/refs/heads/main/restore_commitlogs.sh
wget https://raw.githubusercontent.com/shrrikanthr/cass-scripts/refs/heads/main/commitlog_archiving.properties
wget https://raw.githubusercontent.com/shrrikanthr/cass-scripts/refs/heads/main/copy-untar-snapshots-to-source.sh

mv archive_commitlogs.sh /opt/apache-cassandra-3.11.3/bin/
mv restore_commitlogs.sh /opt/apache-cassandra-3.11.3/bin/
mv commitlog_archiving.properties /opt/apache-cassandra-3.11.3/conf/




