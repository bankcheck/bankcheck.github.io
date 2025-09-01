create or replace
FUNCTION "NHS_GET_EGCGETQUERYINFO"(
	v_mode  IN VARCHAR2,
  v_param1 IN VARCHAR2 default '',
  v_param2 IN VARCHAR2 default ''  
  --v_mode2  IN VARCHAR2 default ''
)
	RETURN TYPES.cursor_type
AS
	OUTCUR TYPES.cursor_type;
BEGIN
  if v_mode = 'R' then -- Query OutRefPat
    OPEN OUTCUR FOR
    select OrpNo, OrpFName, OrpGName, OrpIDNo, to_char(OrpDOB, 'dd/mm/yyyy'), OrpSex, OrpCName, ErdCode
    from OutRefPat
    where OrpNo = v_param1;
  elsif v_mode = 'P' then -- Query Patient 
    OPEN OUTCUR FOR
    select PatNo, PatFName, PatGName, PatIDNo, to_char(PatBDate, 'dd/mm/yyyy'), PatSex, PatCName, ''
    from Patient
    where PatNo = v_param1;
  elsif v_mode = 'P-IOD' then  -- Query Patient I/O/D
    OPEN OUTCUR FOR
    select r.SlpNo, r.RegDate, r.DocCode, r.RegType, i.BedCode, i.AcmCode, '', ''  
    from Reg r, InPat i, Slip s 
    where r.PatNo = v_param1 and r.RegSts = 'N' and r.InpID = i.InpID (+) and i.InpDDate Is Null 
          and r.slpNo = s.slpNo and s.slpSts = 'A' and r.RegType <> 'O'
    order by r.RegDate desc;
  elsif v_mode = 'P-XJOB' then  -- Query Patient I/O/D
    OPEN OUTCUR FOR
    select r.SlpNo, r.RegDate, r.DocCode, r.RegType, i.BedCode, i.AcmCode 
    from Reg r, InPat i 
    where r.PatNo = v_param1 and r.RegSts = 'N' and 
    r.InpID = i.InpID and i.InpDDate Is Null;
  elsif v_mode = 'P-LASTFILM_NODI' then  -- Query Last Visit which has Film  no di no
    OPEN OUTCUR FOR
    select j.xjbNo, j.xjbDate 
    from xReg r, xJob j
    where xrgid = (select max(xrgid) from xReg r, xJob j where j.patno = v_param1 and j.xjbno = r.xjbno 
                  and r.xrgFilm = -1 and r.xrgRptFlag <> 1) 
          and r.xjbNo = j.xjbNo;
  elsif v_mode = 'P-LASTFILM' then  -- Query Last Visit which has Filmm has di no
    OPEN OUTCUR FOR
    select j.xjbNo, j.xjbDate
    from xReg r, xJob j    
    where xrgid = (select max(xrgid) from xjob j, xreg r 
                  where j.patno = v_param1 and j.xjbDate <= (select xjbDate from xjob where xjbNo = v_param2) 
                  and j.xjbno = r.xjbno and r.xrgFilm = -1 and r.xrgRptFlag <> 1) 
          and r.xjbNo = j.xjbNo;
  elsif v_mode = 'P-LASTVISIT' then  
    OPEN OUTCUR FOR
    select max(j.xjbDate)
    from xjob j, xreg r
    where patno = v_param1 and j.xjbno = r.xjbno and r.xrgsc = 0;
  elsif v_mode = 'P-QRYEXP' then  -- Query Expire
    OPEN OUTCUR FOR
    select xexxrdate,xexxrdis
    from xexpire 
    where patno = v_param1;
  elsif v_mode = 'DATEDIFF' then  -- Query Expire
    OPEN OUTCUR FOR
    SELECT TO_DATE(v_param1, 'dd/mm/yyyy') - sysdate AS DateDiff 
    FROM dual;
  elsif v_mode = 'FILMCOUNT' then  -- Any Film is un-reported
    OPEN OUTCUR FOR
    select count(*)
    from  xreg
    where xrgRptFlag = -1 and xjbNo = v_param1;
  elsif v_mode = 'FILMINFO' then  -- Any Film is un-reported
    OPEN OUTCUR FOR
    select l.xlrLndDate, l.xlrRetDate, l.xjbtloc, l.xlrDel, s.stsDesc || ' ' || l.xjbTLocDesc, r.xrgdisdate
    from xreg r, xlendret l, status s
    where r.xjbno = v_param1 and r.xrgSts = 'N' and r.xrgid = l.xrgid and l.xlrHist is null
    and l.xjbtloc = s.stskey and s.stscat = 'DILOC'
    order by l.xlrid desc;
  elsif v_mode = 'DEFDOC' then  -- Any Film is un-reported
    OPEN OUTCUR FOR
    select param1 from Sysparam where parcde = 'DEFAULTDOC';   
  end if;
 

--    
	RETURN OUTCUR;
END NHS_GET_EGCGETQUERYINFO;