##################################
# Flush
##################################
nodetool flush

##################################
#Create snapshot
##################################
hid=`hostname -i`
nodetool snapshot -t node-${hid}

##################################
# Gather details
##################################
cqlsh -e "select keyspace_name,table_name, id from system_schema.tables" > /tmp/table-id.cql

find /opt/apache-cassandra-3.11.3/data -type d -name "node-${hid}" -print > /tmp/snapshot_details.log

##################################
# Tar snapshots to backup folder
##################################
find /opt/apache-cassandra-3.11.3/data -type d -name "node-${hid}" -print | xargs tar -rvf  /opt/apache-cassandra-3.11.3/data/backup/snap_dump.tar

tar -xvf /opt/apache-cassandra-3.11.3/data/backup/snap_dump.tar -C /opt/apache-cassandra-3.11.3/data/backup/

##################################
# Clear data directory
##################################

cd /opt/apache-cassandra-3.11.3/data
rm -rf data/*
rm -rf hints/*
rm -rf saved_caches/*
rm -rf commitlog/*

##################################
# Generate create directory script
##################################
for name in `find /opt/apache-cassandra-3.11.3/data/backup/opt -type d -name "node-${hid}" -print `; do target=`echo "$name" | cut -d'/' -f6-11`; echo "mkdir -p /$target/"; done > /tmp/create-directories.sh

chmod 700 /tmp/create-directories.sh

/tmp/create-directories.sh

##################################
# Restore snapshots from backup to data directory
##################################
for name in `find /opt/apache-cassandra-3.11.3/data/backup/opt -type d -name "node-${hid}" -print `; do target=`echo "$name" | cut -d'/' -f6-11`; echo "cp -pr ${name}/*.* /$target/"; done > /tmp/restore-snapshot.sh

chmod 700 /tmp/restore-snapshot.sh

##################################
# start service
##################################
start

##################################
# Verify Details
##################################
cqlsh -e "select * from test.t"
cqlsh -e "select * from test.t2"



