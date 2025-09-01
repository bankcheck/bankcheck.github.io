CREATE OR REPLACE FUNCTION "NHS_GET_ACCRECEIVABLE"
(v_Arccode IN VARCHAR2)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	v_Count NUMBER := 0;
	v_ArcAmt NUMBER := 0;
	v_Arcuamt NUMBER := 0;
	ARTX_STATUS_NORMAL VARCHAR2(1) := 'N';
	ARPTX_STATUS_NORMAL VARCHAR2(1) := 'N';
BEGIN
	SELECT COUNT(1) INTO v_Count FROM Artx WHERE Arccode = v_Arccode and Atxsts = ARTX_STATUS_NORMAL;
	IF v_Count > 0 THEN
		SELECT NVL(SUM(Atxamt), 0) - NVL(SUM(Atxsamt), 0) INTO v_ArcAmt FROM Artx WHERE Arccode = v_Arccode and Atxsts = ARTX_STATUS_NORMAL;
	END IF;

	SELECT COUNT(1) INTO v_Count FROM Arptx WHERE Arccode = v_Arccode and Arpsts = ARPTX_STATUS_NORMAL;
	IF v_Count > 0 THEN
		SELECT NVL(SUM(Arpoamt), 0) + NVL(SUM(Arpaamt), 0) INTO v_Arcuamt FROM Arptx WHERE Arccode = v_Arccode and Arpsts = ARPTX_STATUS_NORMAL;
	END IF;

	OPEN OUTCUR FOR
		SELECT Arccode,
			Arcname,
			Arcadd1,
			Arcadd2,
			Arcadd3,
			Arctel,
			Arcct,
			Fax,
			Email,
			v_Arcuamt,
			v_ArcAmt,
			v_Arcuamt + v_ArcAmt
		FROM Arcode
		WHERE Arccode = v_Arccode;
	RETURN OUTCUR;
END NHS_GET_ACCRECEIVABLE;
/
