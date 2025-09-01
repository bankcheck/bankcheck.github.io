create or replace
FUNCTION "NHS_RPT_CMPALLOCLIST"(V_SITECODE IN varchar2,
    V_ARPID IN varchar2,
	V_ARPRECNO IN varchar2
)
return types.cursor_type as
  outcur types.cursor_type;
  strsql varchar2(20000);
  strarpid varchar2(100);
  STRARPRECNO varchar2(100);
begin

  IF V_ARPID IS NOT NULL THEN
    STRARPID:= ' AND a.arpid ='''||V_ARPID||''' ';
  ELSE
    STRARPID:='';
  END IF;

  IF V_ARPRECNO IS NOT NULL THEN
    STRARPRECNO:= ' AND b.arprecno ='''||V_ARPRECNO||''' ';
  ELSE
    STRARPRECNO:='';
  END IF;

   /*+ ORDERED USE(b, a, c, ar) */
   STRSQL:='
   Select
     a.slpno, a.patno, a.arccode, to_char(b.ARPTDATE, ''dd/MM/yyyy'') as ChDate,
     Sum(a.AtxAmt) as Allocate,
     b.ArpOAmt as ChAmt, nvl(b.ArpRecNo,a.arpid) as ArpRecNo,
     c.AtxAmt as BillAmt, to_char(c.AtxTDate, ''dd MON yyyy'') as BillDate,
     p.PatFName || s.slpfname || '' '' || p.PatGName || s.slpgname  as PatName, Arcname, nvl(s.slptype,''Z'') as slptype
   from ArTx a, ArpTx b, ArTx c, patient p, arcode ar, slip s
   Where a.ArpID = b.ArpID
     and a.AtxSts <> ''R''
     and a.AtxTType = ''C''
     and a.AtxSts = ''N''
     and c.AtxID = a.AtxRefID
     and c.ArpID is null
     and c.AtxTType = ''C''
     and c.AtxSts = ''N''
     and c.ArcCode = a.arccode
     and a.arccode = ar.arccode
       ' ||STRARPID || STRARPRECNO || '
     and a.patno = p.patno (+)
     and a.slpno = s.slpno (+)
   Group By
     a.slpno, a.patno, a.arccode, b.ARPTDATE, b.ArpOAmt, nvl(b.ArpRecNo,a.arpid),
     c.atxamt, c.atxtdate, p.patfname || s.slpfname || '' '' || p.patgname || s.slpgname, arcname, s.slptype
   Order By
     CASE WHEN slptype = ''Z'' THEN ''1''
              WHEN slptype = ''I'' THEN ''2''
              WHEN slptype = ''O'' THEN ''3''
              WHEN slptype = ''D'' THEN ''4''
              ELSE ''5'' END ASC, a.patno
    ';
  OPEN OUTCUR FOR STRSQL;
  RETURN OUTCUR;
END NHS_RPT_CMPALLOCLIST;
/