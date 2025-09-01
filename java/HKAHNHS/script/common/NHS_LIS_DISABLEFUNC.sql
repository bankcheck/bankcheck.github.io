CREATE OR REPLACE FUNCTION "NHS_LIS_DISABLEFUNC" (
	v_UsrID VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	IF GET_REAL_STECODE != v_UsrID THEN
		OPEN OUTCUR FOR
			SELECT UPPER(FS.FscKey || '_' || FS.FscParent), UPPER(FS.fscdesc)
			FROM   FuncSec FS
			WHERE  FS.FscID NOT IN (
				SELECT RFS.FscID
				FROM   UsrRole UR, RoleFuncSec RFS
				WHERE  UR.RolID = RFS.RolID
				AND    UR.UsrID = v_UsrID
				UNION
				SELECT FscID
				FROM   UsrFuncSec
				WHERE  UsrID = v_UsrID
			)
			ORDER BY FS.FscID;
	ELSE
		OPEN OUTCUR FOR
			SELECT UPPER(FS.FscKey || '_' || FS.FscParent), UPPER(FS.fscdesc)
			FROM   FuncSec FS
			WHERE (FS.fsckey = 'btnOTAppDisable' AND fscParent = 'otAppBrowse')
			OR    (FS.fsckey = 'chkTCAR' AND fscParent = 'rptDayEnd');
	END IF;

	RETURN OUTCUR;

END NHS_LIS_DISABLEFUNC;
/
