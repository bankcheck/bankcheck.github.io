CREATE OR REPLACE FUNCTION "NHS_RPT_CHGSLPAPPLABEL" (
	i_Patno VARCHAR2,
	i_bkgid VARCHAR2
)
	return types.cursor_type
AS
	outcur types.cursor_type;
	v_SteCode VARCHAR2(4);
	v_DocCode Doctor.DocCode%TYPE;
	v_DocName VARCHAR2(81);
	v_PatName VARCHAR2(81);
	v_PatCName Patient.PatCName%TYPE;
	v_PatbDate VARCHAR2(10);
	v_PatSex Patient.PatSex%TYPE;
	v_Bkgsdate VARCHAR2(18);
	v_BkaDesc VARCHAR2(100);
	v_count NUMBER;
BEGIN
	v_SteCode := GET_REAL_STECODE;

	SELECT B.BKGPNAME, B.BKGPCNAME, S.DocCode, TO_CHAR(B.Bkgsdate, 'dd/mm/yyyy HH24:MI')
	INTO   v_PatName, v_PatCName, v_DocCode, v_Bkgsdate
	FROM   BOOKING B
	INNER JOIN SCHEDULE S ON B.SCHID = S.SCHID
	WHERE  B.BKGID = TO_NUMBER(i_bkgid);

	BEGIN
		SELECT A.BkaDesc INTO v_BkaDesc
		FROM   BOOKING B
		INNER JOIN BOOKINGALERT A ON B.bkgalert = A.bkaid
		WHERE  B.bkgid = TO_NUMBER(i_bkgid)
		AND   (A.BKAQUOTAD = -1 OR A.BKAQUOTAM = -1 OR A.BKAQUOTAY = -1);

		IF v_BkaDesc IS NOT NULL THEN
			v_count := instr(v_BkaDesc, '(', 1, 1);
			IF v_count > 0 THEN
				v_BkaDesc := substr(v_BkaDesc, 1, v_count - 1);
			END IF;
		END IF;
	EXCEPTION
	WHEN OTHERS THEN
		v_BkaDesc := NULL;
	END;

	IF i_Patno IS NOT NULL THEN
		BEGIN
			SELECT PatFName || ' ' || PatGName, PatCName, TO_CHAR(PatbDate,'dd/mm/yyyy'), PatSex
			INTO   v_PatName, v_PatCName, v_PatbDate, v_PatSex
			FROM   Patient
			WHERE  patno = i_Patno;
		EXCEPTION
		WHEN OTHERS THEN
			v_PatbDate := null;
			v_PatSex := null;
		END;
	END IF;

	IF v_DocCode IS NOT NULL THEN
		BEGIN
			SELECT DocFname || ' ' || DocGname
			INTO   v_DocName
			FROM   DOCTOR
			WHERE  DocCode = v_DocCode;
		EXCEPTION
		WHEN OTHERS THEN
			v_DocName := null;
		END;
	END IF;

	OPEN outcur FOR
		SELECT decode(v_SteCode, 'HKAH', 'HKAH - SR', v_SteCode), i_Patno, v_PatName,
			v_PatCName, v_PatbDate, v_PatSex, v_DocName, v_Bkgsdate, v_BkaDesc
		FROM   DUAL;

	Return Outcur;

END NHS_RPT_CHGSLPAPPLABEL;
/
