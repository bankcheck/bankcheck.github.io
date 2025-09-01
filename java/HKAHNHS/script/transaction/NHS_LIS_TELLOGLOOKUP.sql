CREATE OR REPLACE FUNCTION NHS_LIS_TELLOGLOOKUP
(
   v_memSLPNO in varchar2
)
return types.cursor_type
as
  outcur types.cursor_type;
begin
  open outcur for
  select S.SLPNO,
         P.PATNO,
         I.BEDCODE,
         A.AcmCode,
         R.DOCCODE,
         R.REGDATE,
         D.DOCFNAME || ' ' || D.DOCGNAME as DOCNAME,
         P.PATFNAME || ' ' || P.PATGNAME as PATNAME
    from SLIP S, INPAT I, ACM A, REG R, PATIENT P, DOCTOR D
   where S.SLPNO = v_memSLPNO
     and S.SLPNO = R.SLPNO
     and R.INPID = I.INPID
     and A.AcmCode = i.AcmCode
     and P.PATNO = S.PATNO
     and d.DocCode = R.DocCode
     and s.slptype = 'I'
     and s.slpsts = 'A';
     return outcur;
end NHS_LIS_TELLOGLOOKUP;
/
