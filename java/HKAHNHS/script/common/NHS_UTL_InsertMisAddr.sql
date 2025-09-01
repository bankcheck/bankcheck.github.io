-- InsertMisAddr
create or replace FUNCTION "NHS_UTL_INSERTMISADDR"(
i_Tabname       IN VARCHAR2,
i_TransactionID IN VARCHAR2,
i_Payee         IN VARCHAR2,
i_PatAddr1      IN VARCHAR2,
i_PatAddr2      IN VARCHAR2,
i_PatAddr3      IN VARCHAR2,
i_Country       IN VARCHAR2,
i_Reason        IN VARCHAR2
)
	RETURN NUMBER
AS
	o_Marid    NUMBER;
BEGIN
	-- get next CardTx id
	--SELECT SEQ_Misaddref.NEXTVAL INTO o_Marid FROM DUAL;

	INSERT INTO Misaddref (Marid, Tabname, Tabid, Marpayee, Maradd1, Maradd2, Maradd3, Country, Marreason)
	VALUES (SEQ_Misaddref.NEXTVAL, i_Tabname, i_TransactionID, i_Payee, i_PatAddr1, i_PatAddr2, i_PatAddr3, i_Country, i_Reason);

	RETURN o_Marid;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -1;
END NHS_UTL_INSERTMISADDR;
/
