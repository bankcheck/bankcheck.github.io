create or replace
TYPE DOCTOR_ITEMSHAREHIST AS OBJECT
(
  CONSTARTDATE		   		VARCHAR2(10 BYTE),
  CONENDDATE		   		VARCHAR2(10 BYTE),
  SLPTYPE                   varchar2(20 byte),
  PCYID                     varchar2(200 byte),
  DSCCODE                   VARCHAR2(200 BYTE),
  ITMCODE                   varchar2(200 byte),
  ITMNAME                   VARCHAR2(200 BYTE),
  DIPPCT                    VARCHAR2(23 BYTE),
  DIPFIX                    varchar2(23 byte),
  DIPHID                    VARCHAR2(20 BYTE)
);
/