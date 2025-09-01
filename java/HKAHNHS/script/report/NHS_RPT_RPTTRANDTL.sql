CREATE OR REPLACE FUNCTION NHS_RPT_RPTTRANDTL (
  v_SteCode VARCHAR2,
  v_SDate VARCHAR2,
  v_EDate VARCHAR2,
  v_dummy varchar2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
Select
       D.Doccode || ' ' || D.Docfname || ' ' || D.Docgname as Doctor,
       I.Itmcode || ' ' || Itmname as Item, S.Patno,
       decode(S.Patno, Null, S.Slpfname || ' ' || S.Slpgname, P.Patfname || ' ' || P.Patgname) as Name,
       stnnamt,
       to_char(stncdate, 'dd/mm/yyyy hh24:mi:ss') as stncdate,
       Pt.Pcydesc,
       I.Itmgrp
from
     Patient P,
     Slip S,
     Sliptx St,
     Item I,
     Doctor D,
     Patcat Pt
where
     P.Patno (+) = S.Patno
     and S.Slpno = St.Slpno
     and S.Pcyid = Pt.Pcyid (+)
     and St.Itmcode = I.Itmcode
     and St.Doccode = D.Doccode
     and stncdate >= to_date(v_SDate, 'dd/mm/yyyy')
     and stncdate < to_date(v_EDate, 'dd/mm/yyyy') + 1
     and stnsts <> 'A'
     and S.stecode= v_SteCode
     and St.Doccode is not null;

  RETURN OUTCUR;
END NHS_RPT_RPTTRANDTL;
/
