CREATE OR REPLACE FUNCTION NHS_ACT_BEDTRANSFER (
	i_action        IN VARCHAR2,
	i_BedhistID     IN VARCHAR2,
	i_RegID         IN VARCHAR2,
	i_PatNo         IN VARCHAR2,
	i_BedCode       IN VARCHAR2,
	i_StartDate	    IN VARCHAR2,
	i_EndDate	    IN VARCHAR2,
	i_DischargeDate	IN VARCHAR2,
	i_userId	    IN VARCHAR2,
	o_errmsg	    OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode	NUMBER;
	v_PrevBedID	NUMBER;
	v_count	NUMBER;
	v_PrevBedCode Bed.BedCode%TYPE;
	SQLSTR VARCHAR2(1000);

	DOCHIST_NOCHANGE VARCHAR2(1) := 'N';
	DOCHIST_CHANGED VARCHAR2(1) := 'C';
	BED_STS_FREE VARCHAR2(1) := 'F';
	BED_STS_OCCUPY VARCHAR2(1) := 'O';
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	IF i_action = 'ADD' THEN
		SELECT MAX(Bhsid) INTO v_PrevBedID FROM Bedhist where RegID = i_RegID and patno = i_PatNo;

		INSERT INTO Bedhist (
			BhsID, RegID, PatNo, BedCode, BhsDate, BhsEDate, USRID
		) VALUES (
			seq_Bedhist.NEXTVAL,
			TO_NUMBER(i_RegID),
			i_PatNo,
			i_BedCode,
			TO_DATE(i_StartDate, 'DD/MM/YYYY HH24:MI:SS'),
			TO_DATE(i_EndDate, 'DD/MM/YYYY HH24:MI:SS'),
			i_userId
		);

		IF SQL%rowcount = 0 THEN
			o_errmsg := 'insert fail.';
			o_errcode := -1;
			RETURN o_errcode;
		END IF;

		UPDATE Bed
		SET    BedSts = BED_STS_OCCUPY
		WHERE  BedCode = i_BedCode;

		IF v_PrevBedID IS NOT NULL THEN
			UPDATE Bedhist
			SET    BhsEDate = TO_DATE(i_StartDate, 'DD/MM/YYYY HH24:MI:SS')
			WHERE  bhsid = v_PrevBedID;
		END IF;
	ELSIF i_action = 'MOD' THEN
		SQLSTR := 'UPDATE Bedhist SET BedCode = ''' || i_BedCode || '''';

		IF i_StartDate IS NOT NULL THEN
			SQLSTR := SQLSTR || ', BhsDate = TO_DATE('''||i_StartDate||''', ''DD/MM/YYYY HH24:MI:SS'')';
		END IF;

		IF i_EndDate IS NOT NULL THEN
			SQLSTR := SQLSTR || ', BhsEDate = TO_DATE('''||i_EndDate||''', ''DD/MM/YYYY HH24:MI:SS'')';
		END IF;

		SQLSTR := SQLSTR || ' WHERE BhsID = '''||i_BedhistID||'''';

		EXECUTE IMMEDIATE SQLSTR;

		IF SQL%rowcount = 0 THEN
			o_errmsg := 'update fail.';
			o_errcode := -1;
			return o_errcode;
		END IF;

		IF i_DischargeDate IS NULL OR i_DischargeDate = '' THEN
			SELECT bedcode INTO v_PrevBedCode
			FROM   Bedhist
			WHERE  bhsid = i_BedhistID;

			IF v_PrevBedCode IS NOT NULL THEN
				UPDATE Bed
				SET    BedSts = BED_STS_FREE
				WHERE  BedCode = v_PrevBedCode;
			END IF;
				UPDATE Bed
				SET    BedSts = BED_STS_OCCUPY
				WHERE  BedCode = i_BedCode;
		END IF;
	ELSE
		o_errmsg := 'invalid action.';
        o_errcode := -1;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	o_errmsg := SQLERRM;
	o_errcode := -1;
	RETURN o_errcode;
END NHS_ACT_BEDTRANSFER;
/
