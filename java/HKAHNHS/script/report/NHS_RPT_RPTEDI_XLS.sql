create or replace
FUNCTION  "NHS_RPT_RPTEDI_XLS"
(V_ALLSLPNO IN VARCHAR2)
  Return Types.Cursor_Type
AS
  Outcur Types.Cursor_Type;
  OUTCUR1 TYPES.CURSOR_TYPE;
  Outcur2 Types.Cursor_Type;
  SQLSTR VARCHAR2(32767);
  SQLSTR1 VARCHAR2(32767);
  SQLSTR2 VARCHAR2(32767);
	V_Provider Varchar2(10);
  V_ALLSLPNORP VARCHAR2(1000);
  V_ALLSLPNOR2 VARCHAR2(1000);
  V_LOCATION VARCHAR2(10);
	TYPE_HOSPITAL VARCHAR2(1);
  v_slpnoTemp VARCHAR2(20);
  V_SLPTYPE VARCHAR2(3);
  V_Slpcnt Number := 0;
  V_ISLPCNT NUMBER := 0;
  V_Oslpcnt Number := 0;
  V_DSLPCNT NUMBER := 0;
  

Begin
  
  Sqlstr1 := 'Select Slptype,Count(Slptype) From Slip Where SLPNO in (''' || Replace(V_Allslpno, '/', ''', ''') || ''') GROUP BY slptype';

  OPEN Outcur1 FOR SQLSTR1;
		LOOP
		Fetch Outcur1 Into V_Slptype, V_Slpcnt;
		Exit When Outcur1%Notfound;
      IF V_SLPTYPE = 'I' THEN
        V_ISLPCNT := V_SLPCNT;
      ELSIF V_SLPTYPE = 'O' THEN
        V_OSLPCNT := V_SLPCNT;
      ELSIF V_SLPTYPE = 'D' THEN
        V_DSLPCNT := V_SLPCNT;
      End If;
		End Loop;
  CLOSE OUTCUR1;
  
  Sqlstr2 := 'Select slpno From Slip Where SLPNO in (''' || Replace(V_Allslpno, '/', ''', ''') || ''')';

  OPEN Outcur2 FOR SQLSTR2;
		LOOP
		FETCH OUTCUR2 INTO V_SLPNOTEMP;
		EXIT WHEN OUTCUR2%NOTFOUND;
      IF V_ALLSLPNORP IS NULL OR LENGTH(V_ALLSLPNORP) = 0 THEN
          V_ALLSLPNORP := ''''||V_SLPNOTEMP||'''';
      ELSE
          V_ALLSLPNORP:= V_ALLSLPNORP||','||''''||V_SLPNOTEMP||'''';
      END IF;
      DBMS_OUTPUT.PUT_LINE(V_ALLSLPNORP);
		END LOOP;
  CLOSE OUTCUR2;
      
--    SELECT ''''||LISTAGG(S.SLPNO,''',''') WITHIN GROUP (ORDER BY S.SLPNO)||'''' INTO V_ALLSLPNORP
--    FROM (SELECT DISTINCT SLPNO FROM SLIP WHERE SLPNO IN (V_ALLSLPNOR2))S;
    
  -- GET PROVIDER and LOCATION CODE
	SELECT PARAM1,PARAM2 INTO V_PROVIDER,V_LOCATION FROM SYSPARAM WHERE PARCDE = 'EDICode';
  
   SQLSTR := '
   SELECT *  FROM 
   (select
      S.SLPTYPE,
       '''||V_PROVIDER||''' AS PROVIDER , '''||V_LOCATION||''' AS LOCATION, 
      S.PATNO,
      TO_CHAR(AT.ATXCDATE, ''DD/MM/YYYY'') as IDATE,
      S.SLPVCHNO,
      S.SLPPLYNO,
      P.PATFNAME,
      P.PATGNAME,
      (
      CASE
        WHEN ST.PKGCODE IS NULL
        THEN (''Dr ''||DST.DOCFNAME||'' ''||DST.DOCGNAME||''(''||DST.DOCCODE||'')'')
        ELSE (DECODE(ST.ITMTYPE,''D'',(''Dr ''||D.DOCFNAME||'' ''||D.DOCGNAME||''(''||D.DOCCODE||'')''),''''))
      END) as DOCNAME,
      SE.INSPREAUTHNO,
      DECODE(TO_CHAR(REG.REGDATE, ''DD/MM/YYYY''),null,TO_CHAR(SE.SLPDATE, ''DD/MM/YYYY''),TO_CHAR(REG.REGDATE, ''DD/MM/YYYY'')) as ADATE,
      '''' as DCODE,
      '''' as DDESC,
      DECODE(S.SLPTYPE,''I'',TO_CHAR(INP.INPDDATE, ''DD/MM/YYYY''),'''') as DDATE,
      ''OTHERS'' as DREASON,
      TO_CHAR(ST.STNTDATE, ''DD/MM/YYYY'') as INCDATE,
      DECODE(ST.PKGCODE,NULL,''FEE FOR SERVICE'',''PACKAGE'') as ITEMCAT,
      ST.ITMCODE,
      ST.DESCRIPTION,
      ST.AMOUNT,
      HP.HPSTATUS,
      S.SLPNO
    from REG REG,
      INPAT INP,
      SLIP S,
      SLIPTX_EDI ST,
      PATIENT P,
      DOCTOR D,
      DOCTOR DST,
      SLIP_EXTRA SE,
      HPSTATUS HP,
      ARTX AT
    WHERE ST.SLPNO in (' ||V_ALLSLPNORP|| ')
    AND S.SLPNO = REG.SLPNO(+)
    AND REG.INPID = INP.INPID (+)
    AND S.SLPNO = ST.SLPNO
    AND S.PATNO = P.PATNO(+)
    AND S.DOCCODE = D.DOCCODE(+)
    AND ST.DOCCODE = DST.DOCCODE(+)
    AND S.SLPNO = SE.SLPNO
    AND ST.SLPNO = AT.SLPNO(+)
    AND AT.ATXSTS = ''N'' AND AT.ARPID IS NULL
    AND DECODE(INP.ACMCODE,NULL,S.SLPTYPE,INP.ACMCODE) = HP.HPKEY 
    AND HP.HPTYPE = ''EDIACM''
    ORDER BY S.SLPTYPE,S.SLPNO) STX ';

    
    IF V_ISLPCNT = 0 THEN
      Sqlstr:=Sqlstr||' UNION (SELECT ''I'' AS SLPTYPE ,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,0,null,null FROM DUAL) ';
    END IF;
    IF V_OSLPCNT = 0 THEN
      Sqlstr:=Sqlstr||' UNION (SELECT ''O'' AS SLPTYPE,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,0,null,null FROM DUAL)';
    END IF;
    IF V_DSLPCNT = 0 THEN
      Sqlstr:=Sqlstr||' UNION (Select ''D'' AS SLPTYPE,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,0,null,null FROM DUAL) ';
    End If;
    SQLSTR:=SQLSTR||' ORDER BY 1';
          DBMS_OUTPUT.PUT_LINE(SQLSTR);

   OPEN OUTCUR FOR SQLSTR;
  RETURN OUTCUR;
end NHS_RPT_RPTEDI_XLS;
/