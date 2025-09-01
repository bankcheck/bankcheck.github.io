create or replace
TYPE DOCTOR_SPECIALTY AS OBJECT
(
  SPCCODE                   varchar2(20 byte),
  spcname                   varchar2(200 byte),
  ISOFFICIAL                VARCHAR2(200 BYTE),
  DSLID     	            varchar2(200 byte),
  ISOFFICIAL_NB                VARCHAR2(200 BYTE)
);
/
