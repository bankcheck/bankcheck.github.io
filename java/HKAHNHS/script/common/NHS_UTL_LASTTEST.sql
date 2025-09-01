create or replace
FUNCTION NHS_UTL_LASTTEST (
  v_patno IN varchar2,
  V_BKGSDATE IN VARCHAR2,
  V_BKGEDATE IN VARCHAR2,
  V_DAYS IN VARCHAR2
)
RETURN VARCHAR2
AS
  OUTCUR    TYPES.CURSOR_TYPE;
  RT_VALUE      VARCHAR2(500);
  RT_VALUETEMP  VARCHAR2(100);
BEGIN
    OPEN OUTCUR FOR 
        SELECT DISTINCT DPTABBR 
        FROM (
            SELECT DT.DPTABBR
            FROM SLIPTX ST, (SELECT DPTCODE, DPTABBR
                             FROM DEPT
                             WHERE PRTPICKLIST = '1') DT
            WHERE ST.SLPNO IN (SELECT SLPNO
                               FROM SLIP 
                               WHERE PATNO = v_patno)
            AND ST.STNTDATE >= (TO_DATE(V_BKGSDATE, 'DD/MM/YYYY HH24:MI') - TO_NUMBER(V_DAYS))
            AND ST.STNTDATE <= TO_DATE(V_BKGEDATE, 'DD/MM/YYYY HH24:MI')
            AND ST.STNSTS = 'N'
            AND (CASE WHEN INSTR(ST.GLCCODE, '-') > 0 
                       AND DT.DPTCODE = SUBSTR(ST.GLCCODE, 0, INSTR(ST.GLCCODE, '-'))
                  THEN 1
                      WHEN INSTR(ST.GLCCODE, '-') <= 0
                       AND DT.DPTCODE = ST.GLCCODE
                  THEN 1
                 ELSE 0
                 END) = 1
            ORDER BY STNID DESC
        );
        
     LOOP
        FETCH OUTCUR
          INTO RT_VALUETEMP;
        EXIT WHEN OUTCUR%NOTFOUND;
        RT_VALUE := RT_VALUE || ', ' || RT_VALUETEMP;
     END LOOP;
     
     CLOSE OUTCUR;
     IF LENGTH(RT_VALUE) > 1 THEN
        RETURN SUBSTR(RT_VALUE, 3);
     END IF;
     RETURN '';
END;
/