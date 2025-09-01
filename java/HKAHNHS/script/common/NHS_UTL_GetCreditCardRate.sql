CREATE OR REPLACE PROCEDURE NHS_UTL_GetCreditCardRate (
	p_latxId IN NUMBER,
	p_ctnctype IN OUT VARCHAR2,
	p_crarate IN OUT NUMBER
)
AS
	l_ctnid cashtx.ctnid%TYPE ;
BEGIN
	p_ctnctype := null;
	p_crarate := null;

	BEGIN
		SELECT ctnid INTO l_ctnid FROM cashtx
		WHERE ctxsno = (
			SELECT arptx.arprecno FROM arptx, artx
			WHERE arptx.arpid = artx.ARPID AND artx.ATXID = p_latxId
		);
	EXCEPTION WHEN OTHERS THEN
		NULL;
	END;

	BEGIN
		SELECT UPPER(TRIM(ctnctype)) INTO p_ctnctype FROM cardtx WHERE ctnid = l_ctnid;
	EXCEPTION WHEN OTHERS THEN
		NULL;
	END;

	BEGIN
		SELECT crarate INTO p_crarate FROM cardrate WHERE craname = p_ctncTYPE;
	EXCEPTION WHEN OTHERS THEN
		NULL;
	END;
END;
/
