SET LINESIZE 2000;
SET PAGESIZE 50000;
SET TRIMSPOOL ON;

spool TWAdventistHospital_Utilization.txt
@TWAdventistHospital_Utilization.sql
spool off;

spool TWAH-oracle-ds-statistic-exclude-admin-extend.txt
@TWAH-oracle-ds-statistic-exclude-admin-extend.sql
spool off;

exit;