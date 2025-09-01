CREATE OR REPLACE FUNCTION "NHS_ACT_LOGON_SSO" (
	i_action     	VARCHAR2,
	i_userid     	VARCHAR2,
	i_deptCode    	VARCHAR2,
	i_moduleCode    VARCHAR2,
	i_sessionid 	VARCHAR2,
	O_ERRMSG        OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_count NUMBER;
BEGIN
	o_errcode := -1;

	IF i_action = 'ADD' THEN
		SELECT COUNT(1) INTO v_count
		FROM   SSO_SESSION@sso
		WHERE  SESSION_ID = i_sessionid
		AND    USER_ID = i_userid
		AND    MODULE_CODE = i_moduleCode;

		IF v_count = 0 THEN
			INSERT INTO SSO_SESSION@sso (
				SESSION_ID,
				USER_ID,
				DEPT_CODE,
				MODULE_CODE
			) VALUES (
				i_sessionid,
				i_userid,
				i_deptCode,
				i_moduleCode
			);
		END IF;
		o_errcode := 0;
	ELSIF i_action = 'MOD' THEN
		SELECT COUNT(1) INTO v_count
		FROM   SSO_SESSION@sso
		WHERE  SESSION_ID = i_sessionid
		AND    USER_ID = i_userid
		AND    MODULE_CODE = i_moduleCode
		AND    TIMESTAMP_INIT > SYSDATE - 1;

		IF v_count > 0 THEN
			UPDATE SSO_SESSION@sso SET TIMESTAMP_UPDATE = sysdate WHERE SESSION_ID = i_sessionid AND USER_ID = i_userid AND MODULE_CODE = i_moduleCode;
			o_errcode := 0;
		END IF;
	ELSIF i_action = 'DEL' THEN
		DELETE FROM SSO_SESSION@sso WHERE SESSION_ID = i_sessionid AND USER_ID = i_userid AND MODULE_CODE = i_moduleCode;
		o_errcode := 0;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
	o_ERRMSG := SQLERRM || o_ERRMSG;

	RETURN -999;
END NHS_ACT_LOGON_SSO;
/
