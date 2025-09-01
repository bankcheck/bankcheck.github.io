CREATE OR REPLACE FUNCTION "NHS_UTL_CONPCECHANGE" (
	i_SlpNo         IN VARCHAR2,
	i_PatientType   IN VARCHAR2,
	i_OldAcmcode    IN VARCHAR2,
	i_NewCPSID      IN VARCHAR2,
	i_NewAcmcode    IN VARCHAR2,
	i_TransactionID IN VARCHAR2,
	i_ChangeACM     IN BOOLEAN
)
	RETURN TYPES.CURSOR_TYPE
AS
	v_Outcur TYPES.CURSOR_TYPE;
BEGIN
	v_Outcur := NHS_GET_CONPCECHANGE(i_SlpNo, i_TransactionID);

	RETURN NHS_UTL_FILLNEWCPS(i_SlpNo, i_PatientType, i_OldAcmcode, v_Outcur, i_NewCPSID, i_NewAcmcode, i_ChangeACM);

EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN NULL;
END NHS_UTL_CONPCECHANGE;
/
