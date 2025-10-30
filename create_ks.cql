CREATE KEYSPACE test
   WITH replication = {'class': 'NetworkTopologyStrategy', 'us-east-1' : 3}
   AND durable_writes = True;

USE test;
CREATE TABLE test.t (
   id int,
   k int,
   v text,
   PRIMARY KEY (id)
);
CREATE TABLE test.t2 (
   id int,
   k int,
   v text,
   PRIMARY KEY (id)
);

