SET LINESIZE 2000;
SET PAGESIZE 50000;
SET TRIMSPOOL ON;

spool result.txt
@oracle-block.sql
spool off;

exit;