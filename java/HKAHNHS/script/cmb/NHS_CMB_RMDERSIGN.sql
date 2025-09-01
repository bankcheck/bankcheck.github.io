create or replace
FUNCTION                     "NHS_CMB_RMDERSIGN" (
	v_dept IN VARCHAR2
)
	RETURN Types.CURSOR_type
AS
	outcur types.cursor_type;
  v_spec varchar2(20);
BEGIN
  IF v_dept = 'DENTIST' then 
    v_spec := 'DEN';
  ELSE
    v_spec := null;
  END iF;
  
	OPEN outcur FOR
		Select Pid,Pdesc From 
   		(SELECT 'PBO' as dept,'PBO' as pid, 'Patient Business Department'as pdesc FROM DUAL
		Union
		SELECT 'PBO' as dept,'PBOPEG' as pid, 'Peggy Kan/Senior Out-patient Service Officer' as pdesc FROM DUAL
		Union
		SELECT 'PBO' as dept,'PBORIT' as pid, 'Rita Leung/Senior Out-patient Service Officer' as pdesc FROM DUAL
		Union
		SELECT 'PBO' as dept,'PBORUB' as pid, 'Ruby Wong/Senior In-patient Service Officer' as pdesc FROM DUAL
		UNION
		Select 'PBO' As Dept, 'PBOSAN' As Pid, 'Sandra Chow/Senior In-patient Service Officer' As Pdesc From Dual
		Union
		SELECT 'PBO' as dept,'PBOBEC' as pid, 'Becky Yau/Manager' as pdesc FROM DUAL
		Union
		SELECT 'PBO' as dept,'PBOISA' as pid, 'Isabelle Leung/Assistant Manager' as pdesc FROM DUAL)
    where (v_spec is null or dept= v_spec)
    Order by pdesc; 
	RETURN OUTCUR;
END NHS_CMB_RMDERSIGN;
/
