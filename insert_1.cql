use test;
INSERT INTO test.t (id, k, v) VALUES (0, 0, 'val0');
INSERT INTO test.t (id, k, v) VALUES (1, 1, 'val1');

INSERT INTO test.t2 (id, k, v) VALUES (0, 0, 'val0');
INSERT INTO test.t2 (id, k, v) VALUES (1, 1, 'val1');
INSERT INTO test.t2 (id, k, v) VALUES (2, 2, 'val2');


select * from test.t;
select * from test.t2;

