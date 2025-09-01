-- TelLog \ LookUpItmCode
CREATE OR REPLACE FUNCTION NHS_UTL_LOOKUPITMCODE (
	i_TxMode     IN VARCHAR2,
	i_TxDate     IN VARCHAR2,
	i_SlpNo      IN VARCHAR2,
	i_SlpType    IN VARCHAR2,
	i_ChrgType   IN VARCHAR2,
	i_ChrgCode   IN VARCHAR2,
	i_AcmCode    IN VARCHAR2,
	i_Unit       IN NUMBER,
	i_Amount     IN NUMBER,
	i_SlpHDisc   IN NUMBER,
	i_SlpDDisc   IN NUMBER,
	i_SlpSDisc   IN NUMBER,
	i_UserID     IN VARCHAR2,
	-------------------------------
	o_ItmCode    OUT VARCHAR2,
	o_ItmCat     OUT VARCHAR2,
	o_ItmType    OUT VARCHAR2,
	o_ItmName    OUT VARCHAR2,
	o_StnOAmt    OUT NUMBER,
	o_StnBAmt    OUT NUMBER,
	o_StnCpsFlag OUT VARCHAR2,
	o_SlpCpsid   OUT NUMBER,
	o_flagToDi   OUT BOOLEAN,
	o_SlpDisc    OUT NUMBER,
	o_StnRlvl    OUT NUMBER,
	o_errmsg     OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_Count NUMBER;
	v_IsPBOUser NUMBER;
	v_DPTCODE Usr.DptCode%TYPE;
	v_ItmCName Item.ItmCName%TYPE;
	o_errcode NUMBER := -1;

	TXN_ADD_MODE VARCHAR2(3) := 'ADD';
	ITEM_CATEGORY_CREDIT VARCHAR2(1) := 'C';
	ITEM_CATEGORY_BOTH VARCHAR2(1) := 'B';
BEGIN
	SELECT COUNT(1) INTO v_Count FROM Usr WHERE UsrId = i_UserID;
	IF v_Count > 0 THEN
		SELECT USRPBO, DPTCODE INTO v_IsPBOUser, v_DPTCODE FROM Usr WHERE UsrId = i_UserID;
	END IF;

	IF v_IsPBOUser = -1 THEN
		IF i_TxMode = TXN_ADD_MODE THEN
			SELECT COUNT(1) INTO v_Count
			FROM   Item
			WHERE  ItmCode = i_ChrgCode
			AND	   ItmCat != ITEM_CATEGORY_CREDIT;

			IF v_Count = 1 THEN
				SELECT ItmCode, ItmType, ItmName, ItmCName, ItmCat
				INTO   o_ItmCode, o_ItmType, o_ItmName, v_ItmCName, o_ItmCat
				FROM   Item
				WHERE  ItmCode = i_ChrgCode
				AND	   ItmCat != ITEM_CATEGORY_CREDIT;
			END IF;
		ELSE
			SELECT COUNT(1) INTO v_Count
			FROM   Item
			WHERE  ItmCode = i_ChrgCode
			AND   (ItmCat = ITEM_CATEGORY_CREDIT OR ItmCat = ITEM_CATEGORY_BOTH);

			IF v_Count = 1 THEN
				SELECT ItmCode, ItmType, ItmName, ItmCName, ItmCat
				INTO   o_ItmCode, o_ItmType, o_ItmName, v_ItmCName, o_ItmCat
				FROM   Item
				WHERE  ItmCode = i_ChrgCode
				AND   (ItmCat = ITEM_CATEGORY_CREDIT OR ItmCat = ITEM_CATEGORY_BOTH);
			END IF;
		END IF;
	ELSE
		SELECT COUNT(1) INTO v_Count
		FROM   Item i
		WHERE  ItmCode = i_ChrgCode
		AND	   ItmCat != ITEM_CATEGORY_CREDIT
		AND	   Dsccode IN (SELECT DSCCODE FROM ROLE_DEPT_SERV r, usrrole u WHERE r.ROLE_ID = u.ROLID AND u.USRID = i_UserID);

		IF v_Count = 1 THEN
			SELECT ItmCode, ItmType, ItmName, ItmCName, ItmCat
			INTO   o_ItmCode, o_ItmType, o_ItmName, v_ItmCName, o_ItmCat
			FROM   Item i
			WHERE  ItmCode = i_ChrgCode
			AND	   ItmCat != ITEM_CATEGORY_CREDIT
			AND	   Dsccode IN (SELECT DSCCODE FROM ROLE_DEPT_SERV r, usrrole u WHERE r.ROLE_ID = u.ROLID AND u.USRID = i_UserID);
		END IF;
	END IF;

	-- Item found
	IF o_ItmCode IS NOT NULL AND o_ItmCode != 'REF' THEN
		o_errcode := NHS_UTL_ITEMCHARGEVALIDATE(o_ItmCat, o_ItmType, i_TxMode,
			i_TxDate, i_SlpNo, o_ItmCode, i_SlpType, i_ChrgType, i_AcmCode, i_Unit,
			i_Amount,  i_SlpHDisc, i_SlpDDisc, i_SlpSDisc,
			o_StnOAmt, o_StnBAmt, o_StnCpsFlag, o_SlpCpsid, o_flagToDi,
			o_SlpDisc, o_StnRlvl, o_errmsg);

--		IF o_ItmCat IS NULL THEN
		IF o_errcode < 0 THEN
			IF i_TxMode = TXN_ADD_MODE THEN
				SELECT ItmCat INTO o_ItmCat
				FROM   Item
				WHERE  ItmCode = o_ItmCode
				AND	ItmCat != ITEM_CATEGORY_CREDIT
				AND   (v_IsPBOUser = -1 OR DptCode = v_DptCode);
			ELSE
				SELECT ItmCat INTO o_ItmCat
				FROM   Item
				WHERE  ItmCode = o_ItmCode
				AND   (ItmCat = ITEM_CATEGORY_CREDIT OR ItmCat = ITEM_CATEGORY_BOTH)
				AND	   DptCode = v_DptCode
				AND   (v_IsPBOUser = -1 OR DptCode = v_DptCode);
			END IF;

			o_errcode := NHS_UTL_ITEMCHARGEVALIDATE(o_ItmCat, o_ItmType, i_TxMode,
				i_TxDate, i_SlpNo, o_ItmCode, i_SlpType, i_ChrgType, i_AcmCode, i_Unit,
				i_Amount, i_SlpHDisc, i_SlpDDisc, i_SlpSDisc,
				o_StnOAmt, o_StnBAmt, o_StnCpsFlag, o_SlpCpsid, o_flagToDi,
				o_SlpDisc, o_StnRlvl, o_errmsg);
		END IF;
	END IF;

	RETURN o_errcode;

EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ERRMSG := SQLERRM || o_ERRMSG;

	RETURN -1;
END NHS_UTL_LOOKUPITMCODE;
/
