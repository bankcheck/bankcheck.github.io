create or replace
FUNCTION "NHS_LIS_ECGPENDEXAM" (
  v_mode in varchar2,  -- 0 , 1
  v_datefrom in varchar2,
  v_dateto in varchar2,
  v_slpno IN VARCHAR2,
  v_dsccode IN VARCHAR2,
  v_patno IN VARCHAR2,
  v_patfname IN VARCHAR2,
  v_patgname IN VARCHAR2,
  v_showcancel IN VARCHAR2 -- Y, N
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	SqlStr VARCHAR2(30000);  
  dideptcode varchar2(100);
  xapsts varchar2(100);
BEGIN  
    dideptcode := '280-';
    if v_showcancel = 'N' then  --------------- Normal Pending Exam -------------------
      --
      SqlStr := '           select ';
      SqlStr := SqlStr  || 'SLPNO, PATNO, PATFNAME, PATGNAME, SLPTYPE, ';
      SqlStr := SqlStr  || 'DOCCODE, to_char(STNTDATE, ''dd/mm/yyyy''), PKGCODE, ITMCODE, STNDESC, ';
      SqlStr := SqlStr  || ''''' as SELECTED, EXMTIME, ERMCODE, STNOAMT, STNBAMT, ';
      SqlStr := SqlStr  || 'STNDISC, STNNAMT, KEY, STNID, ONAMT, ';
      SqlStr := SqlStr  || 'OBAMT, USRID, GLCCODE, XAPID, XAPDATE, ';
      SqlStr := SqlStr  || 'REPORTED, REMARK, XRGID ';
      SqlStr := SqlStr  || 'from ( ';
      SqlStr := SqlStr  || '    select to_char(tx.DIXRef) || ''X'' || to_char(a.XapID) as Key, decode(s.SlpType,''D'',''DC'',s.SlpType) as SlpType, s.DocCode, s.PatNo, decode ';
      SqlStr := SqlStr  || '          (s.PatNo,null,s.SlpFName,p.PatFName) as PatFName, decode(s.PatNo,null,s.SlpGName,p.PatGName) as PatGName, s.SlpNo, tx.DIXREF as stnID, min(tx.StnTDate) as StnTDate, tx.PkgCode, tx.ItmCode, tx.StnDesc, ';
      SqlStr := SqlStr  || '          to_char(sum(tx2.StnOAmt)) as StnOAmt, to_char(sum(tx2.StnBAmt)) as StnBAmt, to_char(sum(decode(tx2.StnSts,''N'',tx2.StnDisc,0))) as StnDisc, to_char(sum ';
      SqlStr := SqlStr  || '          (tx2.StnNAmt)) as StnNAmt, to_char(sum(tx2.StnNAmt)) as ONAmt, to_char(sum(tx2.StnBAmt)) as OBAmt, tx.UsrID, tx.GlcCode, nvl(e.ExmTime,0) as ExmTime, ';
      SqlStr := SqlStr  || '          a.XapID, to_char(a.XapDate,''DD/MM/YYYY HH24:MI'') as XapDate, a.ErmCode, 0 as Selected, 0 as Reported, '''' as Remark, Null As XrgID ';
      SqlStr := SqlStr  || '    from ';
      SqlStr := SqlStr  || '        SlipTx tx, Slip s, Patient p, Exam e, Xapp a, SlipTx tx2, item i, excat x ';
      SqlStr := SqlStr  || '    where ';
      SqlStr := SqlStr  || '        s.SlpNo = tx.SlpNo and s.PatNo = p.PatNo (+) and tx.itmCode = e.ExmCode (+) and tx.DIXRef = a.StnID (+) and tx.DIXRef = tx2.DIXRef and tx.DIXRef>=0 and ';
      SqlStr := SqlStr  || '        tx.DscCode = x.eccCode(+) and tx.itmCode = i.itmCode and i.dptCode in (''' || dideptcode || ''') and tx.StnSts = ''N'' and tx.STNDIFLAG = -1 ';        
      if v_datefrom is not null then
        SqlStr := SqlStr  || '      and tx.stnCDate >= to_date(''' || v_datefrom || ' 000001'', ''DD-MM-YYYY hh24miss'') and tx.stnCDate <= to_date(''' || v_dateto || ' 235959'', ''DD-MM-YYYY hh24miss'') ';
        --                          and tx.stnCDate >= to_date('23-10-2017 000001', 'DD-MM-YYYY hh24miss') and tx.stnCDate <= to_date('24-10-2017 235959', 'DD-MM-YYYY hh24miss')     
      end if;
      if v_slpno is not null then
        SqlStr := SqlStr  || '      and s.slpNo = ''' || v_slpno || '''';
      end if;
      if v_dsccode is not null then
        SqlStr := SqlStr  || '      and tx.DscCode = ''' || v_dsccode || '''';
      end if;
      if v_patno is not null then
        SqlStr := SqlStr  || '      and s.PatNo = ''' || v_patno || '''';
      end if;
      if v_patfname is not null then
        SqlStr := SqlStr  || '      and s.SlpFName = ''' || v_patfname || '''';
      end if;
      if v_patgname is not null then
        SqlStr := SqlStr  || '      and s.SlpGName  = ''' || v_patgname || '''';
      end if;   
      SqlStr := SqlStr  || '    Group By tx.StnID, s.SlpType,s.DocCode,s.PatNo,s.SlpFName,s.SlpGName, p.PatFName,p.PatGName,s.SlpNo, tx.DIXRef, tx.PkgCode, tx.ItmCode, tx.StnDesc, tx.UsrID, tx.GlcCode, ExmTime , a.XapID, a.XapDate, a.ErmCode ';        
      SqlStr := SqlStr  || '    union ';        
      SqlStr := SqlStr  || '    select  to_char(tx.DIXRef) || ''X'' || to_char(a.XapID) as Key, decode(s.SlpType,''D'',''DC'',s.SlpType) as SlpType, s.DocCode, s.PatNo, decode ';        
      SqlStr := SqlStr  || '           (s.PatNo,null,s.SlpFName,p.PatFName) as PatFName, decode(s.PatNo,null,s.SlpGName,p.PatGName) as PatGName, s.SlpNo, tx.DIXREF as stnID, min(tx.StnTDate) as StnTDate, tx.PkgCode, tx.ItmCode, tx.StnDesc, ';        
      SqlStr := SqlStr  || '           to_char(sum(tx2.StnOAmt)) as StnOAmt, to_char(sum(tx2.StnBAmt)) as StnBAmt, to_char(sum(decode(tx2.StnSts,''N'',tx2.StnDisc,0))) as StnDisc, to_char ';
      SqlStr := SqlStr  || '          (sum(tx2.StnNAmt)) as StnNAmt, to_char(sum(tx2.StnNAmt)) as ONAmt, to_char(sum(tx2.StnBAmt)) as OBAmt, tx.UsrID, tx.GlcCode, nvl(e.ExmTime,0) as ExmTime, ';        
      SqlStr := SqlStr  || '            a.XapID, to_char(a.XapDate,''DD/MM/YYYY HH24:MI'') as XapDate, a.ErmCode, 0 as Selected, 0 as Reported, '''' as Remark, Null As XrgID ';        
      SqlStr := SqlStr  || '    from ';        
      SqlStr := SqlStr  || '        SlipTx tx, Slip s, Patient p, Exam e, Xapp a, SlipTx tx2, item i, excat x ';        
      SqlStr := SqlStr  || '    Where ';
      SqlStr := SqlStr  || '        s.SlpNo = tx.SlpNo and s.PatNo = p.PatNo (+) and tx.itmCode = e.ExmCode (+) and tx.DIXRef = a.StnID (+) and tx.DIXRef = tx2.DIXRef and tx.DIXRef>=0 and ';        
      SqlStr := SqlStr  || '        tx.DscCode = x.eccCode(+) and tx.itmCode = i.itmCode and i.dptCode in (''' || dideptcode || ''') and tx.StnSts = ''N'' and tx.STNDIFLAG = -1 ';        
      if v_datefrom is not null then
        SqlStr := SqlStr  || '      and tx.stnCDate >= to_date(''' || v_datefrom || ' 000001'', ''DD-MM-YYYY hh24miss'') and tx.stnCDate <= to_date(''' || v_dateto || ' 235959'', ''DD-MM-YYYY hh24miss'') ';
      end if;
      if v_slpno is not null then
        SqlStr := SqlStr  || '      and s.slpNo = ''' || v_slpno || '''';
      end if;
      if v_dsccode is not null then
        SqlStr := SqlStr  || '      and tx.DscCode = ''' || v_dsccode || '''';
      end if;
      if v_patno is not null then
        SqlStr := SqlStr  || '      and s.PatNo = ''' || v_patno || '''';
      end if;
      if v_patfname is not null and v_patgname is null then
        SqlStr := SqlStr  || ' and s.PatNo in (select PatNo  from Patient  where patFName = ''' || v_patfname || ''') ' ;
      end if;
      if v_patfname is null and v_patgname is not null then
        SqlStr := SqlStr  || ' and s.PatNo in (select PatNo  from Patient  where patGName = ''' || v_patGname || ''') ' ;
      end if;
      if v_patfname is not null and v_patgname is not null then
        SqlStr := SqlStr  || ' and s.PatNo in (select PatNo  from Patient  where patGName = ''' || v_patGname || ''' and patGName = ''' || v_patGname || ''') ' ;
      end if;   
      SqlStr := SqlStr  || '  Group By tx.StnID, s.SlpType,s.DocCode,s.PatNo,s.SlpFName,s.SlpGName, p.PatFName,p.PatGName,s.SlpNo, tx.DIXRef, tx.PkgCode, tx.ItmCode, tx.StnDesc, tx.UsrID, tx.GlcCode, ExmTime , a.XapID, a.XapDate, a.ErmCode ';
      SqlStr := SqlStr  || '  union ';
      SqlStr := SqlStr  || '  select ''X'' || to_char(a.XapID) as Key, '''' as SlpType, '''' as DocCode, a.patno, decode(p.patNo,null,o.orpFName,p.patFName) as PatFName, decode';
      SqlStr := SqlStr  || '  (p.patNo,null,o.orpGName,p.patGName) as PatGName, a.SlpNo, a.StnID, a.xapRDate as stnTDate, a.PkgCode as PkgCode, a.ExmCode as ItmCode, i.ItmName ||'' '' || ';
      SqlStr := SqlStr  || '   i.itmcname as StnDesc, '''' as StnOAmt, '''' as StnBAmt, '''' as StnDisc, '''' as StnNAmt, '''' as ONAmt, '''' as OBAmt, a.UsrID_R as UsrID, '''' as GlcCode, nvl';
      SqlStr := SqlStr  || '  (e.ExmTime, 0) as ExmTime, a.XapID, to_char(a.XapDate,''DD/MM/YYYY HH24:MI'') as XapDate, a.ErmCode, 0 as Selected , 0 as reported ,'''' as Remark, Null as XrgID ';
      SqlStr := SqlStr  || '  From ';
      SqlStr := SqlStr  || '      Xapp a, Item i, Exam e, patient p, outRefPat o  ';
      SqlStr := SqlStr  || '  Where a.ExmCode = i.ItmCode and a.StnID is Null and SlpNo is Null and a.ExmCode = e.ExmCode (+) and a.patno = p.patNo (+) and a.patno = o.orpNo (+) and a.patno is not null  and a.xapSts in (''A'',''P'') ';
      if v_datefrom is not null then
        SqlStr := SqlStr  || '      and a.XapRDate >= to_date(''' || v_datefrom || ' 000001'', ''DD-MM-YYYY hh24miss'') and a.XapRDate <= to_date(''' || v_dateto || ' 235959'', ''DD-MM-YYYY hh24miss'') ';
      end if;
      if v_slpno is not null then
        SqlStr := SqlStr  || '      and a.slpNo = ''' || v_slpno || '''';
      end if;
      if v_patno is not null then
        SqlStr := SqlStr  || '      and a.PatNo = ''' || v_patno || '''';
      end if;
      if v_patfname is not null then
        SqlStr := SqlStr  || '      and (p.patFName = ''' || v_patfname || ''' or o.orpFName = ''' || v_patfname || ''') ';
      end if;
      if v_patgname is not null then
        SqlStr := SqlStr  || '      and (p.patGName = ''' || v_patgname || ''' or o.orpGName = ''' || v_patgname || ''') ';
      end if;   
      SqlStr := SqlStr  || '  union ';
      SqlStr := SqlStr  || '  select ''X'' || to_char(a.XapID) as Key, '''' as SlpType, '''' as DocCode, a.patno, o.orpFName as PatFName, o.orpGName as PatGName, a.SlpNo, a.StnID, a.xapRDate as ';
      SqlStr := SqlStr  || '  stnTDate, a.PkgCode as PkgCode, a.ExmCode as ItmCode, i.ItmName||'' '' ||i.itmcname as StnDesc, '''' as StnOAmt, '''' as StnBAmt, '''' as StnDisc, '''' as StnNAmt, '''' ';    
      SqlStr := SqlStr  || '  as ONAmt, '''' as OBAmt, a.UsrID_R as UsrID, '''' as GlcCode, nvl(e.ExmTime, 0) as ExmTime, a.XapID, to_char(a.XapDate,''DD/MM/YYYY HH24:MI'') as XapDate, a.ErmCode, 0 as Selected , 0 as reported ,'''' as Remark, Null as XrgID ';
      SqlStr := SqlStr  || '  From ';
      SqlStr := SqlStr  || '      Xapp a, Item i, Exam e, OUTREFPATOTHER o ';
      SqlStr := SqlStr  || '  Where a.ExmCode = i.ItmCode and a.StnID is Null and a.patno is null  and SlpNo is Null and a.ExmCode = e.ExmCode (+)  and A.xapid = o.xappid  and a.xapSts in (''A'',''P'') ';
      if v_datefrom is not null then
        SqlStr := SqlStr  || '      and a.XapRDate >= to_date(''' || v_datefrom || ' 000001'', ''DD-MM-YYYY hh24miss'') and a.XapRDate <= to_date(''' || v_dateto || ' 235959'', ''DD-MM-YYYY hh24miss'') ';
      end if;
      if v_slpno is not null then
        SqlStr := SqlStr  || '      and a.slpNo = ''' || v_slpno || '''';
      end if;
      if v_patno is not null then
        SqlStr := SqlStr  || '      and a.PatNo = ''' || v_patno || '''';
      end if;
      if v_patfname is not null then
        SqlStr := SqlStr  || '      and (o.orpFName = ''' || v_patfname || ''')';
      end if;
      if v_patgname is not null then
        SqlStr := SqlStr  || '      and (o.orpGName = ''' || v_patgname || ''')';
      end if;
            if v_datefrom is not null then
        SqlStr := SqlStr  || '      and a.XapRDate >= to_date(''' || v_datefrom || ' 000001'', ''DD-MM-YYYY hh24miss'') and a.XapRDate <= to_date(''' || v_dateto || ' 235959'', ''DD-MM-YYYY hh24miss'') ';
      end if;
      if v_slpno is not null then
        SqlStr := SqlStr  || '      and a.slpNo = ''' || v_slpno || '''';
      end if;
      if v_patno is not null then
        SqlStr := SqlStr  || '      and a.PatNo = ''' || v_patno || '''';
      end if;
      if v_patfname is not null then
        SqlStr := SqlStr  || '      and (o.orpFName = ''' || v_patfname || ''')';
      end if;
      if v_patgname is not null then
        SqlStr := SqlStr  || '      and (o.orpGName = ''' || v_patgname || ''')';
      end if;

      SqlStr := SqlStr  || ') ';    
      SqlStr := SqlStr  || ' order by PatNo, slpNo desc';    
      
    else --------------------- Show Cancel ------------------
      SqlStr := '           select ';
      SqlStr := SqlStr  || 'SLPNO, PATNO, PATFNAME, PATGNAME, SLPTYPE, ';
      SqlStr := SqlStr  || 'DOCCODE, to_char(STNTDATE, ''dd/mm/yyyy''), PKGCODE, ITMCODE, STNDESC, ';
      SqlStr := SqlStr  || ''''' as SELECTED, EXMTIME, ERMCODE, STNOAMT, STNBAMT, ';
      SqlStr := SqlStr  || 'STNDISC, STNNAMT, KEY, STNID, ONAMT, ';
      SqlStr := SqlStr  || 'OBAMT, USRID, GLCCODE, XAPID, XAPDATE, ';
      SqlStr := SqlStr  || 'REPORTED, REMARK, XRGID ';
      SqlStr := SqlStr  || 'from ( ';
      SqlStr := SqlStr  || '    select    ';
      SqlStr := SqlStr  || '            to_char(tx.DIXRef) || ''X'' || to_char(a.XapID) as Key, decode(s.SlpType,''D'',''DC'',s.SlpType) as SlpType, s.DocCode, ';
      SqlStr := SqlStr  || '            s.PatNo, decode(s.PatNo,null,s.SlpFName,p.PatFName) as PatFName, decode(s.PatNo,null,s.SlpGName,p.PatGName) as PatGName, ';      
      SqlStr := SqlStr  || '            s.SlpNo, tx.DIXREF as stnID, min(tx.StnTDate) as StnTDate, tx.PkgCode, tx.ItmCode, tx.StnDesc,';      
      SqlStr := SqlStr  || '            to_char(sum(tx2.StnOAmt)) as StnOAmt, to_char(sum(tx2.StnBAmt)) as StnBAmt, to_char(sum(decode(tx2.StnSts,''N'',tx2.StnDisc,0))) as StnDisc, ';      
      SqlStr := SqlStr  || '            to_char(sum(tx2.StnNAmt)) as StnNAmt, to_char(sum(tx2.StnNAmt)) as ONAmt, to_char(sum(tx2.StnBAmt)) as OBAmt, tx.UsrID, ';      
      SqlStr := SqlStr  || '            tx.GlcCode, nvl(e.ExmTime,0) as ExmTime, a.XapID, to_char(a.XapDate,''DD/MM/YYYY HH24:MI'') as XapDate, a.ErmCode, 0 as Selected, ';
      SqlStr := SqlStr  || '            0 as Reported, '''' as Remark, Null As XrgID ';
      SqlStr := SqlStr  || '    from ';      
      SqlStr := SqlStr  || '       SlipTx tx, Slip s, Patient p, Exam e, Xapp a, SlipTx tx2, item i, excat x ';      
      SqlStr := SqlStr  || '    Where ';      
      SqlStr := SqlStr  || '        s.SlpNo = tx.SlpNo and s.PatNo = p.PatNo (+) and tx.itmCode = e.ExmCode (+) and tx.DIXRef = a.StnID (+) ';      
      SqlStr := SqlStr  || '        and tx.DIXRef = tx2.DIXRef and tx.DIXRef>=0 and tx.DscCode = x.eccCode(+) and tx.itmCode = i.itmCode ';      
      SqlStr := SqlStr  || '        and i.dptCode in (''280-'') and tx.StnSts = ''C'' and tx.STNDIFLAG = -1 ';
      if v_datefrom is not null then
          SqlStr := SqlStr  || '      and tx.stnCDate >= to_date(''' || v_datefrom || ' 000001'', ''DD-MM-YYYY hh24miss'') and tx.stnCDate <= to_date(''' || v_dateto || ' 235959'', ''DD-MM-YYYY hh24miss'') ';
      end if;
      if v_slpno is not null then
        SqlStr := SqlStr  || '      and s.slpNo = ''' || v_slpno || '''';
      end if;
      if v_dsccode is not null then
        SqlStr := SqlStr  || '      and tx.DscCode = ''' || v_dsccode || '''';
      end if;
      if v_patno is not null then
        SqlStr := SqlStr  || '      and s.PatNo = ''' || v_patno || '''';
      end if;
      if v_patfname is not null then
        SqlStr := SqlStr  || '      and s.SlpFName = ''' || v_patfname || '''';
      end if;
      if v_patgname is not null then
        SqlStr := SqlStr  || '      and s.SlpGName  = ''' || v_patgname || '''';
      end if;   
      SqlStr := SqlStr  || '    Group By tx.StnID, s.SlpType,s.DocCode,s.PatNo,s.SlpFName,s.SlpGName, p.PatFName,p.PatGName,s.SlpNo, tx.DIXRef, tx.PkgCode, tx.ItmCode, tx.StnDesc, tx.UsrID, tx.GlcCode, ExmTime , a.XapID, a.XapDate, a.ErmCode ';        
      SqlStr := SqlStr  || '    union ';      
      SqlStr := SqlStr  || '    select ';      
      SqlStr := SqlStr  || '        ''X'' || to_char(a.XapID) as Key, '''' as SlpType, '''' as DocCode, a.patno, decode(p.patNo,null,o.orpFName,p.patFName) as PatFName, ';
      SqlStr := SqlStr  || '        decode(p.patNo,null,o.orpGName,p.patGName) as PatGName, a.SlpNo, a.StnID, a.xapRDate as stnTDate, a.PkgCode as PkgCode, ';      
      SqlStr := SqlStr  || '        a.ExmCode as ItmCode, i.ItmName||'' '' ||i.itmcname as StnDesc, '''' as StnOAmt, '''' as StnBAmt, '''' as StnDisc, '''' as StnNAmt, ';
      SqlStr := SqlStr  || '        '''' as ONAmt, '''' as OBAmt, a.UsrID_R as UsrID, '''' as GlcCode, nvl(e.ExmTime, 0) as ExmTime, a.XapID, ';      
      SqlStr := SqlStr  || '        to_char(a.XapDate,''DD/MM/YYYY HH24:MI'') as XapDate, a.ErmCode, 0 as Selected , 0 as reported ,'''' as Remark, Null as XrgID ';      
      SqlStr := SqlStr  || '    From Xapp a, Item i, Exam e, patient p, outRefPat o ';      
      SqlStr := SqlStr  || '    Where a.ExmCode = i.ItmCode and a.StnID is Null and SlpNo is Null and a.ExmCode = e.ExmCode (+) and a.patno = p.patNo (+) ';
      SqlStr := SqlStr  || '      and a.patno = o.orpNo (+) and a.patno is not null  and a.xapSts = ''C'' ';      
      if v_datefrom is not null then
        SqlStr := SqlStr  || '      and a.XapRDate >= to_date(''' || v_datefrom || ' 000001'', ''DD-MM-YYYY hh24miss'') and a.XapRDate <= to_date(''' || v_dateto || ' 235959'', ''DD-MM-YYYY hh24miss'') ';
      end if;
      if v_slpno is not null then
        SqlStr := SqlStr  || '      and a.slpNo = ''' || v_slpno || '''';
      end if;
      if v_patno is not null then
        SqlStr := SqlStr  || '      and a.PatNo = ''' || v_patno || '''';
      end if;
      if v_patfname is not null then
        SqlStr := SqlStr  || '      and (p.patFName = ''' || v_patfname || ''' or o.orpFName = ''' || v_patfname || ''') ';
      end if;
      if v_patgname is not null then
        SqlStr := SqlStr  || '      and (p.patGName = ''' || v_patgname || ''' or o.orpGName = ''' || v_patgname || ''') ';
      end if;  
      SqlStr := SqlStr  || '    union';      
      SqlStr := SqlStr  || '    select ''X'' || to_char(a.XapID) as Key, '''' as SlpType, '''' as DocCode, a.patno, o.orpFName as PatFName, o.orpGName as PatGName, ';      
      SqlStr := SqlStr  || '            a.SlpNo, a.StnID, a.xapRDate as stnTDate, a.PkgCode as PkgCode, a.ExmCode as ItmCode, i.ItmName||'' '' ||i.itmcname as StnDesc, ';
      SqlStr := SqlStr  || '           '''' as StnOAmt, '''' as StnBAmt, '''' as StnDisc, '''' as StnNAmt, '''' as ONAmt, '''' as OBAmt, a.UsrID_R as UsrID, '''' as GlcCode, ';
      SqlStr := SqlStr  || '           nvl(e.ExmTime, 0) as ExmTime, a.XapID, to_char(a.XapDate,''DD/MM/YYYY HH24:MI'') as XapDate, a.ErmCode, 0 as Selected , 0 as reported , ';      
      SqlStr := SqlStr  || '           '''' as Remark, Null as XrgID ';      
      SqlStr := SqlStr  || '    From Xapp a, Item i, Exam e, OUTREFPATOTHER o ';      
      SqlStr := SqlStr  || '    Where a.ExmCode = i.ItmCode and a.StnID is Null ';      
      SqlStr := SqlStr  || '          and a.patno is null  and SlpNo is Null and a.ExmCode = e.ExmCode (+)  and A.xapid = o.xappid  and a.xapSts = ''C'' ';      
      SqlStr := SqlStr  || '  ';      
      
      
      SqlStr := SqlStr  || '  ';      
      SqlStr := SqlStr  || ') ';    
      SqlStr := SqlStr  || ' order by PatNo, slpNo desc';    

      
    end if;    
    -- get pat count
    if v_mode = '1' then
      SqlStr := '    select count(1) from ( select patno, count(1) from ( ' || SqlStr || ' ) group by patno ) order by patno ';      
    end if;
  
    Dbms_Output.Put_Line(' SqlStr = ' || SqlStr);

	OPEN OUTCUR FOR SqlStr;
	RETURN OUTCUR;
END NHS_LIS_ECGPENDEXAM;