CREATE OR REPLACE FUNCTION "NHS_LIS_OTLOG" (
	V_OTLID IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	SQLSTR VARCHAR2(2000);
	OUTCUR TYPES.CURSOR_TYPE;
BEGIN

	OPEN OUTCUR FOR
		SELECT /*+ ORDERED */  ol.otlid,
			p.patno,
			to_char(OL.otldate, 'dd/mm/yyyy'),
			ol.OTLROOM,
			ol.OTLSETUP,
			s.SlpType,
			to_char(ol.OTLPATIN, 'dd/mm/yyyy'), to_char(ol.OTLPATOUT, 'dd/mm/yyyy'),
			to_char(ol.OTLASDATE,'dd/mm/yyyy'), to_char(ol.OTLAEDATE, 'dd/mm/yyyy'),
			to_char(ol.OTLOSDATE, 'dd/mm/yyyy'), to_char(ol.OTLOEDATE, 'dd/mm/yyyy'),
			to_char(OL.OTLRCYIN, 'dd/mm/yyyy'), to_char(OL.OTLRCYOUT, 'dd/mm/yyyy'),
			to_char(ol.OTPWT, 'dd/mm/yyyy'), OL.WRDCODE,
			ol.OTLCLEAN,
			ol.OTLLATE,
			OL.SLPNO
		FROM OT_LOG OL, PATIENT P, SLIP S, OT_PROC OP, Doctor sd, Doctor ad, Doctor ed
		WHERE
			OL.PATNO = P.PATNO AND
			OL.OTPID = OP.OTPID AND
			ol.docCode_s = sd.docCode(+) AND
			ol.docCode_a = ad.docCode AND ol.docCode_e = ed.docCode(+) and
			S.SLPNO = OL.SLPNO AND
			S.PATNO = OL.PATNO AND
			OL.OTLID = V_OTLID;
	RETURN OUTCUR;

END NHS_LIS_OTLOG;
/
