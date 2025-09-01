CREATE OR REPLACE FUNCTION "NHS_CHK_KEEPALIVE" (
	i_Login_ID     VARCHAR2,
	i_ComputerName VARCHAR2,
	i_ModuleCode   VARCHAR2,
	i_Session_ID   VARCHAR2
)
	RETURN Types.cursor_type
AS
	OUTCUR types.cursor_type;
	v_errcode NUMBER;
	v_errmsg VARCHAR2(100);
	o_errcode NUMBER := 0;
	o_errmsg VARCHAR2(200) := '';
BEGIN
--	IF i_Session_ID LIKE '%:HKP1%' OR i_Session_ID LIKE '%:TWP1%' THEN
--		o_errcode := -1; -- info message
--		o_errcode := -2; -- message popup
--		o_errcode := -3; -- timeout popup
--		o_errmsg := 'Program Upgraded. Please login <font color=green>Portal HATS</font> again.';
--		o_errmsg := 'System timeout. Please login <font color=green>Portal HATS</font> again.';
--	END IF;

	v_errcode := NHS_ACT_LOGON_SSO('MOD', i_Login_ID, NULL, i_ModuleCode, i_Session_ID, v_errmsg);

	IF v_errcode = -1 THEN
		o_errcode := -3; -- timeout popup
		o_errmsg := 'System timeout. Please login <font color=green>Portal HATS</font> again.';
	END IF;

	OPEN OUTCUR FOR
		SELECT TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'), o_errcode, o_errmsg
		FROM DUAL;

	RETURN OUTCUR;
END NHS_CHK_KEEPALIVE;
/
