CREATE OR REPLACE FUNCTION "NHS_ACT_LOGON_SECHKUPPAT" (
	i_Login_ID         VARCHAR2,
	i_Login_Pwd_Portal VARCHAR2,
	i_Usertype         VARCHAR2,
	i_moduleCode       VARCHAR2
)
	RETURN Types.cursor_type
AS
	OUTCUR types.cursor_type;
	o_errcode NUMBER;
	v_Usrid Varchar2(30);
	v_UsrName VARCHAR2(80);
	v_SteCode UserSite.SteCode%TYPE;
	v_SteName Site.SteName%TYPE;
	v_Count NUMBER;
	v_Computername Varchar2(20);
	v_Isauthsec Number;
	v_HATSUSRID VARCHAR2(30);
	v_SpcCode Usr.SpcCode%TYPE;
BEGIN
	SELECT GET_REAL_STECODE() INTO v_STECODE FROM DUAL;

	-- change to hats.prod.amc2 before amc1 is ready
	IF v_STECODE = 'AMC2' THEN
		v_STECODE := 'AMC';
	END IF;

	IF UPPER(i_login_id) != 'TEST' then
		SELECT Module_User_Id INTO v_Hatsusrid
		FROM   SSO_USER_MAPPING@SSO
		WHERE  Module_Code = 'hats.prod.' || LOWER(v_SteCode)
		AND    sso_user_id = i_login_ID
		AND    enabled = 1;
	end if;

	If i_userType = 'counterSign2' Then
--		Select Count(1) Into v_Count
--		FROM   USRFUNCSEC
--		WHERE  USRID = v_HATSUSRID
--		AND    FSCID  = (SELECT FSCID FROM FUNCSEC WHERE FSCKEY = 'isSecondSign');

		SELECT COUNT(1) Into v_Count
		FROM   FUNCSEC FS,
			(SELECT RFS.FscID
			FROM   UsrRole UR, RoleFuncSec RFS
			WHERE  UR.ROLID = RFS.ROLID
			AND    UR.USRID = v_HATSUSRID
			UNION
			SELECT FscID
			FROM   UsrFuncSec
			WHERE  USRID = v_HATSUSRID
		) US
		WHERE  FS.FSCID = US.FSCID
		AND    FS.FSCKEY = 'isSecondSign'
		ORDER BY FS.FSCID;


		If v_Count = 0 Then
			v_ISAUTHSEC := -1;
		END IF;
	END IF;

	--//check Portal Password//--
	SELECT COUNT(1) INTO v_Count
	FROM   co_users@pportal u,site s
	WHERE  (u.CO_USERNAME = UPPER(i_Login_ID) or u.CO_STAFF_ID = UPPER(i_Login_ID))
--	AND   (u.CO_PASSWORD = i_login_Pwd_Portal OR i_login_Pwd_Portal IS NULL)
	--AND    UPPER(u.CO_SITE_CODE) = s.SteCode
	AND    UPPER(u.CO_SITE_CODE) NOT IN (SELECT SteCode FROM NoLogin);

	IF v_Count = 1 THEN
		SELECT u.CO_STAFF_ID, u.CO_USERNAME, UPPER(u.CO_SITE_CODE), s.SteName
		INTO   v_UsrID, v_UsrName, v_SteCode, v_SteName
		FROM   co_users@pportal u,site s
		WHERE  (u.CO_USERNAME = UPPER(i_Login_ID) or u.CO_STAFF_ID = UPPER(i_Login_ID))
--		AND   (u.CO_PASSWORD = i_login_Pwd_Portal OR i_login_Pwd_Portal IS NULL)
		--AND    UPPER(u.CO_SITE_CODE) = s.SteCode
		And    Upper(U.Co_Site_Code) Not In (Select Stecode From Nologin);
	END IF;
  
  IF UPPER(i_login_id) = 'TEST' then
    OPEN OUTCUR FOR
			SELECT 1 FROM DUAL;
	ELSIF v_Isauthsec = -1 Then
		Open Outcur For
			Select 'counterSign2', v_HATSUSRID
			FROM dual;
	ELSIF v_UsrID IS NOT NULL THEN
		IF v_STECODE = 'AMC1' OR v_STECODE = 'AMC2' THEN
			v_STECODE := 'HKAH';
		END IF;
		
		OPEN OUTCUR FOR
			Select v_Usrid, v_HATSUSRID,v_SteCode
			FROM dual;
	ELSE
		OPEN OUTCUR FOR
			SELECT 1 FROM DUAL WHERE 1 != 1;
	END IF;
	RETURN OUTCUR;
END NHS_ACT_LOGON_SECHKUPPAT;
/
