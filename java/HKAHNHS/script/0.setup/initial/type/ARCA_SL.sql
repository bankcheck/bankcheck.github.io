create or replace
TYPE ARCA_SL AS OBJECT
(
DUMMY1                         VARCHAR2(1 BYTE),
ATXID                          VARCHAR2(20 BYTE),
PATNO                          VARCHAR2(10 BYTE),
PATNAME						   VARCHAR2(41 BYTE),
SLPNO                          VARCHAR2(15 BYTE),
atxtdate                       VARCHAR2(10 BYTE),    
ATXOAMT						   VARCHAR2(100 BYTE),
AtxAAmt						   VARCHAR2(100 BYTE),
OLDATXAAMT					   VARCHAR2(100 BYTE),
ATXSTS                         VARCHAR2(1 BYTE),  
SLPPLYNO                       VARCHAR2(40 BYTE),
SLPVCHNO					   VARCHAR2(20 BYTE), 
SLPTYPE                        VARCHAR2(1 BYTE)
);
/
