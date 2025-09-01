SET LINESIZE 2000;
SET PAGESIZE 50000;
SET TRIMSPOOL ON;

spool HKAdventistHospital_Utilization.txt
@HKAdventistHospital_Utilization.sql
spool off;

spool HKAH-oracle-ds-statistic-exclude-admin-extend.txt
@HKAH-oracle-ds-statistic-exclude-admin-extend.sql
spool off;

exit;