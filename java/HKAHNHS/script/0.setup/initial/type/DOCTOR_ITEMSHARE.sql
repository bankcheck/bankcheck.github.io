create or replace
TYPE DOCTOR_ITEMSHARE AS OBJECT
(
  SLPTYPE                   varchar2(20 byte),
  PCYID                     varchar2(200 byte),
  DSCCODE                   VARCHAR2(200 BYTE),
  ITMCODE                   varchar2(200 byte),
  ITMNAME                   VARCHAR2(200 BYTE),
  DIPPCT                    VARCHAR2(23 BYTE),
  DIPFIX                    varchar2(23 byte),
  DIPID                     VARCHAR2(20 BYTE)
);
/