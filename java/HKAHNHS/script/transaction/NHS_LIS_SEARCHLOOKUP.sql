CREATE OR REPLACE FUNCTION NHS_LIS_SEARCHLOOKUP
(
   v_memSLPNO in varchar2
)
return types.cursor_type
as
  outcur types.cursor_type;
begin
  open outcur for
  select S.SLPNO, S.DOCCODE, null as BEDCODE, null as ACMCODE
  from SLIP S
  where S.SLPNO = v_memSLPNO and s.slpsts = 'A';
  return outcur;
end NHS_LIS_SEARCHLOOKUP;
/
