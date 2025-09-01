CREATE OR REPLACE FUNCTION NHS_RPT_RPTOUTSTDBAL (
	v_EndDate VARCHAR2,
	v_SteCode VARCHAR2,
	v_otp2  VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	DELETE FROM Diosliptemp;

	INSERT INTO Diosliptemp
	select st.slpno, SUM(stnnamt) as netamt , 'N'
	FROM   sliptx st
	WHERE (stncdate IS NULL OR stncdate >= to_date(v_EndDate, 'DD/MM/YYYY') + 1)
	AND stnsts IN ('N','A')
	GROUP BY st.slpno
	having sum(stnnamt) <> 0;

	IF v_otp2 = '1' THEN
		OPEN outcur FOR
			SELECT S.Patno, DECODE(S.patno, NULL, S.Slpfname
					|| ' '
					|| S.Slpgname, P.Patfname
					|| ' '
					|| P.patgname) AS Patname,
				S.Slpno,
				S.Slptype,
				Pc.Pcydesc,
				R.Regdate,
				(S.Slpcamt + S.Slpdamt + S.Slppamt- NVL(st.netamt,0)) AS SlpAmt,
				S.Slpremark
			FROM Slip S,
				Reg R,
				Patcat Pc,
				Patient P,
				Diosliptemp St
			WHERE S.stecode    = v_SteCode
			AND   s.slpno      = st.slpno (+)
			AND   S.Pcyid      = Pc.pcyid (+)
			AND   p.patno (+)  = S.Patno
			AND   s.slptype    <> 'O'
			AND   r.regtype    <> 'O'
			AND   s.regid      = r.regid (+)
			AND NOT ((s.slpsts = 'C'
			OR    s.slpsts     = 'R')
			AND  (slppamt + slpdamt + slpcamt - NVL(st.netamt, 0)) = 0)
			UNION ALL
			SELECT S.Patno, DECODE(S.patno, NULL, S.Slpfname
					|| ' '
					|| S.Slpgname, P.Patfname
					|| ' '
					|| P.patgname) AS Patname,
				S.Slpno,
				S.Slptype,
				Pc.Pcydesc,
				R.Regdate,
				(S.Slpcamt + S.Slpdamt + S.Slppamt- NVL(st.netamt, 0)) AS SlpAmt,
				S.SlpRemark
			FROM Slip S,
				Diosliptemp St,
				reg r,
				Patient P,
				patcat pc
			WHERE S.stecode    = v_SteCode
			AND   s.slptype    = 'O'
			AND   s.slpno      = st.slpno (+)
			AND NOT ((s.slpsts = 'C'
			OR    s.slpsts     = 'R')
			AND  (slppamt + slpdamt + slpcamt - NVL(st.netamt, 0)) = 0)
			AND   s.slpno      = r.slpno (+)
			And   S.Patno      = P.Patno (+)
			AND   S.Pcyid      = Pc.Pcyid(+)
			order by 1 NULLS FIRST, 2, 3;
	ELSE
		OPEN outcur FOR
			SELECT S.Patno, DECODE(S.patno, NULL, S.Slpfname
					|| ' '
					|| S.Slpgname, P.Patfname
					|| ' '
					|| P.patgname) AS Patname,
				S.Slpno,
				S.Slptype,
				Pc.Pcydesc,
				R.Regdate,
				(S.Slpcamt + S.Slpdamt + S.Slppamt- NVL(st.netamt,0)) AS SlpAmt,
				NULL
			FROM Slip S,
				Reg R,
				Patcat Pc,
				Patient P,
				Diosliptemp St
			WHERE S.stecode                                  = v_SteCode
			AND s.slpno                                      = st.slpno (+)
			AND S.Pcyid                                      = Pc.pcyid (+)
			AND p.patno (+)                                  = S.Patno
			AND s.slptype                                   <> 'O'
			AND r.regtype                                   <> 'O'
			AND s.regid                                      = r.regid (+)
			AND NOT ((s.slpsts                               = 'C'
			OR s.slpsts                                      = 'R')
			AND (slppamt + slpdamt + slpcamt - NVL(st.netamt, 0)) = 0)
			UNION ALL
			SELECT S.Patno, DECODE(S.patno, NULL, S.Slpfname
					|| ' '
					|| S.Slpgname, P.Patfname
					|| ' '
					|| P.patgname) AS Patname,
				S.Slpno,
				S.Slptype,
				Pc.Pcydesc,
				R.Regdate,
				(S.Slpcamt + S.Slpdamt + S.Slppamt- NVL(st.netamt, 0)) AS SlpAmt,
				S.SlpRemark
			FROM Slip S,
				Diosliptemp St,
				reg r,
				Patient P,
				patcat pc
			WHERE S.stecode    = v_SteCode
			AND   s.slptype    = 'O'
			AND   s.slpno      = st.slpno (+)
			AND NOT ((s.slpsts = 'C'
			OR    s.slpsts     = 'R')
			AND  (slppamt + slpdamt + slpcamt - NVL(st.netamt, 0)) = 0)
			AND   s.slpno      = r.slpno (+)
			And   S.Patno      = P.Patno (+)
			AND   S.Pcyid      = Pc.Pcyid(+)
			order by 1 NULLS FIRST, 2, 3;
	END IF;
	RETURN outcur;
END NHS_RPT_RPTOUTSTDBAL;
/
