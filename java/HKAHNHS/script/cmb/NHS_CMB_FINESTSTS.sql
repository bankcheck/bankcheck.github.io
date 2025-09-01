create or replace
Function "NHS_CMB_FINESTSTS" (
	i_isFrmA    IN VARCHAR2
)
	RETURN Types.CURSOR_type
AS
	outcur types.cursor_type;
	sqlStr VARCHAR2(5000);
	v_CheckDate VARCHAR2(21);
BEGIN
	sqlStr := '
		Select Pid,Pdesc From 
   		(select ''C'' as pid, ''At Clinic/ OPD''as pdesc FROM DUAL
		Union
		select ''A'' as pid, ''At Admission Office'' as pdesc FROM DUAL ';

	If I_Isfrma = 'Y' Then
		Sqlstr := Sqlstr || ' Union Select ''B'' As Pid, ''Blank'' As Pdesc From Dual) ';
  Else
    Sqlstr := Sqlstr || ' )  ';
	End If;
      Sqlstr := Sqlstr || ' order by 2 ';
	OPEN OUTCUR FOR sqlStr;
	RETURN OUTCUR;
END NHS_CMB_FINESTSTS;
/
