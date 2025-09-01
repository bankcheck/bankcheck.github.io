CREATE OR REPLACE FUNCTION "NHS_UTL_GETCARDNEWREF"(
	i_SlipNo IN VARCHAR2
)
	RETURN VARCHAR2
AS
	o_GetCardNewRef VARCHAR2(20);
BEGIN
	SELECT SlpSeq INTO o_GetCardNewRef FROM Slip WHERE SlpNo = i_SlipNo;

	o_GetCardNewRef := i_SlipNo || '-' || SUBSTR('0000' || o_GetCardNewRef, LENGTH(o_GetCardNewRef) + 1, 4);

	o_GetCardNewRef := SUBSTR('0000000000000000' || o_GetCardNewRef, LENGTH(o_GetCardNewRef) + 1, 16);

	RETURN o_GetCardNewRef;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN NULL;
END NHS_UTL_GETCARDNEWREF;
/
