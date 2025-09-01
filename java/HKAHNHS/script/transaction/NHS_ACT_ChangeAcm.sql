CREATE OR REPLACE FUNCTION "NHS_ACT_CHANGEACM" (
	i_action       IN VARCHAR2,
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
	v_oldAcmCode ACM.ACMCODE%TYPE;
	v_Outcur TYPES.CURSOR_TYPE;
BEGIN
	SLIP_TYPE_INPATIENT := 'I';

	v_StnSeq_Start := TO_NUMBER(i_StnSeq_Start);
	v_StnSeq_End := TO_NUMBER(i_StnSeq_End);
	v_strOverride := '';
	o_errcode := -1;

	for r1 in (
		SELECT PkgCode
		FROM   Sliptx
		WHERE  SlpNo = i_SlpNo
		AND    ItmType = 'D'
		AND    StnType = 'D'
		AND    PkgCode IS NOT NULL
		AND    PkgCode IN ( SELECT PkgCode FROM Sliptx WHERE StnSeq >= v_StnSeq_Start AND StnSeq <= v_StnSeq_End AND SlpNo = i_SlpNo )
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
		FROM   Sliptx
		WHERE (PkgCode NOT IN (
				SELECT PkgCode
				FROM   Sliptx
				WHERE  SlpNo = i_SlpNo
				AND    ITMTYPE = 'D'
				AND    StnType = 'D'
				AND    PKGCODE IS NOT NULL
				AND    PkgCode IN ( SELECT PkgCode FROM Sliptx WHERE StnSeq >= v_StnSeq_Start AND StnSeq <= v_StnSeq_End AND SlpNo = i_SlpNo )
				GROUP BY PkgCode
				HAVING COUNT(1) > 0)
			OR PkgCode IS NULL)
		AND    ItmType <> 'D' and StnSts = 'N' and StnType = 'D'
		AND    StnSeq >= v_StnSeq_Start
		AND    StnSeq <= v_StnSeq_End
		AND    SlpNo = i_SlpNo
	) LOOP
		SELECT COUNT(1) INTO v_COUNT FROM SLIPTX WHERE STNSTS = 'A' AND DIXREF = R2.DIXREF;

		IF v_COUNT > 0 OR (R2.STNOAMT <> R2.STNBAMT AND (LENGTH(R2.STNCPSFLAG) <= 0 OR R2.STNCPSFLAG = 'P' OR R2.STNCPSFLAG IS NULL)) THEN
			IF v_STROVERRIDE != '' THEN
				v_strOverride := v_strOverride || ',';
			END IF;
			v_STROVERRIDE := v_STROVERRIDE || R2.STNSEQ || '-' || R2.ITMCODE;
		ELSE
			SELECT ACMCODE INTO v_OLDACMCODE FROM SLIPTX WHERE STNID = R2.STNID;

			-- reCalculateCPS
			v_Outcur := NHS_UTL_CONPCECHANGE(i_SLPNO, SLIP_TYPE_INPATIENT, v_OLDACMCODE, '', i_NEWACMCODE, R2.STNID, TRUE);
			o_errcode := NHS_UTL_RECALCULATECPS(i_SLPNO, v_Outcur, i_USRID, o_errmsg);
			IF o_errcode < 0 THEN
				o_errcode := -1;
				o_errmsg := 'Invalid recalculate CPS.';
				ROLLBACK;
				RETURN o_errcode;
			END IF;
		END IF;
	END LOOP;

	-- UpdateSlip
	NHS_UTL_UPDATESLIP(i_SlpNo);

	-- SetTotalCharges

	o_errcode := 0;
	o_errmsg := v_STROVERRIDE;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_errmsg := SQLERRM || o_errmsg;

	RETURN -999;
END NHS_ACT_CHANGEACM;
/
