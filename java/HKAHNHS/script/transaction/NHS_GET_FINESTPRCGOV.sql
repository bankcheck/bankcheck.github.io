create or replace
Function "NHS_GET_FINESTPRCGOV"(
   v_proccode In Varchar2
)
	RETURN Types.CURSOR_type
AS
	outcur types.cursor_type;
BEGIN
  	Open Outcur For
		Select FCG.GOVDESC
		From Fin_Code Fc, Fin_Code_Gov Fcg 
		Where Fc.Govcode = Fcg.Govcode 
    AND FC.PROCCODE = v_proccode;
  RETURN OUTCUR;
END NHS_GET_FINESTPRCGOV;
/