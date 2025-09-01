create or replace
FUNCTION      "NHS_LIS_DEPOSIT"(
	v_Type   IN VARCHAR2,
	v_Patno  IN VARCHAR2,
	v_Status IN VARCHAR2,
	v_Fname  IN VARCHAR2,
	v_Gname  IN VARCHAR2,
	v_Slipno IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
BEGIN
	IF V_TYPE = 'slip' THEN
		IF V_PATNO IS NOT NULL THEN
			OPEN OUTCUR FOR
				SELECT '', SLPNO, SLPTYPE, SLPSTS
				FROM SLIP
				WHERE SLPSTS = 'A'
				AND PATNO = V_PATNO;
		ELSE
	   		OPEN OUTCUR FOR
				SELECT '', SLPNO, SLPTYPE, SLPSTS
				FROM SLIP
				WHERE SLPSTS = 'A'
				AND (SLPFNAME = V_FNAME)
				AND (SLPGNAME = V_GNAME)
				AND  PATNO IS NULL;
		END IF;
	ELSIF v_Type = 'pay' THEN
		OPEN OUTCUR FOR
			SELECT '',
				ST.STNNAMT,
				ST.USRID,
				DT.REFNO,
				TO_CHAR(ST.STNCDATE, 'DD/MM/YYYY'),
				TO_CHAR(DT.CTNTDATE, 'DD/MM/YYYY'),
				ST.STNDESC,
				DECODE(ST.STNTYPE, 'S', DT.CTNCTYPE, 'P', '') AS CTNCTYPE,
				DECODE(ST.STNTYPE, 'S', DT.CTNCNO, 'P', '') AS CTNCNO,
				DECODE(ST.STNTYPE, 'S', DT.CTNHOLD, 'P', '') AS CTNHOLD,
				DECODE(ST.STNTYPE, 'S', CTNTRACE, 'P', '') AS CTNTRACE,
				ST.STNID,
				ST.STNSEQ,
				ST.ITMCODE,
				ST.DOCCODE
			FROM SLIPTX ST, CASHTX CT, CARDTX DT
			WHERE ST.STNXREF = CT.CTXID(+)
			AND CT.CTNID = DT.CTNID(+)
			AND ST.STNTYPE IN ('S', 'P')
			AND STNSTS IN ('N', 'A')
			AND ST.SLPNO = v_Slipno;
	ELSE
		IF V_PATNO IS NOT NULL THEN
			OPEN OUTCUR FOR
		  		SELECT '',
					D.SLPNO_S AS SLPNO,
					D.ITMCODE,
					D.DPSSTS,
					D.DPSAMT,
					TO_CHAR(D.DPSTDATE, 'DD/MM/YYYY'),
					D.DPSID,
					S.Patno,
          			St.Stndesc1
		  		FROM  DEPOSIT D, SLIP S, SLIPTX ST
		  		WHERE D.SLPNO_S = S.SLPNO
          And D.Slpno_S = St.Slpno
          AND D.dpsid = st.StnXRef
		  		AND   S.PATNO = v_Patno
		  		AND  (v_Status IS NULL OR D.DPSSTS = v_Status)
--				AND  (S.SLPFNAME = v_Fname OR v_Fname IS NULL)
--				AND  (S.SLPGNAME = v_Gname OR v_Gname IS NULL)
		  		ORDER BY SLPNO_S;
		ELSE
			OPEN OUTCUR FOR
		  		SELECT '',
					D.SLPNO_S AS SLPNO,
					D.ITMCODE,
					D.DPSSTS,
					D.DPSAMT,
					TO_CHAR(D.DPSTDATE, 'DD/MM/YYYY'),
					D.Dpsid,
					S.PATNO,
          			St.Stndesc1        
		  		FROM  DEPOSIT D, SLIP S, SLIPTX ST
		  		Where D.Slpno_S = S.Slpno
          And D.Slpno_S = St.Slpno
          AND D.dpsid = st.StnXRef
--				AND   S.PATNO = v_Patno
		  		AND  (v_Status IS NULL OR D.DPSSTS = v_Status)
		  		AND  (S.SLPFNAME = v_Fname)
		  		AND  (S.SLPGNAME = v_Gname)
		  		ORDER BY SLPNO_S;
		END IF;
	END IF;

	RETURN OUTCUR;
END NHS_LIS_DEPOSIT;
/
