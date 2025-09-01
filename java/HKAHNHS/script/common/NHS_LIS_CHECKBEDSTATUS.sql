CREATE OR REPLACE FUNCTION NHS_LIS_CHECKBEDSTATUS (
	i_BedStatus    IN VARCHAR2,
	i_BedCode      IN VARCHAR2,
	i_Sex          IN VARCHAR2,
	i_ComputerName IN VARCHAR2,
	i_UsrID        IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	o_errcode NUMBER;
	o_errmsg VARCHAR2(1000) := 'OK';
	v_record NUMBER;
	v_lockusrid VARCHAR2(10);
	v_lockmac VARCHAR2(20);
	ls_sex VARCHAR2(1);
	ls_bedCode BED.BEDCODE%TYPE;
	ls_bedddate date;
	OUTCUR TYPES.CURSOR_TYPE;
	BED_OK NUMBER := 0;
	BED_NOT_AVAILABLE NUMBER := 1;
	BED_WRONG_SEX NUMBER := 2;
	BED_NOT_CLEAN NUMBER := 3;

	MSG_WRONG_BEDCODE VARCHAR2(17) := 'Invalid Bed Code.';
	MSG_BED_UNAVAILABLE VARCHAR2(31) := 'The selected bed is unavailable';
	MSG_BED_WRONG_SEX VARCHAR2(77) := 'Room''s sex and patient''s sex is not match, continue assign the selected bed ?';
	MSG_BED_UNCLEAN VARCHAR2(55) := 'The room is unclean, continue assign the selected bed ?';

BEGIN
	BEGIN
		BEGIN
			o_errcode := NHS_ACT_RECORDLOCK('ADD', 'Bed', i_BedCode, i_ComputerName, i_UsrID, o_errmsg);
			IF o_errcode <> 0 THEN
				o_errcode := 200;
				OPEN OUTCUR FOR
					SELECT o_errcode, o_errmsg FROM DUAL;
				RETURN OUTCUR;
			END IF;

			o_errcode := NHS_ACT_RECORDUNLOCK('ADD', 'Bed', i_BedCode, i_ComputerName, i_UsrID, O_ERRMSG);
		EXCEPTION
		WHEN OTHERS THEN
			o_errcode := 200;
			O_ERRMSG := SQLERRM;
		END;

		SELECT COUNT(1) INTO v_record
		FROM   bed b, room r
		WHERE  b.romcode = r.romcode
		AND    b.bedcode = i_BedCode
		AND    b.BedSts  = i_BedStatus
		AND   (b.BEDREMARK IS NULL OR b.BEDREMARK NOT LIKE 'Invalid%');

		IF v_record = 0 THEN
			o_errcode := 200;
			O_ERRMSG := MSG_WRONG_BEDCODE;
		ELSE
			SELECT r.romsex, b.bedcode, b.bedddate
			INTO   ls_sex, ls_bedCode, ls_bedddate
			FROM   bed b, room r
			WHERE  b.romcode = r.romcode
			AND    b.bedcode = i_BedCode
			AND    b.BedSts  = i_BedStatus;

			IF i_Sex = 'M' AND instr('MUY', ls_sex) <= 0 THEN
				o_errcode := BED_WRONG_SEX;
				o_errmsg := MSG_BED_WRONG_SEX;
			ELSIF i_Sex = 'F' AND instr('FUZ', ls_sex) <= 0 THEN
				o_errcode := BED_WRONG_SEX;
				o_errmsg := MSG_BED_WRONG_SEX;
			ELSIF TRUNC(SYSDATE,'MI') - (ls_bedddate + 45 / 1440) < 0 THEN
				o_errcode := BED_NOT_CLEAN;
				o_errmsg := MSG_BED_UNCLEAN;
			ELSE
				o_errcode := BED_OK;
			END IF;
		END IF;
	EXCEPTION
	WHEN OTHERS THEN
		o_errcode := BED_NOT_AVAILABLE;
		o_errmsg := 'MSG_BED_UNAVAILABLE' || SQLERRM || o_ERRMSG;
	END;

	OPEN OUTCUR FOR
	SELECT o_errcode, o_errmsg FROM DUAL;

	RETURN OUTCUR;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ERRMSG := SQLERRM || o_ERRMSG;

	o_errcode := -999;
	OPEN OUTCUR FOR
	SELECT o_errcode, o_errmsg FROM DUAL;

	RETURN OUTCUR;
END NHS_LIS_CHECKBEDSTATUS;
/
