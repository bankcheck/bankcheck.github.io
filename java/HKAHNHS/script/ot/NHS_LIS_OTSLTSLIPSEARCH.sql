CREATE OR REPLACE
FUNCTION "NHS_LIS_OTSLTSLIPSEARCH"(
  V_PATNO				IN VARCHAR2,
  V_PATTYPE				IN VARCHAR2,
  V_REGDATE				IN VARCHAR2	-- dd/mm/yyyy
)
  RETURN TYPES.CURSOR_TYPE AS
  OUTCUR TYPES.CURSOR_TYPE;
  
  SQLSTR VARCHAR2(5000);
  SQLSTR_SELECT1 VARCHAR2(200);
  SQLSTR_SELECT2 VARCHAR2(200);
  SQLSTR_FROM VARCHAR2(100);
  
  v_year    varchar2(4);
  v_days    varchar2(3);
  v_slipno1_pre  VARCHAR2(7);
  v_slipno2_pre  VARCHAR2(7);
  V_REGDATE_D	DATE;
BEGIN
	
  -- SearchResult reg
  SQLSTR := '';
  SQLSTR_SELECT1 := 'select s.slpNo as slpNo,to_char(regdate, ''dd/mm/yyyy hh24:mi:ss''),nvl(to_char(i.inpddate, ''dd/mm/yyyy hh24:mi:ss''),'''') as regmddate ,D.DOCFNAME || '' '' || D.DOCGNAME as doccode ';
  SQLSTR_SELECT2 := 'select s.slpNo as slpNo,'''' as regdate,'''' as regmddate ,D.DOCFNAME || '' '' || D.DOCGNAME as doccode ';
  SQLSTR_FROM := 'from Slip s,Reg r ,Inpat i,doctor d ';
  
  IF V_PATTYPE = 'I' THEN
	SQLSTR := SQLSTR_SELECT1 || SQLSTR_FROM;
	SQLSTR := SQLSTR || 'where s.SlpNO=r.slpNo and s.slpsts<>''R'' and r.Regsts=''N'' and  R.doccode=d.doccode
		and  r.PatNo= ''' || V_PATNO || ''' and r.RegType= ''' || V_PATTYPE || ''' and r.inpid=i.inpid (+) ';
	  IF V_REGDATE IS NOT NULL THEN
	  	SQLSTR := SQLSTR || 'and (( trunc(to_date(''' || V_REGDATE || ''',''dd/mm/yyyy'')) between trunc(regdate)  
	        and trunc(i.inpddate) ) or ((to_date(''' || V_REGDATE || ''',''dd/mm/yyyy'')>=trunc(regdate)) and i.inpddate is null))
			order by s.slpno desc ';
	  END IF;
  ELSIF V_PATTYPE = 'O' THEN
  	-- GENERATE_SLIP_NO (first 7 digits)
  	V_REGDATE_D := to_date(V_REGDATE,'dd/mm/yyyy');
  	v_year    := to_char(V_REGDATE_D, 'yyyy');
	v_days    := to_char(V_REGDATE_D, 'ddd');
	v_days    := lpad(v_days,3,'0');
	v_slipno1_pre := v_year || v_days;
	v_slipno2_pre := to_char(to_number(v_slipno1_pre) + 1);
  	
 	SQLSTR := SQLSTR_SELECT1 || SQLSTR_FROM;
	SQLSTR := SQLSTR || 'where s.SlpNO=r.slpNo and r.Regsts=''N'' and  R.doccode=d.doccode 
		and  r.PatNo=''' || V_PATNO || ''' and r.RegType=''O''  and r.inpid=i.inpid (+) ';

 	IF V_REGDATE IS NOT NULL THEN
		SQLSTR := SQLSTR || ' and ( to_date( ''' || V_REGDATE || ''',''dd/mm/yyyy'') between trunc(regdate) and regdate+1 ) '; 
 	END IF;
 	
 	SQLSTR := SQLSTR || 'and s.regid is not null and s.slpsts<>''R'' ';
	SQLSTR := SQLSTR || 'Union '; 
	SQLSTR := SQLSTR || SQLSTR_SELECT2;
	SQLSTR := SQLSTR || 'from Slip s,doctor d ';
	SQLSTR := SQLSTR || 'where s.doccode=d.doccode(+) 
		and s.patNo=''' || V_PATNO || ''' and  slpType=''O'' and s.regid is null 
		and substr(slpNo,1,7) between ''' || v_slipno1_pre || ''' and ''' || v_slipno2_pre || ''' and s.slpsts<>''R'' 
		order by slpno desc ';
  ELSE
	SQLSTR := SQLSTR_SELECT1 || SQLSTR_FROM;
	SQLSTR := SQLSTR || 'where s.SlpNO=r.slpNo and s.slpsts<>''R'' and r.Regsts=''N'' and  R.doccode=d.doccode
	  	and  r.PatNo= ''' || V_PATNO || ''' and r.RegType= ''' || V_PATTYPE || ''' and r.inpid=i.inpid (+) ';
   	IF V_REGDATE IS NOT NULL THEN
   		SQLSTR := SQLSTR || 'and (to_date( ''' || V_REGDATE || ''',''dd/mm/yyyy'') between trunc(regdate) and  regdate+1) ';
   	END IF;
   	
   	SQLSTR := SQLSTR || ' order by s.slpno desc';
  END IF;
  
  OPEN OUTCUR FOR SQLSTR;
	RETURN OUTCUR;
END NHS_LIS_OTSLTSLIPSEARCH;
/