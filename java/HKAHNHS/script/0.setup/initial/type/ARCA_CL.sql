create or replace
TYPE ARCA_CL AS OBJECT
(
dummy1               varchar2(1 BYTE),
atxdesc              varchar2(100 byte),
atxrefid             varchar2(100 byte),
tdate						     varchar2(10 BYTE),
ATXOAMT						   VARCHAR2(100 BYTE),
atxaamt						   varchar2(100 BYTE),
atxsts						   varchar2(1 BYTE),
dummy2						   varchar2(1 BYTE),
atxamt						   varchar2(100 BYTE),
ATXSAMT						   VARCHAR2(100 BYTE),
atxid                varchar2(20 byte)
);
/
