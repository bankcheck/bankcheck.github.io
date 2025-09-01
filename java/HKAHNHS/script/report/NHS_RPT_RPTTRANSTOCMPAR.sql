CREATE OR REPLACE FUNCTION NHS_RPT_RPTTRANSTOCMPAR (
	v_SDate   IN VARCHAR2,
	v_EDate   IN VARCHAR2,
	v_SteCode IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	OUTCUR TYPES.CURSOR_TYPE;
BEGIN
	OPEN OUTCUR FOR
		SELECT
			DTL.PATNO,
			DTL.STNTYPE,
			DTL.SLPTYPENAME,
			DTL.AMT,
			DTL.NAME,
			DTL.SLPNO,
			DTL.BILLON,
			DTL.ARCCODE,
			DTL.ARCNAME,
			DTL.SLPTYPE,
			CNT.SLPCNT
		FROM
		(
			SELECT
				S.PATNO,
				ST.STNTYPE,
				s.slptype,
				decode(s.slptype,'D','Day-Case','I','In-Patient','O','Out-Patient','Unknown')slptypename,
				(atxamt) as amt,
				decode(s.patno, null, s.slpfname || ' ' || s.slpgname, p.patfname || ' ' || p.patgname) as name,
				ST.SLPNO,
				TO_CHAR(STNTDATE, 'DD/MM/YYYY') AS BILLON,
				A.ARCCODE,
				ar.arcname
			From
				sliptx st, slip s, patient p, artx a, arcode ar
			Where stntype = 'P'
			and a.ATXCDATE >= to_date(v_SDate, 'DD/MM/YYYY')
			and a.ATXCDATE < to_date(v_EDate, 'DD/MM/YYYY') + 1
			and a.slpno = s.slpno
			and a.arccode = ar.arccode
			and a.arpid is null
			and s.patno = p.patno (+)
			and s.stecode = v_SteCode
			AND A.ATXREFID = ST.STNID
			Group By
				s.slptype,s.patno, st.stntype, atxamt,
				DECODE(S.PATNO,NULL,S.SLPFNAME || ' ' || S.SLPGNAME, P.PATFNAME || ' ' || P.PATGNAME),
				ST.SLPNO, TO_CHAR(STNTDATE, 'DD/MM/YYYY'), A.ARCCODE, AR.ARCNAME, a.atxid) DTL,
				(
					SELECT SLPTYPE, COUNT(SLPTYPE) AS SLPCNT
					FROM (
						SELECT
							S.PATNO,
							ST.STNTYPE,
							s.slptype,
							(atxamt) as amt,
							decode(s.patno, null, s.slpfname || ' ' || s.slpgname, p.patfname || ' ' || p.patgname) as name,
							st.slpno, to_char(stntdate, 'DD/MM/YYYY') as billon, a.Arccode, ar.arcname
						From
							sliptx st, slip s, patient p, artx a, arcode ar
						Where STNTYPE = 'P'
						and a.ATXCDATE >= to_date(v_SDate, 'DD/MM/YYYY')
						and a.ATXCDATE < to_date(v_EDate, 'DD/MM/YYYY') + 1
						and a.slpno = s.slpno
						and a.arccode = ar.arccode
						and a.arpid is null
						AND S.PATNO = P.PATNO (+)
						and s.stecode = v_SteCode
						AND A.ATXREFID = ST.STNID
						Group By
							s.slptype,s.patno, st.stntype, atxamt,
							decode(s.patno,null,s.slpfname || ' ' || s.slpgname, p.patfname || ' ' || p.patgname),
							ST.SLPNO, TO_CHAR(STNTDATE, 'DD/MM/YYYY'), A.ARCCODE, AR.ARCNAME, a.atxid
					) GROUP BY SLPTYPE) CNT
		WHERE DTL.SLPTYPE = CNT.SLPTYPE(+)
		order by DTL.slptype,DTL.arccode,DTL.billon;

	RETURN OUTCUR;
END NHS_RPT_RPTTRANSTOCMPAR;
/
