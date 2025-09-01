create or replace
FUNCTION HAT_BED_STATUS ( v_date varchar2, v_datenumStr varchar2 )
RETURN TYPES.CURSOR_TYPE
AS
  OUTCUR TYPES.CURSOR_TYPE;
  v_datefrom date;
  v_dateto date;
  v_datecurr date;
  v_modifieddiff float;
  v_datenum integer;
  v_indicator integer;
  v_return integer;
BEGIN
  v_datenum := TO_NUMBER(v_datenumStr);
  v_datefrom := TO_DATE(v_date, 'dd/mm/yyyy');
  v_dateto := v_datefrom + (v_datenum - 1);
  v_modifieddiff := 0.00;
  v_return := 0;

  -- only call sp if more than 3 days
  --IF v_datefrom > TRUNC(SYSDATE) + 3 THEN
    -- check timestamp
    FOR v_indicator IN 0..(v_datenum - 1)
    LOOP
      IF v_return = 0 THEN
        v_datecurr := v_datefrom + v_indicator;

        SELECT MIN(HAT_MODIFIED_DATE) - SYSDATE INTO v_modifieddiff
        FROM   HAT_BED_STAT
        WHERE  HAT_PERIOD = v_datecurr;

        -- set buffer time to 10 seconds
        IF v_modifieddiff IS NULL OR v_modifieddiff * 86400 < -10 THEN
          v_return := 1;
        END IF;
      END IF;
    END LOOP;

    -- not update if less then 5 minute
    IF v_return = 1 THEN
      -- set default to 4 days
      IF v_datenum = 1 THEN
        v_datenum := 4;
      END IF;
      v_return := HAT_BED_STATUS_HELPER( v_datenum, v_datefrom );
    END IF;
  --END IF;

  -- output
  OPEN OUTCUR FOR
    SELECT HAT_PERIOD, HAT_ACMCODE, HAT_WRDCODE, HAT_TOTAL, HAT_BOOKED, HAT_BOOKED - HAT_BOOKED_OT - HAT_BOOKED_CCIC + HAT_BOOKED_BOTH, HAT_BOOKED_OT, HAT_BOOKED_CCIC, HAT_OCCUPIED, HAT_AVAILABLE, HAT_AVAILABLE_X, HAT_AVAILABLE_M, HAT_AVAILABLE_F
    FROM   HAT_BED_STAT
    WHERE  HAT_PERIOD BETWEEN TRUNC(v_datefrom) AND TRUNC(v_dateto)
    ORDER BY HAT_PERIOD, HAT_ACMCODE, HAT_WRDCODE_ORDER, HAT_WRDCODE;
  RETURN OUTCUR;
END;
/