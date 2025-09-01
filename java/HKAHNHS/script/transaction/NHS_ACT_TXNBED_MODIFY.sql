CREATE OR REPLACE FUNCTION "NHS_ACT_TXNBED_MODIFY" (
	p_action        IN VARCHAR2,
	p_slpno         IN VARCHAR2,
	p_InPID         IN VARCHAR2,
	P_BEDCODE       IN VARCHAR2,
	P_ACMCODE       IN VARCHAR2,
	P_OLDACMCODE    IN VARCHAR2,
	P_CHKUPDSTNYN   IN VARCHAR2,
	P_OVERRIDEBEDYN IN VARCHAR2,
	P_TRANSACTIONID IN VARCHAR2,
	P_ACCEPTCHANGE  IN VARCHAR2,
	P_COMPUTERNAME  IN VARCHAR2,
	p_UserID        IN VARCHAR2,
	o_errmsg	    OUT VARCHAR2
)
	RETURN  NUMBER
AS
	v_Count NUMBER;
	v_NewBedCode BED.BEDCODE%TYPE;
	v_OldBedCode BED.BEDCODE%TYPE;
	v_BedSts VARCHAR2(1);
	v_AcmCode ACM.ACMCODE%TYPE;
	v_InpdDate DATE;
	o_errcode NUMBER := -1;
	MSG_BED_LOCK VARCHAR2(14) := 'Bed is locked.';
	BED_STS_FREE VARCHAR2(1) := 'F';
	BED_STS_OCCUPY VARCHAR2(1) := 'O';
	v_OUTCUR TYPES.CURSOR_TYPE;
	changeACM BOOLEAN;
BEGIN
	o_errmsg := 'OK';

	SELECT COUNT(1) INTO v_COUNT FROM RLOCK WHERE RLKTYPE = 'Bed' AND RLKKEY = P_BEDCODE;
	IF v_Count > 0 AND P_ACCEPTCHANGE = 'N' THEN
		o_errmsg := 'The current bed is locked!';
		RETURN o_errcode;
	END IF;

	-- lock bed
	v_COUNT := NHS_ACT_RECORDLOCK(NULL, 'Bed', P_BEDCODE, P_COMPUTERNAME, P_USERID, O_ERRMSG);
	IF v_COUNT = 0 OR P_ACCEPTCHANGE = 'Y' THEN

		SELECT COUNT(1) INTO v_Count FROM Bed WHERE BedCode = p_BedCode;
		IF v_Count = 1 THEN
			SELECT BedCode, BedSts INTO v_NewBedCode, v_BedSts FROM Bed WHERE BedCode = p_BedCode;
		END IF;

		SELECT COUNT(1) INTO v_Count FROM Acm WHERE AcmCode = p_AcmCode;
		IF v_Count = 1 THEN
			SELECT AcmCode INTO v_AcmCode FROM Acm WHERE AcmCode = p_AcmCode;
		END IF;

		SELECT COUNT(1) INTO v_Count FROM InPat WHERE InPID = p_InPID;
		IF v_Count = 1 THEN
			SELECT BedCode INTO v_OldBedCode FROM InPat WHERE InPID = p_InPID;
		END IF;

		IF p_ChkUpdStnYN = 'Y' AND P_ACCEPTCHANGE = 'N' THEN
			-- keep bed lock, let java handle dlgConPceChange
--			O_ERRCODE := NHS_ACT_RECORDUNLOCK(NULL, 'Bed', P_BEDCODE, P_COMPUTERNAME, P_USERID, O_ERRMSG);
			o_errcode := 0;
			RETURN O_ERRCODE;
		ELSIF P_CHKUPDSTNYN = 'Y' AND P_ACCEPTCHANGE = 'Y' THEN
			O_ERRMSG := NULL;
			IF P_OLDACMCODE = v_AcmCode THEN
				CHANGEACM := FALSE;
			ELSE
				CHANGEACM := TRUE;
			END IF;

			v_OUTCUR := NHS_UTL_CONPCECHANGE(P_SLPNO, 'I', P_OLDACMCODE, '', v_ACMCODE, P_TRANSACTIONID, CHANGEACM);
			O_ERRCODE := NHS_UTL_RECALCULATECPS(P_SLPNO, v_OUTCUR, P_USERID, O_ERRMSG);

			O_ERRCODE := NHS_ACT_RECORDUNLOCK(NULL, 'Bed', P_BEDCODE, P_COMPUTERNAME, P_USERID, O_ERRMSG);
			RETURN o_errcode;
		END IF;

		-- Get Patient Discharge date
		SELECT COUNT(1) INTO v_Count FROM InPat WHERE InPID = p_InPID;
		IF v_Count = 1 THEN
			SELECT InpdDate INTO v_InpdDate FROM InPat WHERE InPID = p_InPID;
		END IF;

		-- check combo box
		IF v_NewBedCode IS NOT NULL AND v_AcmCode IS NOT NULL THEN
			-- IF the new bed is occupy AND the patient discharge,update bed code but don't update the two bed status
			IF v_BedSts = BED_STS_OCCUPY THEN
				IF v_InpdDate IS NOT NULL THEN
					IF p_OverrideBedYN = 'Y' THEN
						UPDATE InPat SET BedCode = p_BedCode, AcmCode = p_AcmCode WHERE InPID = p_InPID;
					ELSE
						o_errcode := -100; -- need java popup dialog
						o_errmsg := 'This Bed is being occupy now, Continue Operation?';
						ROLLBACK;
						RETURN o_errcode;
					END IF;
				ELSE
					-- IF the new bed is occupy AND the patient not discharge,don't update bed code AND Bed status
					o_errmsg := 'This Bed is being occupy now';
					ROLLBACK;
					RETURN o_errcode;
				END IF;
			ELSE
				-- IF the new bed is free AND the patient discharge,update bed code but don't update the two bed status
				-- IF the new bed is free AND the patient not discharge,update bed code AND Bed status

				UPDATE InPat SET BedCode = p_BedCode, AcmCode = p_AcmCode WHERE InPID = p_InPID;

				-- update bed status for not discharge patient
				IF v_InpdDate IS NULL THEN
					UPDATE Bed SET BedSts = BED_STS_FREE WHERE BedCode = v_OldBedCode;

					UPDATE Bed SET BedSts = BED_STS_OCCUPY WHERE BedCode = p_BedCode;
				END IF;
			END IF;
		END IF;
	ELSE
		o_errmsg := MSG_BED_LOCK;
		ROLLBACK;
		RETURN o_errcode;
	END IF;

	-- unlock bed
	v_Count := NHS_ACT_RecordUnLock(NULL, 'Bed', p_BedCode, p_ComputerName, p_UserID, o_errmsg);

	o_errcode := 0;
	RETURN o_errcode;
EXCEPTION
	WHEN OTHERS THEN
	o_errcode := -1;
	o_errmsg := 'Fail to update slip bed code.';
	ROLLBACK;
	RETURN O_ERRCODE;
end NHS_ACT_TXNBED_MODIFY;
/
