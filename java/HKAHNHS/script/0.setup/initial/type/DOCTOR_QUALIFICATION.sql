create or replace
TYPE DOCTOR_QUALIFICATION AS OBJECT
(
  QLFID                    varchar2(20 byte),
  QLFNAME                  varchar2(200 byte),
  DQLIDATE                 VARCHAR2(200 BYTE),
  DQLID               	   varchar2(200 byte)  
);
/
  