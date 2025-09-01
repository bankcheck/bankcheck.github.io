create or replace
FUNCTION "NHS_LIS_EGCEXAMREG" (
  v_patno  IN VARCHAR2  
)
	RETURN TYPES.CURSOR_TYPE
  --RETURN string
AS
	OUTCUR TYPES.CURSOR_TYPE;
	SqlStr VARCHAR2(5000);
  --v_patno varchar2(100);
BEGIN   
  --if (v_reported = '0')  then
    SqlStr := 'SELECT TO_CHAR(ST.DIXREF) || ''X''  || TO_CHAR(A.XAPID) AS KEY,ST.unit, ';
    SqlStr := SqlStr  || ' DECODE(S.SLPTYPE,''D'',''DC'',S.SLPTYPE) AS SLPTYPE, ST.DOCCODE, ';
    SqlStr := SqlStr  || ' ST.SLPNO, ST.DIXREF as STNID, ST.STNTDATE, ST.PKGCODE AS PKGCODE, ST.ITMCODE, ST.STNDESC, ';
    SqlStr := SqlStr  || '  ST3.STNOAMT, ST3.STNBAMT, ST3.STNDISC, ST3.STNNAMT, ST3.ONAMT, ST3.OBAMT, ST.USRID AS USRID, ST.GLCCODE, ';
    SqlStr := SqlStr  || '  NVL(E.EXMTIME,0) AS EXMTIME, A.XAPID, TO_CHAR(A.XAPDATE,''DD/MM/YYYY HH24:MI'') AS XAPDATE, ';
    SqlStr := SqlStr  || '  A.ERMCODE, A.XAPESTTIME, 0 AS SELECTED , 0 AS REPORTED , '''' AS REMARK , to_number(Null) AS XRGID, to_date(Null) AS XRGDATE ';
    SqlStr := SqlStr  || '  ,'''' as itemDesc,ST.STNDESC1 ';
    SqlStr := SqlStr  || '   FROM SLIPTX ST, EXAM E, SLIP S, XAPP A, SLIPTX ST2, (select sl.slpno,st2.dixref, ';
    SqlStr := SqlStr  || '  TO_CHAR(SUM(decode(st2.stnsts,''N'',ST2.STNOAMT,0))) AS STNOAMT, TO_CHAR(SUM(ST2.STNBAMT)) AS STNBAMT, ';
    SqlStr := SqlStr  || '  TO_CHAR(SUM(DECODE(ST2.STNSTS,''N'',ST2.STNDISC,0))) AS STNDISC, TO_CHAR(SUM(ST2.STNNAMT)) AS STNNAMT, TO_CHAR(SUM(ST2.STNNAMT)) AS ONAMT, ';
    SqlStr := SqlStr  || ' TO_CHAR(SUM(ST2.STNBAMT)) AS OBAMT  from sliptx st2,slip sl ';
    SqlStr := SqlStr  || '  where st2.slpno = sl.slpno  and ( sl.patno = ''' || v_patno || ''' or sl.SLPNO IN (select SlpNo from Slip  where  PatNo = ''' || v_patno || '''))  ';
    SqlStr := SqlStr  || ' group by sl.slpno,st2.dixref ) ST3  Where  ';
    SqlStr := SqlStr  || '  ST.STNDIFLAG = -1 AND ST.SLPNO = S.SLPNO AND ((S.SLPPAMT + S.SLPCAMT + S.SLPDAMT) <= 0 OR S.SLPTYPE <> ''O'' OR S.SLPUSEAR = -1) ';
    SqlStr := SqlStr  || '  AND ST.STNSTS = ''N'' AND S.SLPNO IN (select SlpNo from Slip  where  PatNo = ''' || v_patno || ''') ';
    SqlStr := SqlStr  || '  AND ST.ITMCODE = E.EXMCODE (+) AND ST.dixref = A.STNID (+) and st.slpno = st2.slpno and st.dixref = st2.dixref AND ST.SLPNO = ST3.SLPNO  AND ST.DIXREF = ST3.DIXREF ';
    SqlStr := SqlStr  || '  union ';
    SqlStr := SqlStr  || ' select ''X'' || to_char(a.XapID) as Key, to_number(null) as unit, '''' as SlpType, '''' as DocCode, a.SlpNo, a.StnID, ';
    SqlStr := SqlStr  || ' a.XAPRDATE as StnTDate, a.PkgCode as PkgCode, a.ExmCode as ItmCode, i.ItmName as StnDesc, '''' as StnOAmt, '''' ';
    SqlStr := SqlStr  || ' as StnBAmt, '''' as StnDisc, '''' as StnNAmt, '''' as ONAmt, '''' as OBAmt, a.UsrID_R as UsrID, '''' as GlcCode, ';
    SqlStr := SqlStr  || ' nvl(e.ExmTime, 0) as ExmTime , a.XapID, to_char(a.XapDate,''DD/MM/YYYY HH24:MI'') as XapDate, a.ErmCode, ';
    SqlStr := SqlStr  || ' a.xapEstTime, 0 as Selected , 0 as reported ,'''' as Remark, to_number(Null) as xrgID, to_date(Null) as xrgDate ';
    SqlStr := SqlStr  || ' ,'''' as itemDesc ,'''' as STNDESC1 ';
    SqlStr := SqlStr  || ' from Xapp a, Item i, Exam e where a.ExmCode = e.ExmCode (+) and a.ExmCode = i.ItmCode ';
    SqlStr := SqlStr  || ' and (a.PatNo = ''' || v_patno || ''' or a.xapid in (select xappid from outrefpatother ';
    SqlStr := SqlStr  || ' where orpfname =''TESTING PATIENT NAME DON''''T RENAME PLEASE'' and orpgname = ''TESTING PATIENT NAME'')) ';
    SqlStr := SqlStr  || ' and  a.StnID IS Null and SlpNo Is Null  and XapSts in (''A'',''P'') order by ItmCode ';
    
    --SqlStr := SqlStr  || ' 
  --end if;

  OPEN outcur FOR SqlStr;
  RETURN OUTCUR;
 --return SqlStr;
	
END NHS_LIS_EGCEXAMREG;