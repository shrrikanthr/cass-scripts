
## snapshot
hid=`hostname -i`
nodetool snapshot -t node-${hid}

## tar snapshots

mkdir -p /opt/apache-cassandra-3.11.3/data/backup

find /opt/apache-cassandra-3.11.3/data -type d -name "node-${hid}" -print0 | tar --null -czvf /opt/apache-cassandra-3.11.3/data/backup/all_snapshots.tar.gz --files-from -


## untar

tar -xzvf all_snapshots.tar.gz -C  /opt/apache-cassandra-3.11.3/data/backup

## remove data directory table folders

find /opt/apache-cassandra-3.11.3/data/backup/ -name "node-${hid}" -print | while read x; do dest=`echo "$x" | cut -d'/' -f6-11`; dest="/$dest"; echo "rm -rf $dest/*"; done > /tmp/clear-data-before-restore.sh
chmod 700 /tmp/clear-data-before-restore.sh
/tmp/clear-data-before-restore.sh

## copy snapshots from backup untar directory to original directory

touch /tmp/restore-data.sh
cat /dev/null > /tmp/restore-data.sh

find /opt/apache-cassandra-3.11.3/data/backup/ -name "node-${hid}" -print | while read x
do 
sour=`echo "$x" `
dest=`echo "$x" | cut -d'/' -f6-11`
dest="/$dest"
echo "cp -p $sour/*.* $dest/" >> /tmp/restore-data.sh
done

chmod 700 /tmp/restore-data.sh


