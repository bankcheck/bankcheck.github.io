CREATE OR REPLACE FUNCTION NHS_LIS_LOOKUPPATNO(V_PATNO  IN VARCHAR2,
                                               V_RESULT IN VARCHAR2,
                                               V_TABLE  IN VARCHAR2)
  RETURN TYPES.CURSOR_TYPE 
  AS
  SQLSTR VARCHAR2(500);
  OUTCUR TYPES.CURSOR_TYPE;
BEGIN
  SQLSTR := 'SELECT '' '','''|| V_TABLE ||''','''|| V_RESULT ||''',' || V_RESULT || 
            ' FROM ' || V_TABLE ||
            ' WHERE PATNO =  ''' || V_PATNO || ''' ORDER BY ' || V_RESULT;
  OPEN OUTCUR FOR SQLSTR;
  RETURN OUTCUR;
END NHS_LIS_LOOKUPPATNO;
/
