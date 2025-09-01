create or replace FUNCTION           NHS_LIS_DEPT_ROOM (
	v_DEPTTYPE IN VARCHAR2,
	v_RMTYPE IN VARCHAR2
)
RETURN
	TYPES.CURSOR_TYPE
--VARCHAR2
AS
	OUTCUR TYPES.CURSOR_TYPE;
	V_PARAM SYSPARAM.PARAM1%TYPE;
	V_ROOMCOUNT NUMBER :=0;
	STRSQL VARCHAR2(2000);  
BEGIN
	
  IF v_DEPTTYPE = 'WB' THEN
      STRSQL := 'SELECT DOCLOCID, DOCLOCNAME FROM DOCLOCATION WHERE  DOCTYPE = ''WB'' ORDER BY ORDERBY';
   ELSIF V_DEPTTYPE = 'DT' THEN
      STRSQL := 'SELECT distinct doccode,doccode FROM SCHEDULE WHERE DOCLOCID = ''3'' and schsts=''N'' ';
   ELSIF v_DEPTTYPE = 'APPRM' THEN
      STRSQL := 'SELECT HPSTATUS,HPRMK FROM HPSTATUS WHERE HPTYPE = ''DRROOM'' AND HPKEY = '''||v_RMTYPE||''' ORDER BY HPRMK1 ';      
   ELSIF V_DEPTTYPE = 'RH' THEN
      --STRSQL := 'SELECT distinct doccode,doccode FROM SCHEDULE WHERE DOCCODE like ''R%'' and schsts= ''N'' and to_char(schsdate,''dd/mm/yyyy'') = '''||v_RMTYPE||''' order by 1 ';
      STRSQL := 'SELECT distinct doccode,doccode FROM DOCTOR WHERE DOCCODE IN (''R3'',''R15'',''R49'',''R68'',''R66'',''R54'') and DOCSTS= ''-1'' order by 1 ';
  ELSE
      STRSQL := 'SELECT deptcid, deptcdesc, deptcord FROM dept_code WHERE deptcsts = -1 and deptctype = ''RM''  ';
      IF v_DEPTTYPE IS NOT NULL THEN
        STRSQL := STRSQL || ' AND DEPTTYPE = ''' || V_DEPTTYPE || '''';
      END IF;	
      IF v_RMTYPE IS NOT NULL THEN
        STRSQL := STRSQL || ' AND DEPTCCHR_1 = ''' || v_RMTYPE || '''';
      END IF;	
      STRSQL := STRSQL || 'order by deptcord';
	END IF;
        DBMS_OUTPUT.PUT_LINE(STRSQL);

	OPEN OUTCUR FOR STRSQL;
	RETURN OUTCUR;
--RETURN SQLSTR;
END NHS_LIS_DEPT_ROOM;
/
