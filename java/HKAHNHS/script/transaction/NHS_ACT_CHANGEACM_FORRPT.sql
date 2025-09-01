CREATE OR REPLACE FUNCTION "NHS_ACT_CHANGEACM_FORRPT" (
	I_ACTION       IN VARCHAR2,
	i_SlpNo        IN VARCHAR2,
	i_newAcmcode   IN VARCHAR2,
	i_StnSeq_Start IN VARCHAR2,
	i_StnSeq_End   IN VARCHAR2,
	i_UsrId        IN VARCHAR2,
	o_errmsg       OUT VARCHAR2
)
	RETURN NUMBER
AS
	SLIP_TYPE_INPATIENT VARCHAR2(1);

	v_StnSeq_Start NUMBER;
	v_StnSeq_End NUMBER;
	v_Count NUMBER;
	o_errcode NUMBER;
	v_strOverride VARCHAR2(3000);
	v_OLDACMCODE VARCHAR2(1);
	v_OUTCUR TYPES.CURSOR_TYPE;
	v_SLPNO VARCHAR2(15);
	SQLBUF VARCHAR2(20000);
	OUTCUR TYPES.CURSOR_TYPE;

	v_NOOFREC_TEST1 NUMBER;
	v_STNID_TEST NUMBER;
	v_COUNT1 NUMBER;
BEGIN
	EXECUTE IMMEDIATE 'TRUNCATE TABLE SLIPTX_FOR_RPT';

	SQLBUF := 'SELECT SLPNO FROM SLIP WHERE SLPNO IN ('||I_SLPNO||') ORDER BY SLPNO';

	OPEN OUTCUR FOR SQLBUF;
	LOOP
		FETCH OUTCUR INTO v_SLPNO;
		EXIT WHEN OUTCUR%NOTFOUND;

		INSERT INTO SLIPTX_FOR_RPT
		SELECT *
		FROM SLIPTX
		WHERE SLPNO = v_SLPNO
		AND STNSTS NOT IN ('C','U','R');

		SELECT SLPTYPE INTO SLIP_TYPE_INPATIENT
		FROM SLIP
		WHERE SlpNo = v_SlpNo;

		IF SLIP_TYPE_INPATIENT = 'I' THEN
			dbms_output.put_line('1v_SLPNO:'||v_SLPNO);
			SELECT MIN(STNSEQ)
			INTO v_STNSEQ_START
			FROM SLIPTX_FOR_RPT
			WHERE SlpNo = v_SlpNo;

			SELECT MAX(STNSEQ)
			INTO v_StnSeq_End
			FROM SLIPTX_FOR_RPT
			WHERE SlpNo = v_SlpNo;

--			v_StnSeq_Start := TO_NUMBER(i_StnSeq_Start);
--			v_StnSeq_End := TO_NUMBER(i_StnSeq_End);
			v_strOverride := '';
			o_errcode := -1;

			for r1 in (
				SELECT PkgCode
				FROM   SLIPTX_FOR_RPT
				WHERE  SlpNo = v_SlpNo
				AND    ItmType = 'D'
				AND    StnType = 'D'
				AND    PkgCode IS NOT NULL
				AND    PkgCode IN ( SELECT PkgCode FROM SLIPTX_FOR_RPT WHERE StnSeq >= v_StnSeq_Start AND StnSeq <= v_StnSeq_End AND SlpNo = v_SlpNo )
				GROUP BY PkgCode
				HAVING COUNT(1) > 0
			) LOOP
				IF LENGTH(v_strOverride) > 0 THEN
					v_strOverride := v_strOverride || ',';
				END IF;
				v_strOverride := v_strOverride || 'Package-' || r1.PkgCode;
			END LOOP;

			for r2 in (
				SELECT StnID, StnSeq, StnCPSFlag, StnOAmt, StnBAmt, ItmCode, DIXRef
				FROM   SLIPTX_FOR_RPT
				WHERE (PkgCode NOT IN (
					SELECT PkgCode
					FROM   SLIPTX_FOR_RPT
					WHERE  SlpNo = v_SlpNo
					AND    ITMTYPE = 'D'
					AND    StnType = 'D'
					AND    PKGCODE IS NOT NULL
					AND    PkgCode IN ( SELECT PkgCode FROM SLIPTX_FOR_RPT WHERE StnSeq >= v_StnSeq_Start AND StnSeq <= v_StnSeq_End AND SlpNo = v_SlpNo )
					GROUP BY PkgCode
					HAVING COUNT(1) > 0)
					OR PkgCode IS NULL)
				AND    ItmType <> 'D' and StnSts = 'N' and StnType = 'D'
				AND    StnSeq >= v_StnSeq_Start
				AND    StnSeq <= v_StnSeq_End
				AND    SLPNO = v_SLPNO
			) LOOP
				SELECT COUNT(1) INTO v_COUNT FROM SLIPTX_FOR_RPT WHERE STNSTS = 'A' AND DIXREF = R2.DIXREF;

				IF v_COUNT > 0 OR (R2.STNOAMT <> R2.STNBAMT AND (LENGTH(R2.STNCPSFLAG) <= 0 OR R2.STNCPSFLAG = 'P' OR R2.STNCPSFLAG IS NULL)) THEN
					IF v_STROVERRIDE != '' THEN
						v_strOverride := v_strOverride || ',';
					END IF;
					v_STROVERRIDE := v_STROVERRIDE || R2.STNSEQ || '-' || R2.ITMCODE;
				ELSE
					SELECT COUNT(ACMCODE) INTO v_COUNT1 FROM SLIPTX_FOR_RPT WHERE STNID = R2.STNID;
					SELECT ACMCODE INTO v_OLDACMCODE FROM SLIPTX_FOR_RPT WHERE STNID = R2.STNID;

					-- reCalculateCPS
					v_OUTCUR := NHS_UTL_CONPCECHANGE(v_SLPNO, SLIP_TYPE_INPATIENT, v_OLDACMCODE, '', I_NEWACMCODE, R2.STNID, TRUE);
					O_ERRCODE := NHS_UTL_RECALCULATECPS_FORRPT(v_SLPNO, v_OUTCUR, I_USRID, o_errmsg);

					IF o_errcode < 0 THEN
						o_errcode := -1;
						o_errmsg := 'Invalid recalculate CPS.';
						ROLLBACK;
						RETURN o_errcode;
					END IF;
				END IF;
			END LOOP;

			-- UpdateSlip
--			NHS_UTL_UPDATESLIP(v_SlpNo);

			-- SetTotalCharges

			O_ERRCODE := 0;
			o_errmsg := v_STROVERRIDE;
		ELSE
			dbms_output.put_line('[v_SLPNO]:'||v_SLPNO||';[SLIP_TYPE_INPATIENT]:'||SLIP_TYPE_INPATIENT);
			O_ERRCODE := 0;
		END IF;
	END LOOP;
	CLOSE OUTCUR;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_errmsg := SQLERRM || o_errmsg;

	RETURN -999;
END NHS_ACT_CHANGEACM_FORRPT;
/
