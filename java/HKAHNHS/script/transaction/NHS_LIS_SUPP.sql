create or replace
FUNCTION "NHS_LIS_SUPP" (
  V_ISAVAILABLE   VARCHAR2,
  V_SHOWHISTORY   VARCHAR2,
  V_STNID         VARCHAR2,
  V_SCYCODE       VARCHAR2
)
	RETURN Types.CURSOR_type
AS
	OUTCUR  TYPES.CURSOR_TYPE;
  sqlStr  VARCHAR2(1000);
BEGIN
    IF V_ISAVAILABLE = 'true' THEN
      sqlStr := 'SELECT SCYCODE, SUPCODE, SUPDESC 
                  FROM SUPPCODE 
                  WHERE SCYCODE = ''' ||V_SCYCODE|| '''
                  AND SUPACTIVE = -1
                  ORDER BY SUPCODE';
    ELSE
      sqlStr := 'SELECT TSL.TSLID, SUP.SCYCODE, SUP.SUPCODE, SUP.SUPDESC, TSL.DOCCODE_O, 
                        TSL.DOCCODE_T, TSL.REMARK, TSL.USRID_A, TO_CHAR(TSL.TSLDATE_A, ''DD/MM/YYYY''), 
                        TSL.USRID_C, DECODE(TSL.TSLDATE_C, NULL, '''', TO_CHAR(TSL.TSLDATE_C, ''DD/MM/YYYY'')), 
                        TO_CHAR(TSL.TSLDATE_A, ''HH24:MI:SS''),  
                        DECODE(TSL.TSLDATE_C, NULL, '''', TO_CHAR(TSL.TSLDATE_C, ''HH24:MI:SS'')) 
                  FROM TXNENDOSDTLS TSL, SUPPCODE SUP 
                  WHERE TSL.SUPCODE = SUP.SUPCODE 
                  AND STNID = '''||V_STNID||'''';
      IF V_SHOWHISTORY = 'false' THEN
        SQLSTR := SQLSTR || ' AND TSL.USRID_C IS NULL ';
      END IF;
    END IF;
  OPEN OUTCUR FOR sqlStr;
	RETURN OUTCUR;
END NHS_LIS_SUPP;
/