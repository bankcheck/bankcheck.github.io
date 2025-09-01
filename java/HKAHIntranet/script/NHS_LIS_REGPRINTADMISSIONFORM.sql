create or replace
function "NHS_LIS_REGPRINTADMISSIONFORM"
(
    v_slpNo varchar2
)
return types.cursor_type
as
    outcur types.cursor_type;
begin
      open outcur for
 select
       upper(P.patno) as patno,
       upper(P.patfname) as patfname,
       upper(P.patgname) as patgname,
       upper(P.patcname) as patcname,
       to_char(P.patbdate,'dd/mm/yyyy'),
       upper(P.patsex) as patsex,
       upper(P.patidno) as patidno,
       upper(P.Racdesc) as racdesc,
       upper(P.Edulevel) as edulevel,
       upper(C.Coudesc) as coudesc,
       upper(P.pathtel) as pathtel,
       upper(P.patotel) as patotel,
       upper(P.patmsts) as patmsts,
       upper(P.PATPAGER) as patpager,
       upper(M.Mothdesc) as mothdesc,
       upper(P.patadd1) as patadd1,
       upper(P.patadd2) as patadd2,
       upper(P.patadd3) as patadd3,
       upper(L.Locname) as locname,
       upper(P.patkname) as patkname,
       upper(P.patkrela) as patkrela,
       upper(P.patkhtel) as patkhtel,
       upper(P.PATKADD) as patkadd,
       upper(A.arcname) as arcname,
       upper(S.SLPPLYNO) as slpplyno,
       upper(S.SlpType) as slptype ,
       upper(B.RomCODE) as romcode,
       upper(B.BedCode) as bedcode,
       upper(S.DocCode) as doccode,
       upper(D.DocFName) as docfname,
       upper(D.DocGname) as docgname,
       to_char(R.RegDate,'dd/mm/yyyy HH24:MI:SS') as RegDate,
       upper(AC.Acmname) as acmname,
       to_char(I.INPDDATE,'dd/mm/yyyy HH24:MI:SS') as INPDDATE,
       upper(O.WrdCode) as wrdcode,
       upper(P.RELIGIOUS) as religious,
       upper(P.OCCUPATION) as occupation,
       upper(rel.reldesc) as reldesc,
       upper(p.patkotel) as patkotel,
       upper(p.patkmtel) as patkmtel,
       upper(p.patkptel) as patkptel,
       upper(s.SlpVchNo) as slpvchno,
       upper(p.PatEmail) as PatEmail,
       upper(p.PatKEmail) as PatKEmail,
       upper(S.Usrid) AS usrid
    from
       inpat@IWEB I,
       patient@IWEB P,
       motherlang@IWEB M,
       country@IWEB C,
       slip@IWEB S,
       arcode@IWEB A,
       acm@IWEB AC,
       location@IWEB L,
       bed@IWEB B,
       doctor@IWEB D,
       reg@IWEB R,
       Room@IWEB O,
       religious@IWEB rel
    where P.Patno=S.Patno
        and S.Arccode=A.Arccode(+)
        and S.Slpno=R.Slpno
        and R.Inpid=I.Inpid
        and I.Bedcode=B.Bedcode
        and B.Romcode=O.Romcode
        and P.Loccode=L.Loccode
        and P.Coucode=C.Coucode(+)
        and P.Mothcode=M.Mothcode(+)
        and S.Doccode=D.Doccode
        and I.Acmcode=AC.Acmcode
        and S.SLPTYPE= 'I'
        and S.slpno= v_slpNo
        and p.religious=rel.relcode (+);
      return outcur;
end NHS_LIS_REGPRINTADMISSIONFORM;