create or replace
FUNCTION "NHS_GET_DOCFEE_CHKPT"                                                                          
    RETURN types.CURSOR_TYPE                                                    
AS
    Outcur Types.Cursor_Type;
Begin
	Open Outcur For
		SELECT DATEEND, SPHID, STATUS, NEXTNO, PCYID, REPORT, USRID, MACHINE 
		FROM df_chkpt;
 	Return Outcur;                                                                                                                                                
END NHS_GET_DOCFEE_CHKPT;
/
