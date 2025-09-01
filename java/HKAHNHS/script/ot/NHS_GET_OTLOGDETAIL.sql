CREATE OR REPLACE FUNCTION "NHS_GET_OTLOGDETAIL"(V_OTLID IN VARCHAR2)
  RETURN TYPES.CURSOR_TYPE AS
  OUTCUR TYPES.CURSOR_TYPE;
BEGIN
  OPEN OUTCUR FOR
    SELECT ol.OTLID,
           ol.OTAID,
           TO_CHAR(ol.OTLDATE,'DD/MM/YYYY'),
           ol.PATNO,
           s.SLPNO,
           --5
           s.SlpType,
           ol.OTLROOM,
           ol.WRDCODE,
           ol.OTLSTS,
           ol.USRID,
           --10
           ol.OTLRODATE,
           ol.USRID_1,
           ol.USRID_2,
           ol.OTLSETUP,
           TO_CHAR(ol.OTLPATIN, 'DD/MM/YYYY HH24:MI'),
           -- 15
           TO_CHAR(ol.OTLPATOUT,'DD/MM/YYYY HH24:MI'),
           TO_CHAR(ol.OTLASDATE,'DD/MM/YYYY HH24:MI'),
           TO_CHAR(ol.OTLAEDATE,'DD/MM/YYYY HH24:MI'),
           TO_CHAR(ol.OTLOSDATE,'DD/MM/YYYY HH24:MI'),
           TO_CHAR(ol.OTLOEDATE,'DD/MM/YYYY HH24:MI'),
           -- 20
           TO_CHAR(ol.OTLRCYIN, 'DD/MM/YYYY HH24:MI'),
           TO_CHAR(ol.OTLRCYOUT, 'DD/MM/YYYY HH24:MI'),
           ol.OTLCLEAN,
           ol.OTLLATE,
           TO_CHAR(ol.OTLTNQON,'DD/MM/YYYY HH24:MI'),
           -- 25
           TO_CHAR(ol.OTLTNQOFF,'DD/MM/YYYY HH24:MI'),
           ol.OTCID_BT,
           ol.OTLID_ST,
           ol.OTLOTCM,
           ol.OTLDRES,
           -- 30
           ol.OTLRESN,
           ol.OTLSPEC,
           ol.OTLSPECDEST,
           ol.OTPID,
           ol.OTLANESMETH,
           -- 35
           ol.DOCCODE_S,
           ol.DOCCODE_A,
           ol.OTLRMK,
           ol.OTLCMT,
           TO_CHAR(ol.OTPWT, 'DD/MM/YYYY HH24:MI'),
           -- 40
           ol.DOCCODE_E,
           ol.DOCCODE_R
      FROM OT_LOG ol
      JOIN SLIP s ON ol.SLPNO = s.SLPNO
     WHERE ol.OTLID = V_OTLID;
  RETURN OUTCUR;
END NHS_GET_OTLOGDETAIL;
/
