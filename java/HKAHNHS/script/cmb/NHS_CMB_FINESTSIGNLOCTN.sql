create or replace
FUNCTION      "NHS_CMB_FINESTSIGNLOCTN"
	RETURN Types.CURSOR_type
AS
	outcur types.cursor_type;
BEGIN
  
	OPEN outcur FOR
		Select Pid,Pdesc From 
   		(select 'C' as pid, 'At Clinic/ OPD'as pdesc FROM DUAL
		Union
		select 'A' as pid, 'At Admission Office' as pdesc FROM DUAL
		Union
		select 'W' as pid, 'At Ward/ OT' as pdesc FROM DUAL 
		Union
		Select 'B' As Pid, 'Blank' As Pdesc From Dual)
    order by 2; 
    
	RETURN outcur;
END NHS_CMB_FINESTSIGNLOCTN;
/