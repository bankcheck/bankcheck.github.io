-- Transaction.bas / LookupGlCode
CREATE OR REPLACE FUNCTION NHS_UTL_LookupGlCode (
	a_TxDate   VARCHAR2,
	a_ItmCode  VARCHAR2,
	a_BedCode  VARCHAR2,
	a_SlpType  VARCHAR2,
	a_Credit   BOOLEAN DEFAULT FALSE,
	a_Cpsid    NUMBER,
	a_PkgCode  VARCHAR2,
	a_AcmCode  VARCHAR2,
	a_DeptCode VARCHAR2
)
	RETURN VARCHAR2
IS
	v_AcmCode CreditChg.AcmCode%TYPE;
	v_GlcCode CreditChg.GlcCode%TYPE;
	v_DptCode Ward.DptCode%TYPE;
	v_stntdate DATE;
	v_errmsg VARCHAR2(1000);
	GLCCODE_NORMAL_LENGTH NUMBER := 4;
BEGIN
	IF a_TxDate IS NOT NULL THEN
		v_stntdate := TO_DATE(a_TxDate, 'DD/MM/YYYY');
	ELSE
		v_stntdate := TRUNC(SYSDATE);
	END IF;

	IF a_AcmCode IS NOT NULL THEN
		v_AcmCode := NHS_UTL_LookupAcmCode(a_TxDate, a_AcmCode, a_ItmCode, a_PkgCode, a_Credit, a_Cpsid);
	END IF;

	IF a_Credit THEN
		FOR r IN (
			SELECT  GlcCode
			FROM    CreditChg
			WHERE   ItmCode = a_ItmCode
			AND     ItcType = a_SlpType
			AND ( ( a_Cpsid IS NULL AND TRIM(Cpsid) IS NULL ) OR ( a_Cpsid IS NOT NULL AND Cpsid = a_Cpsid ) )
			AND ( ( TRIM(a_PkgCode) IS NULL AND TRIM(PkgCode) IS NULL ) OR ( a_PkgCode IS NOT NULL AND PkgCode = a_PkgCode ) )
			AND ( ( v_AcmCode IS NULL AND TRIM(AcmCode) IS NULL ) OR ( v_AcmCode IS NOT NULL AND AcmCode = v_AcmCode ) )
			AND   ( cicsdt IS NULL OR cicsdt <= v_stntdate )
			AND   ( cicedt IS NULL OR cicedt >= v_stntdate )
		) LOOP
			v_GlcCode := r.GlcCode;
			EXIT;
		END LOOP;

		IF v_GlcCode IS NULL THEN
			FOR r IN (
				SELECT  GlcCode
				FROM    CreditChg
				WHERE   ItmCode = a_ItmCode
				AND     ItcType = a_SlpType
				AND     TRIM(Cpsid) IS NULL
				AND ( ( TRIM(a_PkgCode) IS NULL AND TRIM(PkgCode) IS NULL ) OR ( a_PkgCode IS NOT NULL AND PkgCode = a_PkgCode ) )
				AND ( ( v_AcmCode IS NULL AND TRIM(AcmCode) IS NULL ) OR ( v_AcmCode IS NOT NULL AND AcmCode = v_AcmCode ) )
				AND   ( cicsdt IS NULL OR cicsdt <= v_stntdate )
				AND   ( cicedt IS NULL OR cicedt >= v_stntdate )
			) LOOP
				v_GlcCode := r.GlcCode;
				EXIT;
			END LOOP;
		END IF;
	ELSE
		FOR r IN (
			SELECT /*+ INDEX(I IDX_ITEMCHG_102) */ GlcCode
			FROM    ItemChg
			WHERE   ItmCode = a_ItmCode
			AND     ItcType = a_SlpType
			AND ( ( a_Cpsid IS NULL AND TRIM(Cpsid) IS NULL ) OR ( a_Cpsid IS NOT NULL AND Cpsid = a_Cpsid ) )
			AND ( ( TRIM(a_PkgCode) IS NULL AND TRIM(PkgCode) IS NULL ) OR ( a_PkgCode IS NOT NULL AND PkgCode = a_PkgCode ) )
			AND ( ( v_AcmCode IS NULL AND TRIM(AcmCode) IS NULL ) OR ( v_AcmCode IS NOT NULL AND AcmCode = v_AcmCode ) )
			AND   ( itcsdt IS NULL OR itcsdt <= v_stntdate )
			AND   ( itcedt IS NULL OR itcedt >= v_stntdate )
		) LOOP
			v_GlcCode := r.GlcCode;
			EXIT;
		END LOOP;

		IF v_GlcCode IS NULL THEN
			FOR r IN (
				SELECT /*+ INDEX(I IDX_ITEMCHG_102) */ GlcCode
				FROM    ItemChg
				WHERE   ItmCode = a_ItmCode
				AND     ItcType = a_SlpType
				AND     TRIM(Cpsid) IS NULL
				AND ( ( TRIM(a_PkgCode) IS NULL AND TRIM(PkgCode) IS NULL ) OR ( a_PkgCode IS NOT NULL AND PkgCode = a_PkgCode ) )
				AND ( ( v_AcmCode IS NULL AND TRIM(AcmCode) IS NULL ) OR ( v_AcmCode IS NOT NULL AND AcmCode = v_AcmCode ) )
				AND   ( itcsdt IS NULL OR itcsdt <= v_stntdate )
				AND   ( itcedt IS NULL OR itcedt >= v_stntdate )
			) LOOP
				v_GlcCode := r.GlcCode;
				EXIT;
			END LOOP;
		END IF;
	END IF;

	IF a_DeptCode IS NULL THEN
		IF LENGTH(TRIM(v_GlcCode)) <= GLCCODE_NORMAL_LENGTH THEN
			BEGIN
				SELECT w.DptCode into v_DptCode
				from   Bed b, Room r, Ward w
				where  b.BedCode = a_BedCode
				AND    b.RomCode = r.RomCode
				AND    r.WrdCode = w.WrdCode;

				v_GlcCode := v_DptCode || v_GlcCode;
			EXCEPTION WHEN OTHERS THEN
				NULL;
			END;
		END IF;
	ELSE
		IF LENGTH(TRIM(v_GlcCode)) <= GLCCODE_NORMAL_LENGTH AND LENGTH(TRIM(v_GlcCode)) > 0 THEN
			v_GlcCode := a_DeptCode || v_GlcCode;
		END IF;
	END IF;
	RETURN v_GlcCode;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -999;
END NHS_UTL_LookupGlCode;
/
