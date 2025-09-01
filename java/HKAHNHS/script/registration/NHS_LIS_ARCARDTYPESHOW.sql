CREATE OR REPLACE FUNCTION NHS_LIS_ARCARDTYPESHOW (
  v_arccode IN VARCHAR2
)
  RETURN Types.cursor_type
--  RETURN VARCHAR2
  AS
  OUTCUR types.cursor_type;
  sqlstr VARCHAR2(2000);
BEGIN
	sqlstr := 'select actid, actcode from arcardtype where arccode = '''||v_arccode||''' and actactive = -1 ORDER BY actid';
  OPEN OUTCUR FOR sqlstr;
  RETURN OUTCUR;
--  RETURN sqlstr;
END NHS_LIS_ARCARDTYPESHOW;
/
