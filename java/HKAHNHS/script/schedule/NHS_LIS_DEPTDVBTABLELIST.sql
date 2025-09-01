create or replace
FUNCTION                          NHS_LIS_DEPTDVBTABLELIST (
	DEPTAID_sql IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	SQLSTR VARCHAR2(3000);
BEGIN
	SQLSTR := '
		select  '''' as allergy,a.deptaid,
      DECODE(a.pattype,''I'',''In Patient'',''E'',''In-Patient Add-On'',''O'',''Out Patient'',''F'',''Out Patient Add-On'',a.pattype),
			to_char(a.deptaosdate,''dd/mm/yyyy hh24:mi''),
      a.deptbed,			
			decode(trunc(deptaosdate)-trunc(deptaoedate),
			0,
			to_char(deptaoedate,''HH24:MI''),
			to_char(deptaoedate,''dd/mm/yyyy hh24:mi'')) as deptaoedate,
			d.DOCFNAME ||'' ''|| d.DOCGNAME ,
      DP.DOCFNAME || '' ''||DP.DOCGNAME as repDoctor,
			0,			
			a.patno,
			a.deptafname,
			a.deptagname,
			a.deptafname || '' '' || a.deptagname as name,
			trunc(months_between(sysdate,a.deptabdate)/12) as Age,
			p.deptpdesc,		
			a.deptasts,
      		C.DEPTCDESC AS DEPTPDESC_RM,
			a.DEPTPRMK,
			a.deptatel,
      a.DEPTUSRID,
			to_char(a.DEPTACDATE,''dd/mm/yyyy hh24:mi''),
      a.MODIFY_USER,
			to_char(a.MODIFY_DATE,''dd/mm/yyyy hh24:mi''),
      decode(a.deptasts,''N'',''Normal'',''F'',''Confirmed'') as Status
		from  dept_proc p, dept_app a, dept_code c, patient pat, DOCTOR d, DOCTOR DP
		where a.deptpid = p.deptpid
		and   a.DEPTCID_RM = c.deptcid
		and   a.patno = pat.patno(+) 
    AND   A.DOCCODE_R = D.DOCCODE(+)
    AND A.DOCCODE_P = DP.DOCCODE(+)';
	SQLSTR := SQLSTR || deptAID_sql ||' order by a.deptaosdate';
	OPEN OUTCUR FOR SQLSTR;
	RETURN OUTCUR;
END NHS_LIS_DEPTDVBTABLELIST;
/
