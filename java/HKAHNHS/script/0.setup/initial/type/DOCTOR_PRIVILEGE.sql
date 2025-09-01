create or replace
TYPE DOCTOR_PRIVILEGE AS OBJECT
(
  PRICODE                   varchar2(20 byte),
  PRINAME                   varchar2(200 byte),
  DPLSDATE                  VARCHAR2(200 BYTE),
  DPLTDATE                  varchar2(200 byte),
  DPLID                     varchar2(200 byte)
);
/
