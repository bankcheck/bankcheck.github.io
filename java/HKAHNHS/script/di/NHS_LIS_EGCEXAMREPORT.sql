create or replace
FUNCTION "NHS_LIS_EGCEXAMREPORT" (
  v_xrpt_state_proc in varchar2,
  v_doccode  IN VARCHAR2,
  v_patno IN VARCHAR2,
  v_xrpdate in varchar2,
  v_orderby  in varchar2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	SqlStr VARCHAR2(5000);
  v_state_proc VARCHAR2(5000);
BEGIN  
    v_state_proc := v_xrpt_state_proc;
    --v_state_proc := 'P';
    --SqlStr := 'select /*+ index(j pk_xjob) index(d pk_doctor) index(r pk_xreg) index(rpt IDX_XREPORTHIST_XRGID) */ ';
    --SqlStr := 'select ';
    SqlStr := 'select rpt.xrpDate as reportdate,d.Docfname || '' '' || d.docgname || ''('' || d.doccode || '')'' as reportdr, ';
    SqlStr := SqlStr  || 'j.xjbNo as DINo,st.itmCode as code,st.stndesc || '' '' || st.stndesc1 as description,rpt.usrid_p as perform, ';
    SqlStr := SqlStr  || 'decode(j.xjbfloc,''I'',''IPD'',''O'',''OPD'',''D'',''DC'',''R'',''DI'') as type, rpt.usrid_t as typist,rpt.xrgid,rpt.xrpcombine, rpt.doccode ';
    SqlStr := SqlStr  || 'from xjob j,xreg r,sliptx st,xreporthist rpt,doctor d ';
    SqlStr := SqlStr  || 'where j.xjbno=r.xjbno and r.stnid=st.stnid and r.XrgID = rpt.XrgID ';
    SqlStr := SqlStr  || 'and rpt.doccode=d.doccode  and rpt.xrptsts = ''P'' ';
    
    if v_doccode is not null then
     SqlStr := SqlStr  || 'and rpt.doccode = ''' || v_doccode || ''' '; 
    end if;
    
    
    if v_patno is not null then
      SqlStr := SqlStr  || 'and j.patno = ''' || v_patno || ''' ';      
    end if;
    
    /*
    if v_xrpdate is not null then 
      --28/08/2017
      --SqlStr := SqlStr  || 'and trunc(rpt.xrpdate) =to_date(' || v_xrpdate || ',''dd/mm/yyyy'') '; 
      SqlStr := SqlStr;
    end if;    
    */
    SqlStr := SqlStr  || 'order by ' || v_orderby; 
   OPEN outcur FOR SqlStr;
   RETURN OUTCUR;

	OPEN OUTCUR FOR SqlStr;
	RETURN OUTCUR;
END NHS_LIS_EGCEXAMREPORT;