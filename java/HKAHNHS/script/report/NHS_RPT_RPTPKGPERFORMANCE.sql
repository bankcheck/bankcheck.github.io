CREATE OR REPLACE FUNCTION NHS_RPT_RPTPKGPERFORMANCE(
  v_SteCode VARCHAR2,
  v_SDate VARCHAR2,
  v_EDate VARCHAR2,
  v_PkgCode VARCHAR2,
  v_DocCode VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
select
             ax.slpno, ax.pkgcode,ax.slptype,ax.Doccode,ax.PatNo, 'tc' as fieldtype, sum(st.stnnamt) as amount
             from (
             select distinct s.SlpNo , pp.PkgCode, s.SlpType, r.Doccode, s.PatNo
             From slip s, pkgtx pp,reg r
             Where
             s.SlpNo = pp.SlpNo
             AND NOT ( s.slptype IN ('I') )
             AND s.stecode= v_SteCode
             and s.regid= r.regid (+)
             AND (r.regdate>= to_date(v_SDate, 'dd-mm-yyyy')
             and r.regdate< to_date(v_EDate, 'dd-mm-yyyy') + 1  )
            and (r.doccode=v_DocCode  or v_DocCode is null) and (pp.pkgcode=v_PkgCode or v_PkgCode is null)
             order by s.SlpNo  ) ax, sliptx st
             Where
             ax.SlpNo = st.SlpNo
             AND st.stnsts IN ('N', 'A')
             And st.stntype IN ('C', 'D')
             Group By 'tc', ax.slptype, ax.pkgcode, ax.Doccode, ax.slpno, ax.patno
            union

select
             ax.slpno, ax.pkgcode,ax.slptype,ax.Doccode,ax.patno,'tc' as fieldtype, sum(st.stnnamt) as amount
             from (
             select distinct
              s.SlpNo , pp.PkgCode, s.SlpType, r.Doccode, s.PatNo
             From slip s, pkgtx pp, reg r, inpat i
             Where
             s.SlpNo = pp.SlpNo
             AND s.slptype IN ('I')
             AND s.stecode= v_SteCode
             and s.regid= r.regid
             AND r.inpid= i.inpid
             AND (i.inpddate > = to_date(v_SDate, 'dd-mm-yyyy')
             and i.inpddate< to_date(v_EDate, 'dd-mm-yyyy') + 1  )
            and (r.doccode=v_DocCode  or v_DocCode is null) and (pp.pkgcode=v_PkgCode or v_PkgCode is null)
             order by s.SlpNo ) ax, sliptx st
             Where
             ax.SlpNo = st.SlpNo
             AND st.stnsts IN ('N', 'A')
             And st.stntype IN ('C', 'D')
             Group By 'tc', ax.slptype, ax.pkgcode, ax.Doccode, ax.slpno, ax.patno
            union
select ax.slpno, ax.pkgcode,ax.slptype,ax.Doccode,ax.patno, 'dc' as fieldtype, sum(st.stnnamt) as amount
             from (
             select distinct
             s.SlpNo , pp.PkgCode, s.SlpType, r.Doccode, s.PatNo
             From
             slip s, pkgtx pp,reg r, inpat i
             Where
             s.SlpNo = pp.SlpNo
             AND s.slptype IN ('I')
             AND s.stecode= v_SteCode
             and s.regid= r.regid
             AND r.inpid= i.inpid
             AND (i.inpddate > = to_date(v_SDate, 'dd-mm-yyyy')
             and i.inpddate< to_date(v_EDate, 'dd-mm-yyyy') + 1  )
            and (r.doccode=v_DocCode  or v_DocCode is null) and (pp.pkgcode=v_PkgCode or v_PkgCode is null)
             order by s.SlpNo ) ax, sliptx st
             Where
             ax.SlpNo = ST.SlpNo
             AND st.stnsts IN ('N', 'A')
             And st.stntype IN ('C', 'D')
             AND ST.ITMTYPE ='D'
             Group By 'dc',ax.slptype, ax.pkgcode, ax.Doccode, ax.slpno, ax.patno
            union
select ax.slpno, ax.pkgcode,ax.slptype,ax.Doccode,ax.patno, 'dc' as fieldtype ,sum(st.stnnamt) as amount
             from ( select distinct s.SlpNo , pp.PkgCode, s.SlpType, r.Doccode, s.PatNo
             From
             slip s, pkgtx pp,reg r
             Where
             s.SlpNo = pp.SlpNo
             AND NOT ( s.slptype IN ('I') )
             AND s.stecode= v_SteCode
             AND s.regid= r.regid (+)
             AND (r.regdate>= to_date(v_SDate, 'dd-mm-yyyy')
             and r.regdate< to_date(v_EDate, 'dd-mm-yyyy') + 1  )
            and (r.doccode=v_DocCode  or v_DocCode is null) and (pp.pkgcode=v_PkgCode or v_PkgCode is null)
             order by s.SlpNo) ax, sliptx st
             Where
             ax.SlpNo = st.SlpNo
             AND st.stnsts IN ('N', 'A')
             And st.stntype IN ('C', 'D')
             And st.itmtype= 'D'
             Group By 'dc', ax.slptype, ax.pkgcode, ax.Doccode, ax.slpno, ax.patno
            union
select ax.slpno, ax.pkgcode,ax.slptype,ax.Doccode,ax.patno, 'pc' as fieldtype ,sum(st.stnnamt) as amount
             from (
             select distinct
             s.SlpNo , pp.PkgCode, s.SlpType, r.Doccode, s.PatNo
             From
             slip s, pkgtx pp,reg r,inpat i
             Where
             pp.SlpNo = s.SlpNo
             AND  s.slptype IN ('I')
             AND s.stecode= v_SteCode
             AND s.regid= r.regid
             AND r.inpid= i.inpid
             AND (i.inpddate>= to_date(v_SDate, 'dd-mm-yyyy')
             and i.inpddate< to_date(v_EDate, 'dd-mm-yyyy') + 1  )
            and (r.doccode=v_DocCode  or v_DocCode is null) and (pp.pkgcode=v_PkgCode or v_PkgCode is null)
             order by s.SlpNo  ) ax, sliptx st, package p
             Where
             ax.SlpNo = st.SlpNo
             AND st.stnsts IN ('N', 'A')
             And st.pkgcode is NOT NULL
             and st.itmtype <> 'D'
             and ax.pkgcode = p.pkgcode
             and ax.pkgcode = st.pkgcode
             Group By 'pc', ax.slptype, ax.pkgcode, ax.Doccode, ax.slpno, ax.patno
            union
select ax.slpno, ax.pkgcode,ax.slptype,ax.Doccode,ax.patno, 'pc' as fieldtype ,sum(st.stnnamt) as amount
             from (
             select distinct
             s.SlpNo , pp.PkgCode, s.SlpType, r.Doccode, s.PatNo
             From
             slip s, pkgtx pp,reg r
             Where
             pp.SlpNo = s.SlpNo
             AND NOT ( s.slptype IN ('I') )
             AND s.stecode= v_SteCode
             AND s.regid= r.regid (+)
             AND (r.regdate>= to_date(v_SDate, 'dd-mm-yyyy')
             and r.regdate< to_date(v_EDate, 'dd-mm-yyyy') + 1  )
            and (r.doccode=v_DocCode  or v_DocCode is null) and (pp.pkgcode=v_PkgCode or v_PkgCode is null)
             order by s.SlpNo) ax, sliptx st, package p
             Where
             ax.SlpNo = st.SlpNo
             AND st.stnsts IN ('N', 'A')
             And st.pkgcode is NOT NULL
             and st.itmtype <> 'D'
             and ax.pkgcode = p.pkgcode
             and ax.pkgcode = st.pkgcode
             Group By 'pc', ax.slptype, ax.pkgcode, ax.Doccode, ax.slpno, ax.patno
            union
select ax.slpno, ax.pkgcode,ax.slptype,ax.Doccode,ax.patno, 'pd' as fieldtype ,sum(st.stnnamt) as amount
             from (
             select distinct
             s.SlpNo , pp.PkgCode, s.SlpType, r.Doccode, s.PatNo
             From
             slip s, pkgtx pp,reg r
             Where
             pp.SlpNo = s.SlpNo
             AND NOT ( s.slptype IN ('I') )
             AND s.stecode= v_SteCode
             AND s.regid= r.regid (+)
             AND (r.regdate>= to_date(v_SDate, 'dd-mm-yyyy')
             and r.regdate< to_date(v_EDate, 'dd-mm-yyyy') + 1  )
            and (r.doccode=v_DocCode  or v_DocCode is null) and (pp.pkgcode=v_PkgCode or v_PkgCode is null)
              order by s.SlpNo) ax, sliptx st
             Where
             ax.SlpNo = st.SlpNo
             AND st.stnsts IN ('N', 'A')
             And st.stntype= 'C'
             And st.pkgcode is NOT NULL
             Group By
             'pd', ax.slptype, ax.pkgcode, ax.Doccode, ax.slpno, ax.patno
            union
select ax.slpno, ax.pkgcode,ax.slptype,ax.Doccode,ax.patno, 'pd' as fieldtype ,sum(st.stnnamt) as amount
             from ( select distinct s.SlpNo , pp.PkgCode, s.SlpType, r.Doccode, s.PatNo
             From
             slip s, pkgtx pp,reg r, inpat i
             Where
             pp.SlpNo = s.SlpNo
             AND  s.slptype IN ('I')
             AND s.stecode= v_SteCode
             AND s.regid= r.regid
             AND r.inpid= i.inpid
             AND (i.inpddate>= to_date(v_SDate, 'dd-mm-yyyy')
             and i.inpddate< to_date(v_EDate, 'dd-mm-yyyy') + 1  )
            and (r.doccode=v_DocCode  or v_DocCode is null) and (pp.pkgcode=v_PkgCode or v_PkgCode is null)
              order by s.SlpNo) ax, sliptx st
             Where
             ax.SlpNo = st.SlpNo
             AND st.stnsts IN ('N', 'A')
             And st.stntype= 'C'
             And st.pkgcode is NOT NULL
             Group By 'pd', ax.slptype, ax.pkgcode, ax.Doccode, ax.slpno, ax.patno
            union
select ax.slpno, ax.pkgcode,ax.slptype,ax.doccode,ax.patno, 'ai' as fieldtype ,sum(pp.PTNBAMT) as amount
             from (
             select distinct
             s.SlpNo , pp.PkgCode, s.SlpType, r.DocCode, s.PatNo
             From
             slip s, pkgtx pp,reg r
             Where
             pp.SlpNo = s.SlpNo
             AND NOT ( s.slptype IN ('I') )
             AND s.stecode= v_SteCode
             AND s.regid= r.regid (+)
             AND (r.regdate>= to_date(v_SDate, 'dd-mm-yyyy')
             and r.regdate< to_date(v_EDate, 'dd-mm-yyyy') + 1  )
            and (r.doccode =v_DocCode or v_DocCode is null)
            and  (pp.pkgcode=v_PkgCode or v_PkgCode is null )
              order by s.SlpNo) ax, pkgtx pp
             Where
             ax.SlpNo = pp.SlpNo
             and ax.pkgcode = pp.pkgcode
             and pp.ptnsts not in ('M','C','U')
             Group By 'ai', ax.slptype, ax.pkgcode, ax.doccode, ax.slpno, ax.patno
union
select ax.slpno, ax.pkgcode,ax.slptype,ax.doccode,ax.patno, 'ai' as fieldtype ,sum(pp.PTNBAMT) as amount
             from (
             select distinct
             s.SlpNo , pp.PkgCode, s.SlpType, r.DocCode, s.PatNo
             From
             slip s, pkgtx pp,reg r, inpat i
             Where
             pp.SlpNo = s.SlpNo
             AND  s.slptype IN ('I')
             AND s.stecode= v_SteCode
             AND s.regid= r.regid
             AND r.inpid= i.inpid
             AND (i.inpddate>= to_date(v_SDate, 'dd-mm-yyyy')
             and i.inpddate< to_date(v_EDate, 'dd-mm-yyyy') + 1  )
            and (r.doccode =v_DocCode or v_DocCode is null)
            and  (pp.pkgcode=v_PkgCode or v_PkgCode is null )
              order by s.SlpNo) ax, pkgtx pp
             Where
             ax.SlpNo = pp.SlpNo
             and ax.pkgcode = pp.pkgcode
             and pp.ptnsts not in ('M','C','U')
             Group By 'ai', ax.slptype, ax.pkgcode, ax.doccode, ax.slpno, ax.patno
             order by slptype, pkgcode, doccode, slpno, patno;
  RETURN OUTCUR;
END NHS_RPT_RPTPKGPERFORMANCE;
/
