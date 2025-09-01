CREATE OR REPLACE FUNCTION "NHS_ACT_LOGON_SECHK" (
	i_Login_ID         VARCHAR2,
	i_login_Pwd_Portal VARCHAR2,
	i_ComputerName     VARCHAR2
)
	RETURN Types.cursor_type
AS
	OUTCUR types.cursor_type;
	o_errcode NUMBER;
	v_UsrID VARCHAR2(30);
	v_UsrName VARCHAR2(80);
	v_SteCode UserSite.SteCode%TYPE;
	v_SteName Site.SteName%TYPE;
	v_Count NUMBER;
	v_ComputerName VARCHAR2(20);
	v_loginCode VARCHAR2(4);
--	v_UsrID_1 Usr.UsrID%TYPE;
--	v_UsrID_2 Usr.UsrID%TYPE;
--	v_UsrID_3 Usr.UsrID%TYPE;
--	v_UsrID_4 Usr.UsrID%TYPE;
	v_SpcCode Usr.SpcCode%TYPE;
BEGIN
	-- trim computer name if too big
	IF LENGTH(i_ComputerName) > 20 THEN
		v_ComputerName := SUBSTR(i_ComputerName, 1, 20);
	ELSE
		v_ComputerName := i_ComputerName;
	End If;
-- remove check OLD HATS Password
--	SELECT COUNT(1) INTO v_Count
--	FROM   Usr u, UserSite us, Site s
--	WHERE  u.UsrID = UPPER(i_Login_ID)
--	AND    u.UsrID = us.UsrID
--	AND   (u.USRPWD = i_Login_Pwd OR i_Login_Pwd IS NULL)
--	AND    u.UsrSts = -1
--	AND    us.SteCode = s.SteCode
--	AND    us.SteCode NOT IN (SELECT SteCode FROM NoLogin);
--
--	IF v_Count = 1 THEN
--		SELECT u.UsrID, u.UsrName, us.SteCode, s.SteName, u.SpcCode
--		INTO   v_UsrID, v_UsrName, v_SteCode, v_SteName, v_SpcCode
--		FROM   Usr u, UserSite us, Site s
--		WHERE  u.UsrID = UPPER(i_Login_ID)
--		AND    u.UsrID = us.UsrID
--		AND   (u.USRPWD = i_Login_Pwd OR i_Login_Pwd IS NULL)
--		AND    u.UsrSts = -1
--		AND    us.SteCode = s.SteCode
--		AND    us.SteCode NOT IN (SELECT SteCode FROM NoLogin);
--  ELSE
--		SELECT COUNT(1) INTO v_Count
--		FROM   co_users@pportal u,site s
--		WHERE  (u.CO_USERNAME = UPPER(i_Login_ID) or u.CO_STAFF_ID = UPPER(i_Login_ID))
--		AND   (u.CO_PASSWORD = i_login_Pwd_Portal OR i_login_Pwd_Portal IS NULL)
--		AND    UPPER(u.CO_SITE_CODE) = s.SteCode
--		AND    UPPER(u.CO_SITE_CODE) NOT IN (SELECT SteCode FROM NoLogin);
--
--		IF v_Count = 1 THEN
--			SELECT u.CO_STAFF_ID, u.CO_USERNAME, UPPER(u.CO_SITE_CODE), s.SteName
--			INTO   v_UsrID, v_UsrName, v_SteCode, v_SteName
--			FROM   co_users@pportal u,site s
--			WHERE  (u.CO_USERNAME = UPPER(i_Login_ID) or u.CO_STAFF_ID = UPPER(i_Login_ID))
--			AND   (u.CO_PASSWORD = i_login_Pwd_Portal OR i_login_Pwd_Portal IS NULL)
--			AND    UPPER(u.CO_SITE_CODE) = s.SteCode
--			AND    UPPER(u.CO_SITE_CODE) NOT IN (SELECT SteCode FROM NoLogin);
--		END IF;
--  END IF;
--//check Portal Password//--
		SELECT COUNT(1) INTO v_Count
		FROM   co_users@pportal u,site s
		WHERE  (u.CO_USERNAME = UPPER(i_Login_ID) or u.CO_STAFF_ID = UPPER(i_Login_ID))
		AND   (u.CO_PASSWORD = i_login_Pwd_Portal OR i_login_Pwd_Portal IS NULL)
		AND    UPPER(u.CO_SITE_CODE) = s.SteCode
		AND    UPPER(u.CO_SITE_CODE) NOT IN (SELECT SteCode FROM NoLogin);

		IF v_Count = 1 THEN
			SELECT u.CO_STAFF_ID, u.CO_USERNAME, UPPER(u.CO_SITE_CODE), s.SteName
			INTO   v_UsrID, v_UsrName, v_SteCode, v_SteName
			FROM   co_users@pportal u,site s
			WHERE  (u.CO_USERNAME = UPPER(i_Login_ID) or u.CO_STAFF_ID = UPPER(i_Login_ID))
			AND   (u.CO_PASSWORD = i_login_Pwd_Portal OR i_login_Pwd_Portal IS NULL)
			AND    UPPER(u.CO_SITE_CODE) = s.SteCode
			And    Upper(U.Co_Site_Code) Not In (Select Stecode From Nologin);
		END IF;

		IF v_UsrID IS NOT NULL THEN
			OPEN OUTCUR FOR
				SELECT v_UsrID, v_UsrName
				FROM   dual;
		ELSE
			OPEN OUTCUR FOR
				SELECT 1 FROM DUAL WHERE 1 != 1;
		END IF;
	RETURN OUTCUR;
END NHS_ACT_LOGON_SECHK;
/
