select txn.id as id, txn.commit_time_ms as commit_time_ms, count(case when node.type_qname_id != null then 1 end) as updates, count(case when node.type_qname_id = null then 1 end) as deletes
from alf_transaction txn join alf_node node on (txn.id = node.transaction_id)
WHERE txn.commit_time_ms >= 1424702134460 and txn.commit_time_ms < 1424788534460 group by txn.commit_time_ms, txn.id order by txn.commit_time_ms ASC, txn.id ASC;
-- Drop HASH partitioned index IDX_ALF_TXN_CTMS and create as normal index.
DROP INDEX ALFRESCO.IDX_ALF_TXN_CTMS;
CREATE INDEX ALFRESCO.IDX_ALF_TXN_CTMS ON ALFRESCO.ALF_TRANSACTION (COMMIT_TIME_MS, ID) TABLESPACE INDEX1 NOLOGGING ONLINE;
ALTER INDEX ALFRESCO.IDX_ALF_TXN_CTMS LOGGING;
-- Drop HASH partitioned index IDX_ALF_NODE_TXN_TYPE and create as normal index.
DROP INDEX ALFRESCO.IDX_ALF_NODE_TXN_TYPE;
CREATE INDEX ALFRESCO.IDX_ALF_NODE_TXN_TYPE ON ALFRESCO.ALF_NODE (TRANSACTION_ID, TYPE_QNAME_ID) TABLESPACE INDEX1 LOGGING ONLINE;
ALTER INDEX ALFRESCO.IDX_ALF_NODE_TXN_TYPE LOGGING;
--






create table gsk_alf_transaction as select * from alf_transaction;
create table gsk_alf_node as select * from alf_node;
-- 
select txn.id as id, txn.commit_time_ms as commit_time_ms, count(case when node.type_qname_id != null then 1 end) as updates, count(case when node.type_qname_id = null then 1 end) as deletes
from gsk_alf_transaction txn join gsk_alf_node node on (txn.id = node.transaction_id)
WHERE txn.commit_time_ms >= 1424702134460 and txn.commit_time_ms < 1424788534460 group by txn.commit_time_ms, txn.id order by txn.commit_time_ms ASC, txn.id ASC;
--
-- Drop HASH partitioned index IDX_ALF_TXN_CTMS and create as normal index.
DROP INDEX ALFRESCO.GSK_IDX_ALF_TXN_CTMS;
CREATE INDEX ALFRESCO.GSK_IDX_ALF_TXN_CTMS ON ALFRESCO.gsk_alf_transaction (COMMIT_TIME_MS, ID) TABLESPACE INDEX1 NOLOGGING ONLINE;
ALTER INDEX ALFRESCO.GSK_IDX_ALF_TXN_CTMS LOGGING;
-- Drop HASH partitioned index IDX_ALF_NODE_TXN_TYPE and create as normal index.
DROP INDEX ALFRESCO.GSK_IDX_ALF_NODE_TXN_TYPE;
CREATE INDEX ALFRESCO.GSK_IDX_ALF_NODE_TXN_TYPE ON ALFRESCO.gsk_alf_node (TRANSACTION_ID, TYPE_QNAME_ID) TABLESPACE INDEX1 LOGGING ONLINE;
ALTER INDEX ALFRESCO.GSK_IDX_ALF_NODE_TXN_TYPE LOGGING;
--

DROP TABLE gsk_alf_transaction;
DROP TABLE gsk_alf_node;

select * from all_objects where object_name like 'gsk%';


CREATE INDEX ALFRESCO.GSK_IDX_ALF_TXN_CTMS ON ALFRESCO.gsk_alf_transaction (COMMIT_TIME_MS, ID) TABLESPACE INDEX1 NOLOGGING ONLINE GLOBAL PARTITION BY HASH (COMMIT_TIME_MS, ID) ;
ALTER INDEX ALFRESCO.GSK_IDX_ALF_TXN_CTMS LOGGING;
-- Drop HASH partitioned index IDX_ALF_NODE_TXN_TYPE and create as normal index.
DROP INDEX ALFRESCO.GSK_IDX_ALF_NODE_TXN_TYPE;
CREATE INDEX ALFRESCO.GSK_IDX_ALF_NODE_TXN_TYPE ON ALFRESCO.gsk_alf_node (TRANSACTION_ID, TYPE_QNAME_ID) TABLESPACE INDEX1 LOGGING ONLINE;
ALTER INDEX ALFRESCO.GSK_IDX_ALF_NODE_TXN_TYPE LOGGING;

CREATE INDEX ALFRESCO.GSK_IDX_ALF_TXN_CTMS ON ALFRESCO.gsk_alf_transaction
(COMMIT_TIME_MS, ID)
  TABLESPACE INDEX1
  PCTFREE    10
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              INITIAL          64K
              BUFFER_POOL      DEFAULT
             )
LOGGING
GLOBAL PARTITION BY HASH (COMMIT_TIME_MS, ID) (  
  PARTITION IDX_ALF_TXN_CTMS_P111
    TABLESPACE INDEX1,  
  PARTITION IDX_ALF_TXN_CTMS_P211
    TABLESPACE INDEX1,  
  PARTITION IDX_ALF_TXN_CTMS_P311
    TABLESPACE INDEX1,  
  PARTITION IDX_ALF_TXN_CTMS_P411
    TABLESPACE INDEX1,  
  PARTITION IDX_ALF_TXN_CTMS_P511
    TABLESPACE INDEX1,  
  PARTITION IDX_ALF_TXN_CTMS_P611
    TABLESPACE INDEX1,  
  PARTITION IDX_ALF_TXN_CTMS_P711
    TABLESPACE INDEX1,  
  PARTITION IDX_ALF_TXN_CTMS_P811
    TABLESPACE INDEX1
);


CREATE INDEX ALFRESCO.GSK_IDX_ALF_NODE_TXN_TYPE ON ALFRESCO.GSK_ALF_NODE
(TRANSACTION_ID, TYPE_QNAME_ID)
  TABLESPACE INDEX1
  PCTFREE    10
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              INITIAL          64K
              NEXT             1M
              MINEXTENTS       1
              MAXEXTENTS       UNLIMITED
              PCTINCREASE      0
              BUFFER_POOL      DEFAULT
             )
GLOBAL PARTITION BY HASH (TRANSACTION_ID, TYPE_QNAME_ID) (  
  PARTITION NODE_TXN_P111
    TABLESPACE INDEX1,  
  PARTITION NODE_TXN_P211
    TABLESPACE INDEX1,  
  PARTITION NODE_TXN_P311
    TABLESPACE INDEX1,  
  PARTITION NODE_TXN_P411
    TABLESPACE INDEX1
);



Plan hash value: 2033818967
 
--------------------------------------------------------------------------------------------
| Id  | Operation           | Name                 | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |                      |    17 |   425 |   108K  (1)| 00:00:05 |
|   1 |  SORT GROUP BY      |                      |    17 |   425 |   108K  (1)| 00:00:05 |
|*  2 |   HASH JOIN         |                      | 26304 |   642K|   108K  (1)| 00:00:05 |
|*  3 |    INDEX RANGE SCAN | GSK_IDX_ALF_TXN_CTMS | 16304 |   238K|     6   (0)| 00:00:01 |
|   4 |    TABLE ACCESS FULL| GSK_ALF_NODE         |    25M|   243M|   108K  (1)| 00:00:05 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("TXN"."ID"="NODE"."TRANSACTION_ID")
   3 - access("TXN"."COMMIT_TIME_MS">=1424702134460 AND 
              "TXN"."COMMIT_TIME_MS"<1424788534460)


Plan hash value: 3538219827
 
--------------------------------------------------------------------------------------------------
| Id  | Operation            | Name                      | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |                           |    17 |   425 |  1637   (0)| 00:00:01 |
|   1 |  SORT GROUP BY NOSORT|                           |    17 |   425 |  1637   (0)| 00:00:01 |
|   2 |   NESTED LOOPS       |                           | 26304 |   642K|  1637   (0)| 00:00:01 |
|*  3 |    INDEX RANGE SCAN  | GSK_IDX_ALF_TXN_CTMS      | 16304 |   238K|     6   (0)| 00:00:01 |
|*  4 |    INDEX RANGE SCAN  | GSK_IDX_ALF_NODE_TXN_TYPE |     2 |    20 |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("TXN"."COMMIT_TIME_MS">=1424702134460 AND 
              "TXN"."COMMIT_TIME_MS"<1424788534460)
   4 - access("TXN"."ID"="NODE"."TRANSACTION_ID")

Plan hash value: 3917721159
 
------------------------------------------------------------------------------------------------------------------
| Id  | Operation            | Name                      | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |                           | 26304 |   642K|  1639   (1)| 00:00:01 |       |       |
|   1 |  SORT GROUP BY       |                           | 26304 |   642K|  1639   (1)| 00:00:01 |       |       |
|   2 |   NESTED LOOPS       |                           | 26304 |   642K|  1637   (0)| 00:00:01 |       |       |
|   3 |    PARTITION HASH ALL|                           | 16304 |   238K|     6   (0)| 00:00:01 |     1 |     8 |
|*  4 |     INDEX RANGE SCAN | GSK_IDX_ALF_TXN_CTMS      | 16304 |   238K|     6   (0)| 00:00:01 |     1 |     8 |
|   5 |    PARTITION HASH ALL|                           |     2 |    20 |     1   (0)| 00:00:01 |     1 |     4 |
|*  6 |     INDEX RANGE SCAN | GSK_IDX_ALF_NODE_TXN_TYPE |     2 |    20 |     1   (0)| 00:00:01 |     1 |     4 |
------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("TXN"."COMMIT_TIME_MS">=1424702134460 AND "TXN"."COMMIT_TIME_MS"<1424788534460)
   6 - access("TXN"."ID"="NODE"."TRANSACTION_ID")


Plan hash value: 3743246169
 
------------------------------------------------------------------------------------------------------------------
| Id  | Operation            | Name                      | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |                           | 26304 |   642K| 40014   (1)| 00:00:02 |       |       |
|   1 |  SORT GROUP BY       |                           | 26304 |   642K| 40014   (1)| 00:00:02 |       |       |
|   2 |   NESTED LOOPS       |                           | 26304 |   642K| 40012   (1)| 00:00:02 |       |       |
|*  3 |    TABLE ACCESS FULL | GSK_ALF_TRANSACTION       | 16304 |   238K| 38382   (1)| 00:00:02 |       |       |
|   4 |    PARTITION HASH ALL|                           |     2 |    20 |     1   (0)| 00:00:01 |     1 |     4 |
|*  5 |     INDEX RANGE SCAN | GSK_IDX_ALF_NODE_TXN_TYPE |     2 |    20 |     1   (0)| 00:00:01 |     1 |     4 |
------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - filter("TXN"."COMMIT_TIME_MS"<1424788534460 AND "TXN"."COMMIT_TIME_MS">=1424702134460)
   5 - access("TXN"."ID"="NODE"."TRANSACTION_ID")


Plan hash value: 1892238046
 
-------------------------------------------------------------------------------------------
| Id  | Operation           | Name                | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |                     | 26304 |   642K|   146K  (1)| 00:00:06 |
|   1 |  SORT GROUP BY      |                     | 26304 |   642K|   146K  (1)| 00:00:06 |
|*  2 |   HASH JOIN         |                     | 26304 |   642K|   146K  (1)| 00:00:06 |
|*  3 |    TABLE ACCESS FULL| GSK_ALF_TRANSACTION | 16304 |   238K| 38382   (1)| 00:00:02 |
|   4 |    TABLE ACCESS FULL| GSK_ALF_NODE        |    25M|   243M|   108K  (1)| 00:00:05 |
-------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("TXN"."ID"="NODE"."TRANSACTION_ID")
   3 - filter("TXN"."COMMIT_TIME_MS"<1424788534460 AND 
              "TXN"."COMMIT_TIME_MS">=1424702134460)
