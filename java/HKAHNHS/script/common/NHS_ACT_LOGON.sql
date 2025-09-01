CREATE OR REPLACE FUNCTION "NHS_ACT_LOGON" (
	i_Login_ID     VARCHAR2,
	i_Login_Pwd    VARCHAR2,
	i_DayEnd_YN    VARCHAR2,
	i_ComputerName VARCHAR2,
	i_isAuth       VARCHAR2,
	i_Session_ID   VARCHAR2
)
	RETURN Types.cursor_type
AS
	OUTCUR types.cursor_type;
	o_errcode NUMBER;
	v_UsrID Usr.UsrID%TYPE;
	v_UsrName Usr.UsrName%TYPE;
	v_SteCode UserSite.SteCode%TYPE;
	v_SteName Site.SteName%TYPE;
	v_DBEnv SysParam.Param1%TYPE;
	v_PBAState2 SysParam.Param1%TYPE;
	v_IsUsing NUMBER;
	v_Count NUMBER;
	v_UTime DATE;
	v_RlkKey RLOCK.RlkKey%TYPE;
	v_DateDiff NUMBER;
	v_ComputerName VARCHAR2(20);
	v_loginCode VARCHAR2(4);
	v_UsrID_1 Usr.UsrID%TYPE;
	v_UsrID_2 Usr.UsrID%TYPE;
	v_UsrID_3 Usr.UsrID%TYPE;
	v_UsrID_4 Usr.UsrID%TYPE;
	v_SpcCode Usr.SpcCode%TYPE;
BEGIN
	-- trim computer name if too big
	IF LENGTH(i_ComputerName) > 20 THEN
		v_ComputerName := SUBSTR(i_ComputerName, 1, 20);
	ELSE
		v_ComputerName := i_ComputerName;
	END IF;

	SELECT COUNT(1) INTO v_Count
	FROM   Usr u, UserSite us, Site s
	WHERE  u.UsrID = UPPER(i_Login_ID)
	AND    u.UsrID = us.UsrID
	AND   (u.USRPWD = i_Login_Pwd OR i_Login_Pwd IS NULL)
	AND    u.UsrSts = -1
	AND    us.SteCode = s.SteCode
	AND    us.SteCode NOT IN (SELECT SteCode FROM NoLogin);

	IF v_Count = 1 THEN
		SELECT u.UsrID, u.UsrName, us.SteCode, s.SteName, u.SpcCode
		INTO   v_UsrID, v_UsrName, v_SteCode, v_SteName, v_SpcCode
		FROM   Usr u, UserSite us, Site s
		WHERE  u.UsrID = UPPER(i_Login_ID)
		AND    u.UsrID = us.UsrID
		AND   (u.USRPWD = i_Login_Pwd OR i_Login_Pwd IS NULL)
		AND    u.UsrSts = -1
		AND    us.SteCode = s.SteCode
		AND    us.SteCode NOT IN (SELECT SteCode FROM NoLogin);
	END IF;

	IF i_isAuth = 'Y' THEN
		Select Count(1) Into v_Count From Usr Where Usrid = Upper(i_Login_ID);
		IF v_Count > 0 THEN
			SELECT
				Is_Exist.Usrid,
				Is_Active.Usrid,
				Is_pwd.Usrid,
				Is_site.Usrid
			INTO
				v_UsrID_1,
				v_UsrID_2,
				v_UsrID_3,
				v_UsrID_4
			FROM
				(Select UsrID From Usr Where Usrid = UPPER(i_Login_ID)) Is_Exist
				Left Join
				(Select Usrid From Usr Where Usrid = UPPER(i_Login_ID) And Usrsts = -1) Is_Active
					On Is_Exist.Usrid = Is_Active.Usrid
				Left Join
				(Select Usrid From Usr Where Usrid = UPPER(i_Login_ID) And usrpwd = i_Login_Pwd) Is_pwd
					on Is_Exist.UsrID = Is_pwd.Usrid
				Left Join
				(Select u.Usrid From Usr u, UserSite us Where u.Usrid = UPPER(i_Login_ID)
					AND u.UsrID = us.UsrID AND us.SteCode NOT IN (SELECT SteCode FROM NoLogin)) Is_site
					on Is_Exist.UsrID = Is_site.Usrid;

			IF v_UsrID_1 IS NULL THEN
				v_loginCode := 'AU02';
			ELSIF v_UsrID_2 IS NULL THEN
				v_loginCode := 'AU03';
			ELSIF v_UsrID_3 IS NULL THEN
				v_loginCode := 'AU02';
			ELSIF v_UsrID_4 IS NULL THEN
				v_loginCode := 'AU03';
			ELSE
				v_loginCode := 'AU00';
			END IF;
		ELSE
			v_loginCode := 'AU02';
		END IF;

		OPEN OUTCUR FOR
		Select v_loginCode From Dual;
	ELSE
		SELECT COUNT(1) INTO v_Count FROM SysParam WHERE ParCde = 'DBEnv';
		IF v_Count = 1 THEN
			SELECT Param1 INTO v_DBEnv FROM SysParam WHERE ParCde = 'DBEnv';
		END IF;

		-- only check session in production and not admin account
		IF v_DBEnv LIKE '%Production%' AND v_UsrID NOT IN ('HKAH', 'TWAH', 'AMC', 'AMC1', 'AMC2') THEN
			SELECT COUNT(1) INTO v_Count FROM SSO_SESSION@sso WHERE SESSION_ID = i_Session_ID AND USER_ID = v_UsrID;
		ELSE
			v_Count := 1;
		END IF;

		IF v_UsrID IS NOT NULL AND v_Count > 0 THEN
			SELECT COUNT(1) INTO v_Count FROM SysParam WHERE ParCde = 'PBAState2';
			IF v_Count = 1 THEN
				SELECT Param1 INTO v_PBAState2 FROM SysParam WHERE ParCde = 'PBAState2';
			END IF;

			SELECT RLKDate, RlkKey INTO v_UTime, v_RlkKey FROM Rlock
			WHERE  UsrID = 'D_A_Y_E_ND' and RlkMac = 'S_E_R_V_E_R' and SteCode = GET_CURRENT_STECODE;

			IF v_PBAState2 = 'YES' THEN
				SELECT IsUsing INTO v_IsUsing FROM Usr WHERE UsrID = i_Login_ID;

				IF v_IsUsing = -1 THEN
					-- Current user is using the system!
					o_errcode := -1;
				ELSE
					UPDATE Usr SET IsUsing = -1 WHERE UsrID = i_Login_ID;
				END IF;
			END IF;

			UPDATE StsPrebok SET ENDDate = SYSDate WHERE ComputerName = v_ComputerName AND ENDDate IS NULL;

			IF TRIM(v_RlkKey) = 'FAILED KEY' THEN
				o_errcode := 1;
			ELSE
				v_DateDiff := ABS(v_UTime - SYSDate);

				IF i_DayEnd_YN = 'N' THEN
					IF v_DateDiff >= 1 THEN
						o_errcode := 1;
					ELSE
						o_errcode := 0;
					END IF;
				ELSE
					IF v_DateDiff > 1 THEN
						o_errcode := 1;
					ELSE
						o_errcode := 0;
					END IF;
				END IF;
			END IF;

			-- assign spec code if empty
			IF v_SpcCode IS NULL THEN
				IF GET_CURRENT_STECODE = 'HKAH' THEN
					IF v_UsrName LIKE 'DENTAL -%' THEN
						v_SpcCode := 'DENTIST';
					ELSIF v_UsrName = 'OP - REHAB' THEN
						v_SpcCode := 'PHYSIO';
					END IF;
				ELSE
					IF v_UsrName LIKE 'DE - %' THEN
						v_SpcCode := 'DN';
					ELSIF v_UsrName LIKE 'PT -%' THEN
						v_SpcCode := 'RE';
					END IF;
				END IF;
			END IF;

			OPEN OUTCUR FOR
				SELECT UsrName, DPTCODE, UsrInp, UsrOut, UsrDay, UsrPBO, v_SteCode, v_SteName, v_DBEnv, o_errcode, v_SpcCode
				FROM   Usr
				WHERE  UsrID = v_UsrID;
		ELSE
			OPEN OUTCUR FOR
				SELECT 1 FROM DUAL WHERE 1 != 1;
		END IF;
	END IF;

	RETURN OUTCUR;
END NHS_ACT_LOGON;
/
