create or replace
FUNCTION HAT_WARD_STATUS ( v_date varchar2, v_wrdCode varchar2 )
RETURN TYPES.CURSOR_TYPE
AS
  OUTCUR TYPES.CURSOR_TYPE;
  v_datecurr date;
  v_modifieddiff float;
  v_return integer;
BEGIN
  v_datecurr := TO_DATE(v_date, 'dd/mm/yyyy');
  v_modifieddiff := 0.00;

  SELECT MIN(HAT_MODIFIED_DATE) - SYSDATE INTO v_modifieddiff
  FROM   HAT_BED_STAT
  WHERE  HAT_PERIOD = v_datecurr;

  -- set buffer time to 10 seconds
  IF v_modifieddiff IS NULL OR v_modifieddiff * 86400 < -10 THEN
    v_return := HAT_BED_STATUS_HELPER( 2, v_datecurr );
  END IF;

  -- output
  OPEN OUTCUR FOR
   SELECT HBB.HAT_WRDCODE, W.WRDNAME, HBB.HAT_ACMCODE, A.ACMNAME, HBB.HAT_ROMCODE, HBB.HAT_BEDCODE,
           DECODE(HBB.HAT_STATUS, 'F', 'Occupied', 'B', 'Booked', (DECODE(HBB2.HAT_STATUS, 'B', 'Booked Tomorrow'))),
           HBB.HAT_PATNAME,
           DECODE(HBB.HAT_BEDSEX, 'M', 'Male', 'F', 'Female', 'U', ''),
           DECODE(HBB.HAT_ENABLED, NULL, 0, HBB.HAT_ENABLED)
   FROM   HAT_BED_DETAIL HBB, HAT_BED_DETAIL HBB2, WARD@IWEB W, ACM@IWEB A
   WHERE  HBB.HAT_WRDCODE = W.WRDCODE
   AND    HBB.HAT_ACMCODE = A.ACMCODE
   AND    HBB.HAT_PERIOD = v_dateCurr
   AND    HBB.HAT_WRDCODE = v_wrdCode
   AND    HBB2.HAT_BEDCODE = HBB.HAT_BEDCODE
   AND    HBB2.HAT_PERIOD = v_dateCurr + 1
   AND    W.WRDNAME not like '%CLOSED%'
   ORDER BY HBB.HAT_WRDCODE, HBB.HAT_ACMCODE, HBB.HAT_ROMCODE, HBB.HAT_BEDCODE;
  RETURN OUTCUR;
END;
/