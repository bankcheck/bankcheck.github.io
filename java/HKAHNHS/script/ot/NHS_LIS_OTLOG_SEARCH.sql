CREATE OR REPLACE FUNCTION "NHS_LIS_OTLOG_SEARCH" (
  V_PATNO IN VARCHAR2,
  V_OPDATE_FROM IN VARCHAR2,
  V_OPDATE_TO IN VARCHAR2,
  V_OTLSTS IN VARCHAR2,
  V_SLPTYPE IN VARCHAR2,
  V_OTPCODE IN VARCHAR2,
  V_SURGEON IN VARCHAR2,
  V_ANESTH IN VARCHAR2,
  V_ENDO IN VARCHAR2
)
  RETURN TYPES.CURSOR_TYPE
AS
  SQLSTR VARCHAR2(2000);
  OUTCUR TYPES.CURSOR_TYPE;
BEGIN

  SQLSTR := 'SELECT /*+ ORDERED */  '' '' as allergy,
          ol.otlid,
          to_char(OL.otldate, ''dd/mm/yyyy''),
          to_char(otlosdate, ''hh:mi:ss'') as starting,
          to_char(otloedate, ''hh:mi:ss'') as ending,
          p.patno,
          p.PATFNAME || '' '' || p.PATGNAME AS PATNAME,
          s.SlpType,
          TRUNC(TRUNC(MONTHS_BETWEEN(SYSDATE, P.PATBDATE)) / 12) AS Age,
          OP.OTPCODE,
          sd.docFName || '' '' || sd.docGName as surgeon,
          ad.docFName || '' '' || ad.docGName as anesth,
          ed.docFName || '' '' || ed.docGName as Endo,
          OL.OTLSTS,
          ol.otlcmt as remark
         FROM OT_LOG OL, PATIENT P, SLIP S, OT_PROC OP, Doctor sd, Doctor ad, Doctor ed
         WHERE     OL.PATNO = P.PATNO AND
                  OL.OTPID = OP.OTPID AND
                  ol.docCode_s = sd.docCode(+) AND
                  ol.docCode_a = ad.docCode AND ol.docCode_e = ed.docCode(+) and
                  S.SLPNO = OL.SLPNO AND
                  S.PATNO = OL.PATNO';

	IF V_PATNO IS NOT NULL THEN
			SQLSTR := SQLSTR || ' AND p.patno= ''' || V_PATNO || '''';
	END IF;

	IF V_OPDATE_FROM IS NOT NULL THEN
      --AND OL.otldate >= to_date('01/01/2012', 'dd/mm/yyyy')
			SQLSTR := SQLSTR || ' AND OL.otldate >= to_date(''' || V_OPDATE_FROM || ''', ''dd/mm/yyyy'')';
	END IF;

	IF V_OPDATE_TO IS NOT NULL THEN
      SQLSTR := SQLSTR || ' AND OL.otldate <= to_date(''' || V_OPDATE_TO || ' 23:59:59'', ''dd/mm/yyyy hh24:mi:ss'')';
	END IF;

	IF V_OTLSTS IS NOT NULL THEN
			SQLSTR := SQLSTR || ' AND OL.OTLSTS= ''' || V_OTLSTS || '''';
	END IF;

	IF V_SLPTYPE IS NOT NULL THEN
			SQLSTR := SQLSTR || ' AND S.SLPTYPE= ''' || V_SLPTYPE || '''';
	END IF;

	IF V_OTPCODE IS NOT NULL THEN
			SQLSTR := SQLSTR || ' AND OP.OTPCODE = ''' || V_OTPCODE  || '''';
	END IF;

  IF V_SURGEON IS NOT NULL THEN
			SQLSTR := SQLSTR || ' AND SD.DOCCODE = ''' || V_SURGEON  || '''';
	END IF;

  IF V_ANESTH IS NOT NULL THEN
			SQLSTR := SQLSTR || ' AND AD.DOCCODE = ''' || V_ANESTH  || '''';
	END IF;

  IF V_ENDO IS NOT NULL THEN
			SQLSTR := SQLSTR || ' AND ED.DOCCODE = ''' || V_ENDO  || '''';
	END IF;

  OPEN OUTCUR FOR SQLSTR;
  RETURN OUTCUR;

END NHS_LIS_OTLOG_SEARCH;
/
