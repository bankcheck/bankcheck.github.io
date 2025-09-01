CREATE OR REPLACE FUNCTION "NHS_LIS_DOCTOR_EXTRA"
(V_DOCCODE DOCTOR_EXTRA.DOCCODE%TYPE)
  RETURN Types.CURSOR_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN OUTCUR FOR
      SELECT
        DE.DOCCODE,D.DOCFNAME || ', ' || D.DOCGNAME, DE.SMSTEL, DE.SMSTEL2,
        DECODE(DE.SMSTYPE, '1', 'OT',
                    '2', 'IP',
                     '3', DECODE(GET_CURRENT_STECODE, 'TWAH', 'BOTH', 'ALL'),
                     '4', 'JUST ADMIT',
                    ''),
        (select listagg(HPSTATUS,',') within group(order by HPSTATUS) 
		  from HPSTATUS
		WHERE hptype = 'DSMSTYPE'
		  AND HPKEY = D.DOCCODE
		  AND HPACTIVE = -1) SMSTYPES,
		(select listagg((select HPSTATUS from hpstatus where hptype = 'DSMSTYPEC' and HPKEY = t.HPSTATUS),',') within group(order by HPSTATUS)
		  from HPSTATUS t
		WHERE t.hptype = 'DSMSTYPE'
		  AND t.HPKEY = D.DOCCODE
		  AND t.HPACTIVE = -1) SMSTYPESDESC
      FROM DOCTOR_EXTRA DE, DOCTOR D 
      WHERE DE.DOCCODE = D.DOCCODE
      AND ( DE.DOCCODE LIKE '%' || v_DOCCODE || '%')
      AND (SMSTEL IS NOT NULL OR SMSTEL2 IS NOT NULL OR SMSTYPE IS NOT NULL)
      ORDER BY DE.DOCCODE;
   RETURN OUTCUR;
END NHS_LIS_DOCTOR_EXTRA;
/


