REM INSERTING into SYSPARAM
SET DEFINE OFF;
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRUL_ADR','20150101000000','YYYYMMDDHH24MISS','eHR ADR last upload');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRUL_ALG','20150101000000','YYYYMMDDHH24MISS','eHR Allergy last upload');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRUL_CNS','20150101000000','YYYYMMDDHH24MISS','eHR C. Note last upload');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRUL_BIRT','20150101000000','YYYYMMDDHH24MISS','eHR Birth last upload');

Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRRISSPTH','\\hkim\ah\IT\',null,'eHR RIS report src path');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRRISTPTH','/tmp/ris/',null,'eHR RIS report tmp path');

Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRSMBUID','webfolder@ahhk.local',null,'eHR SMB username');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRSMBPW','folder',null,'eHR SMB user password');

REM HKAH-SR
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMHOST','160.100.2.6',null,'eHR mail host');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMPORT','25',null,'eHR mail port');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMPROTO','smtp',null,'eHR mail protocol');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMAUTH','false',null,'eHR mail is use auth');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMUSER','N/A',null,'eHR mail username');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMPW','N/A',null,'eHR mail password');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMCTIMEO','30000',null,'eHR mail conn timeout');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMTIMEO','30000',null,'eHR mail timeout');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMATEST','ricky.leung@hkah.org.hk',null,'eHR mail addr tester');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMAALERT','alert@hkah.org.hk',null,'eHR mail addr alert');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMAADMIN','mary.chu@hkah.org.hk',null,'eHR mail addr admin');

REM HKAH-TW
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMHOST','it-mx1',null,'eHR mail host');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMPORT','25',null,'eHR mail port');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMPROTO','smtp',null,'eHR mail protocol');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMAUTH','false',null,'eHR mail is use auth');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMUSER','alert',null,'eHR mail username');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMPW','QAPMPKPEPOTATLTC',null,'eHR mail password');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMCTIMEO','70000',null,'eHR mail conn timeout');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMTIMEO','70000',null,'eHR mail timeout');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMATEST','ricky.leung@hkah.org.hk',null,'eHR mail addr tester');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMAALERT','alert@twah.org.hk',null,'eHR mail addr alert');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMAADMIN','mary.chu@hkah.org.hk',null,'eHR mail addr admin');

REM temp for twah email
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMTWHOST','it-mx1.twahdm5.local',null,'eHR mail host');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMTWPORT','25',null,'eHR mail port');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMTWPROT','smtp',null,'eHR mail protocol');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMTWAUTH','false',null,'eHR mail is use auth');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMTWUSER','alert',null,'eHR mail username');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMTWPW','QAPMPKPEPOTATLTC',null,'eHR mail password');
Insert into SYSPARAM@hat (PARCDE,PARAM1,PARAM2,PARDESC) values ('EHRMTWAALE','alert@twah.org.hk',null,'eHR mail addr alert');

