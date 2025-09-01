CREATE OR REPLACE FUNCTION NHS_GET_SLPRMK (
	v_SlipNo VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
--	v_ISSHOWHDER VARCHAR2(2);
BEGIN
--	SELECT PARAM1 INTO v_ISSHOWHDER FROM SYSPARAM WHERE PARCDE = 'SHWRKHDER' AND ROWNUM = 1;

	OPEN outcur FOR
		SELECT
			u1.UsrName,
			TO_CHAR(s.RmkModDt, 'DD/MM/YYYY HH24:MI:SS'),
			s.SlpRemark,
			u2.UsrName,
			TO_CHAR(s.AddRmkModDt, 'DD/MM/YYYY HH24:MI:SS'),
			s.SlpAddRmk || s.SlpAddRmk2 || se.SlpAddRmk3
		FROM  slip s
		LEFT  JOIN slip_extra se ON s.slpno = se.slpno
		LEFT  JOIN usr u1 ON s.RmkModUsr = u1.usrid
		LEFT  JOIN usr u2 ON s.AddRmkModUsr = u2.usrid
		WHERE s.slpno = v_SlipNo;
	RETURN outcur;
END NHS_GET_SLPRMK;
/
