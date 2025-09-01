CREATE OR REPLACE FUNCTION "NHS_GET_ITEM_EXIST" (
	i_ItmCode IN VARCHAR2,
	i_STNTYPE IN VARCHAR2,	-- C:FROM table creditchg,D: FROM itemchg, null FROM item
	i_UsrID   IN VARCHAR2
)
	RETURN types.CURSOR_TYPE
AS
	OUTCUR types.CURSOR_TYPE;
	ITEM_CATEGORY_CREDIT VARCHAR2(1) := 'C';
	ITEM_CATEGORY_BOTH VARCHAR2(1) := 'B';
	ITEM_CATEGORY_DEBIT VARCHAR2(1) := 'D';
	v_DeptCode Usr.DptCode%TYPE;
	v_Count NUMBER;
	v_stntdate DATE := TRUNC(SYSDATE);
BEGIN
	-- get deptcode
	SELECT COUNT(1) INTO v_Count FROM Usr WHERE UsrID = i_UsrID AND UsrPBO = -1;
	IF v_Count = 1 THEN
		SELECT DptCode INTO v_DeptCode FROM Usr WHERE UsrID = i_UsrID AND UsrPBO = -1;
	END IF;

	IF i_STNTYPE = ITEM_CATEGORY_CREDIT then
		OPEN OUTCUR FOR
		SELECT I.ItmCode, I.ItmName
		FROM   Item I, CreditChg C
		WHERE  I.ItmCode = C.ItmCode AND I.ItmCode = i_ItmCode
		AND  ( v_DeptCode IS NULL OR DptCode = v_DeptCode )
		AND  ( I.ItmCat = ITEM_CATEGORY_CREDIT OR I.ItmCat = ITEM_CATEGORY_BOTH )
		AND  ( C.cicsdt IS NULL OR C.cicsdt <= v_stntdate )
		AND  ( C.cicedt IS NULL OR C.cicedt >= v_stntdate );
	ELSIF i_STNTYPE = ITEM_CATEGORY_DEBIT then
		OPEN OUTCUR FOR
		SELECT I.ItmCode, I.ItmName
		FROM   Item I, ItemChg C
		WHERE  I.ItmCode = C.ItmCode AND I.ItmCode = i_ItmCode
		AND  ( v_DeptCode IS NULL OR DptCode = v_DeptCode )
		AND  ( I.ItmCat = ITEM_CATEGORY_DEBIT OR I.ItmCat = ITEM_CATEGORY_BOTH )
		AND  ( C.itcsdt IS NULL OR C.itcsdt <= v_stntdate )
		AND  ( C.itcedt IS NULL OR C.itcedt >= v_stntdate );
	ELSE
		OPEN OUTCUR FOR
		SELECT ItmCode, ItmName FROM Item WHERE ItmCode = i_ItmCode;
	END IF;

	RETURN OUTCUR;
END NHS_GET_ITEM_EXIST;
/
