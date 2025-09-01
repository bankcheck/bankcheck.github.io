CREATE OR REPLACE FUNCTION "NHS_RPT_REGSHEET"
(
 v_regid   IN varchar2
 )
  RETURN Types.cursor_type
AS
  Outcur Types.Cursor_Type;
   	Sqlstr Varchar2(15000);
    V_Regid2 Varchar2(15000):= Replace(V_Regid,'ca',',');


Begin
   SQLSTR := 'SELECT REG.REGID,
            REG.PATNO,
            REG.REGTYPE,
            Pat.Patfname||'' ''||Pat.Patgname As Patname,
            PAT.PATCNAME,
            to_char(Inp.Inpddate,''dd/mm/yyyy'') as inpddateasdate,
            to_char(Inp.Inpddate,''ddmmyyyy'') as inpddateastext,
            to_char(REG.REGDATE,''dd/mm/yyyy'') as regdateasdate,
            to_char(REG.REGDATE,''ddmmyyyy'') as regdateastext          
            FROM  Reg reg, Patient pat, Inpat inp
          WHERE REG.PATNO = PAT.PATNO
          And Reg.Inpid   = Inp.Inpid(+)
          and reg.regid  IN ('||v_regid2||')
          Order By Regdate Desc';
   Open Outcur For Sqlstr;
   Return Outcur;
END NHS_RPT_REGSHEET;
/
