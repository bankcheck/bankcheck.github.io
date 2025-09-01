--------------------------------------------------------------------------------
-- Table: HAT_BED_STAT - group data for each ward and acm
-- Table: HAT_BED_DETAIL - bed status
--        (HAT_STATUS - 'R': Renovation; 'X': Booked for patient; 'U': Unblock
-- Table: HAT_BED_BOOKED_TMP - temp table for bed status
--        (HAT_STATUS - 'B': Booked; 'F': Occupied; 'C': Dicharged
--------------------------------------------------------------------------------
create or replace
FUNCTION HAT_BED_STATUS_HELPER ( v_datenum integer, v_datefrom date )
RETURN integer
AS
  CURSOR c_RSacmCode IS SELECT ACMCODE FROM ACM@IWEB;
  CURSOR c_RSwrdCode IS SELECT WRDCODE FROM WARD@IWEB WHERE WRDCODE <> 'DC';
  v_dateto date;
  v_dateCurr date;
  v_dateNow date;
  v_regdate date;
  v_inpddate date;
  v_indicator integer;
  v_indicator2 integer;
  v_defaultLen integer;
  v_stayLen integer;
  v_eststaylen integer;
  v_calstayLen integer;
  v_dateCurrRange integer;
  v_maleAvailable integer;
  v_femaleAvailable integer;
  v_bothAvailable integer;
  v_pbpid integer;
  v_acmCode varchar2(1);
  v_wrdCode varchar2(2);
  v_regSts varchar2(1);
  v_sex varchar2(1);
  v_patno varchar2(10);
  v_doccode varchar2(4);
  v_bedcode varchar2(4);
  v_status varchar2(1);
BEGIN
  v_indicator := 0;
  v_defaultLen := 3;
  v_maleAvailable := 0;
  v_femaleAvailable := 0;
  v_bothAvailable := 0;
  v_dateto := v_datefrom + (v_datenum - 1);
  v_dateNow := TRUNC(SYSDATE);
  IF v_dateNow BETWEEN v_datefrom AND v_dateto + 1 THEN
    v_dateCurrRange := 1;
  ELSE
    v_dateCurrRange := 0;
  END IF;

  --------------------------------------------------------------------------------
  -- Step 1. insert dummy record in the beginning
  --------------------------------------------------------------------------------
  FOR v_indicator IN 0..(v_datenum - 1)
  LOOP
    v_dateCurr := v_datefrom + v_indicator;
    FOR v_acmCode IN c_RSacmCode
    LOOP
      FOR v_wrdCode IN c_RSwrdCode
      LOOP
        --------------------------------------------------------------------------------
        -- Step 1.1. insert for all ward
        --------------------------------------------------------------------------------
        BEGIN
          INSERT INTO HAT_BED_STAT (HAT_PERIOD, HAT_WRDCODE, HAT_ACMCODE)
          VALUES (v_dateCurr, v_wrdCode.WRDCODE, v_acmCode.ACMCODE);
        EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN
            UPDATE HAT_BED_STAT
            SET    HAT_TOTAL = 0, HAT_BOOKED = 0,
                   HAT_BOOKED_OT = 0, HAT_BOOKED_CCIC = 0, HAT_BOOKED_BOTH = 0,
                   HAT_OCCUPIED = 0, HAT_AVAILABLE = 0,
                   HAT_AVAILABLE_M = 0, HAT_AVAILABLE_F = 0, HAT_AVAILABLE_X = 0,
                   HAT_MODIFIED_DATE = SYSDATE
            WHERE  HAT_PERIOD = v_dateCurr
            AND    HAT_WRDCODE = v_wrdCode.WRDCODE
            AND    HAT_ACMCODE = v_acmCode.ACMCODE;
        END;
      END LOOP;

      --------------------------------------------------------------------------------
      -- Step 1.2. insert dummy for OT
      --------------------------------------------------------------------------------
      BEGIN
        INSERT INTO HAT_BED_STAT (HAT_PERIOD, HAT_WRDCODE, HAT_ACMCODE)
        VALUES (v_dateCurr, 'OT', v_acmCode.ACMCODE);
      EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
          UPDATE HAT_BED_STAT
          SET    HAT_TOTAL = 0, HAT_BOOKED = 0,
                 HAT_BOOKED_OT = 0, HAT_BOOKED_CCIC = 0, HAT_BOOKED_BOTH = 0,
                 HAT_OCCUPIED = 0, HAT_AVAILABLE = 0,
                 HAT_MODIFIED_DATE = SYSDATE
          WHERE  HAT_PERIOD = v_dateCurr
          AND    HAT_WRDCODE = 'OT'
          AND    HAT_ACMCODE = v_acmCode.ACMCODE;
      END;

      --------------------------------------------------------------------------------
      -- Step 1.3. insert dummy for CCIC
      --------------------------------------------------------------------------------
      BEGIN
        INSERT INTO HAT_BED_STAT (HAT_PERIOD, HAT_WRDCODE, HAT_ACMCODE)
        VALUES (v_dateCurr, 'CCIC', v_acmCode.ACMCODE);
      EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
          UPDATE HAT_BED_STAT
          SET    HAT_TOTAL = 0, HAT_BOOKED = 0,
                 HAT_BOOKED_OT = 0, HAT_BOOKED_CCIC = 0, HAT_BOOKED_BOTH = 0,
                 HAT_OCCUPIED = 0, HAT_AVAILABLE = 0,
                 HAT_MODIFIED_DATE = SYSDATE
          WHERE  HAT_PERIOD = v_dateCurr
          AND    HAT_WRDCODE = 'CCIC'
          AND    HAT_ACMCODE = v_acmCode.ACMCODE;
      END;
    END LOOP;

    --------------------------------------------------------------------------------
    -- Step 1.4. insert dump for each bed
    --------------------------------------------------------------------------------
    BEGIN
      INSERT INTO HAT_BED_DETAIL (HAT_PERIOD, HAT_WRDCODE, HAT_ACMCODE, HAT_ROMCODE,
             HAT_BEDCODE, HAT_BEDSEX, HAT_PATNAME, HAT_PATCNAME, HAT_DOCCODE, HAT_STATUS, HAT_NEED_UNBLOCK)
      SELECT v_dateCurr, W.WRDCODE, R.ACMCODE, R.ROMCODE, B.BEDCODE, 'U', '', '', '', '', 'N'
      FROM   WARD@IWEB W, ROOM@IWEB R, BED@IWEB B
      WHERE  W.WRDCODE = R.WRDCODE
      AND    R.ROMCODE = B.ROMCODE
      AND    B.BEDOFF = -1
      AND    R.WRDCODE <> 'DC';
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        UPDATE HAT_BED_DETAIL
        SET    HAT_BEDSEX = 'U',
               HAT_PATNAME = '', HAT_PATCNAME = '',
               HAT_DOCCODE = '', HAT_STATUS = '', HAT_NEED_UNBLOCK = 'N',
               HAT_MODIFIED_DATE = SYSDATE
        WHERE  HAT_PERIOD = v_dateCurr;
    END;
  END LOOP;

  --------------------------------------------------------------------------------
  -- Step 2. get bed previous status
  --------------------------------------------------------------------------------
  FOR rlDetailLog IN  (
    SELECT HAT_PERIOD, HAT_WRDCODE, HAT_ACMCODE, HAT_ROMCODE, HAT_BEDCODE, HAT_STATUS
    FROM   HAT_BED_DETAIL_LOG
    WHERE  HAT_PERIOD <= v_dateto
    AND    HAT_STATUS IN ('R', 'X', 'U', 'D')
    ORDER BY HAT_CREATED_DATE )
  LOOP
    UPDATE HAT_BED_DETAIL
    SET    HAT_ENABLED = DECODE(rlDetailLog.HAT_STATUS, 'R', 0, 'X', 0, 1),
           HAT_NEED_UNBLOCK = DECODE(rlDetailLog.HAT_STATUS, 'X', 'Y', 'N')
    WHERE  HAT_PERIOD >= rlDetailLog.HAT_PERIOD
    AND    HAT_WRDCODE = rlDetailLog.HAT_WRDCODE
    AND    HAT_ROMCODE = rlDetailLog.HAT_ROMCODE
    AND    HAT_BEDCODE = rlDetailLog.HAT_BEDCODE;
  END LOOP;

  --------------------------------------------------------------------------------
  -- Step 3. clean up temp table
  --------------------------------------------------------------------------------
  DELETE FROM HAT_BED_BOOKED_TMP;

  --------------------------------------------------------------------------------
  -- Step 4.1. insert bed booked from booked
  --------------------------------------------------------------------------------
  FOR rlBookNo1 IN (
    SELECT WRDCODE, ACMCODE, BPBHDATE, BEDCODE, PATNO, BPBPNAME, BPBCNAME, SEX, DOCCODE, ESTSTAYLEN,
           DECODE(CABLABRMK, NULL, 0, 1) booked_ccic,
           PBPID
    FROM   BEDPREBOK@IWEB
    WHERE (((ESTSTAYLEN IS NULL OR ESTSTAYLEN = 0) AND BPBHDATE BETWEEN v_datefrom - v_defaultLen AND v_dateto + 1)
    OR     (ESTSTAYLEN IS NOT NULL AND BPBHDATE BETWEEN v_datefrom - ESTSTAYLEN AND v_dateto + 1))
    AND    BPBSTS NOT IN ('F', 'D')
    AND    WRDCODE IS NOT NULL
    AND    ACMCODE IS NOT NULL)
  LOOP
    v_stayLen := rlBookNo1.ESTSTAYLEN;
    IF v_stayLen IS NULL OR v_stayLen = 0 THEN
      -- set default length
      v_stayLen := v_defaultLen;
    END IF;

    -- only count today or after
    IF TRUNC(rlBookNo1.BPBHDATE) >= v_dateNow THEN
      FOR v_indicator IN 0..(v_stayLen - 1)
      LOOP
        -- insert bed booked
        INSERT INTO HAT_BED_BOOKED_TMP (HAT_PERIOD, HAT_WRDCODE, HAT_ACMCODE, HAT_ROMCODE, HAT_BEDCODE, HAT_BEDSEX, HAT_BOOKED_OT,
                                        HAT_BOOKED_CCIC, HAT_PBPID, HAT_PATNO, HAT_PATNAME, HAT_PATCNAME, HAT_DOCCODE, HAT_STATUS)
        VALUES(TRUNC(rlBookNo1.BPBHDATE) + v_indicator, rlBookNo1.WRDCODE, rlBookNo1.ACMCODE, 'XXX', rlBookNo1.BEDCODE, rlBookNo1.SEX, 0,
               rlBookNo1.booked_ccic, rlBookNo1.PBPID, rlBookNo1.PATNO, rlBookNo1.BPBPNAME, rlBookNo1.BPBCNAME, rlBookNo1.DOCCODE, 'B');
      END LOOP;
    END IF;
  END LOOP;

  --------------------------------------------------------------------------------
  -- Step 4.2. insert bed booked from booked without acmcode
  --------------------------------------------------------------------------------
  FOR rlBookNo2 IN (
    SELECT WRDCODE, ACMCODE, BPBHDATE, BEDCODE, PATNO, BPBPNAME, BPBCNAME, SEX, DOCCODE, ESTSTAYLEN,
           DECODE(CABLABRMK, NULL, 0, 1) booked_ccic,
           PBPID
    FROM   BEDPREBOK@IWEB
    WHERE (((ESTSTAYLEN IS NULL OR ESTSTAYLEN = 0) AND BPBHDATE BETWEEN v_datefrom - v_defaultLen AND v_dateto + 1)
    OR     (ESTSTAYLEN IS NOT NULL AND BPBHDATE BETWEEN v_datefrom - ESTSTAYLEN AND v_dateto + 1))
    AND    BPBSTS NOT IN ('F', 'D')
    AND    WRDCODE IS NOT NULL
    AND    ACMCODE IS NULL)
  LOOP
    v_stayLen := rlBookNo2.ESTSTAYLEN;
    IF v_stayLen IS NULL OR v_stayLen = 0 THEN
      -- set default length
      v_stayLen := v_defaultLen;
    END IF;

    -- only count today or after (set acmcode = 'T' for standard)
    IF TRUNC(rlBookNo2.BPBHDATE) >= v_dateNow THEN
      FOR v_indicator IN 0..(v_stayLen - 1)
      LOOP
        -- insert bed booked
        INSERT INTO HAT_BED_BOOKED_TMP (HAT_PERIOD, HAT_WRDCODE, HAT_ACMCODE, HAT_ROMCODE, HAT_BEDCODE, HAT_BEDSEX, HAT_BOOKED_OT,
                                        HAT_BOOKED_CCIC, HAT_PBPID, HAT_PATNO, HAT_PATNAME, HAT_PATCNAME, HAT_DOCCODE, HAT_STATUS)
        VALUES(TRUNC(rlBookNo2.BPBHDATE) + v_indicator, rlBookNo2.WRDCODE, 'T', 'XXX', rlBookNo2.BEDCODE, rlBookNo2.SEX, 0,
               rlBookNo2.booked_ccic, rlBookNo2.PBPID, rlBookNo2.PATNO, rlBookNo2.BPBPNAME, rlBookNo2.BPBCNAME, rlBookNo2.DOCCODE, 'B');
      END LOOP;
    END IF;
  END LOOP;

  --------------------------------------------------------------------------------
  -- Step 4.3. insert bed booked from occupied no (still in hospital)
  --------------------------------------------------------------------------------
  FOR rlOccupiedNo1 IN (
    SELECT I.INPID, I.ACMCODE, I.INPDDATE, I.BEDCODE, 'F' v_status
    FROM   INPAT@IWEB I
    WHERE  I.ACMCODE IS NOT NULL
    AND   (I.INPDDATE IS NULL
    OR     I.INPDDATE > v_dateto) )
  LOOP
    SELECT COUNT(1) INTO v_indicator
    FROM   REG@IWEB R
    WHERE  R.INPID = rlOccupiedNo1.INPID
    AND    R.REGSTS = 'N';

    IF v_indicator = 1 THEN
      SELECT R.PBPID, R.REGDATE, R.PATNO, R.DOCCODE, v_dateNow - TRUNC(R.REGDATE), P.SEX, P.ESTSTAYLEN
      INTO   v_pbpid, v_regdate, v_patno, v_doccode, v_calstayLen, v_sex, v_eststaylen
      FROM   REG@IWEB R, BEDPREBOK@IWEB P
      WHERE  R.PBPID = P.PBPID (+)
      AND    R.INPID = rlOccupiedNo1.INPID
      AND    R.REGSTS = 'N';

      -- get gender if not found in bedprebok
      IF v_sex IS NULL THEN
        SELECT P.PATSEX
        INTO   v_sex
        FROM   PATIENT@IWEB P
        WHERE  P.PATNO = v_patno;
      END IF;

      -- get estimate length of stay
      v_stayLen := v_calstayLen + v_defaultLen;

      FOR v_indicator IN 0..(v_stayLen - 1)
      LOOP
        -- insert detail
        INSERT INTO HAT_BED_BOOKED_TMP (HAT_PERIOD, HAT_WRDCODE, HAT_ACMCODE, HAT_ROMCODE, HAT_BEDCODE, HAT_BEDSEX, HAT_BOOKED_OT,
                                        HAT_BOOKED_CCIC, HAT_PATNO, HAT_DOCCODE, HAT_STATUS)
        VALUES(TRUNC(v_regDate) + v_indicator, 'XX', rlOccupiedNo1.ACMCODE, 'XXX', rlOccupiedNo1.BEDCODE, v_sex, 0,
               0, v_patno, v_doccode, rlOccupiedNo1.v_status);
      END LOOP;
    END IF;
  END LOOP;

  --------------------------------------------------------------------------------
  -- Step 4.4. insert bed booked from occupied no (already discharge - either discharge date within date range)
  --------------------------------------------------------------------------------
  FOR rlOccupiedNo2 IN (
    SELECT I.INPID, I.ACMCODE, I.INPDDATE, I.BEDCODE
    FROM   INPAT@IWEB I
    WHERE  I.ACMCODE IS NOT NULL
    AND    I.INPDDATE IS NOT NULL
    AND    I.INPDDATE BETWEEN v_datefrom AND v_dateto + 1)
  LOOP
    SELECT COUNT(1) INTO v_indicator
    FROM   REG@IWEB R
    WHERE  R.INPID = rlOccupiedNo2.INPID
    AND    R.REGSTS = 'N';

    IF v_indicator = 1 THEN
      SELECT R.PBPID, R.REGDATE, R.PATNO, R.DOCCODE, P.SEX
      INTO   v_pbpid, v_regdate, v_patno, v_doccode, v_sex
      FROM   REG@IWEB R, BEDPREBOK@IWEB P
      WHERE  R.PBPID = P.PBPID (+)
      AND    R.INPID = rlOccupiedNo2.INPID
      AND    R.REGSTS = 'N';

      -- get gender if not found in bedprebok
      IF v_sex IS NULL THEN
        SELECT P.PATSEX
        INTO   v_sex
        FROM   PATIENT@IWEB P
        WHERE  P.PATNO = v_patno;
      END IF;

      -- calculate stay len
      IF v_datefrom > TRUNC(v_regdate) THEN
        v_dateCurr := v_datefrom;
      ELSE
        v_dateCurr := TRUNC(v_regdate);
      END IF;

      v_stayLen := TRUNC(rlOccupiedNo2.INPDDATE) - v_dateCurr;

      FOR v_indicator IN 0..(v_stayLen)
      LOOP
        IF v_indicator < v_stayLen THEN
          v_status := 'F';
        ELSE
          v_status := 'C';
        END IF;

        -- insert detail
        INSERT INTO HAT_BED_BOOKED_TMP (HAT_PERIOD, HAT_WRDCODE, HAT_ACMCODE, HAT_ROMCODE, HAT_BEDCODE, HAT_BEDSEX, HAT_BOOKED_OT,
                                        HAT_BOOKED_CCIC, HAT_PATNO, HAT_DOCCODE, HAT_STATUS)
        VALUES(v_dateCurr + v_indicator, 'XX', rlOccupiedNo2.ACMCODE, 'XXX', rlOccupiedNo2.BEDCODE, v_sex, 0,
               0, v_patno, v_doccode, v_status);
      END LOOP;
    END IF;
  END LOOP;

  --------------------------------------------------------------------------------
  -- Step 4.5. insert bed booked from occupied no (already discharge - either registration date within date range)
  --------------------------------------------------------------------------------
  FOR rlOccupiedNo3 IN (
    SELECT R.INPID, R.PBPID, R.REGDATE, R.PATNO, R.DOCCODE
    FROM   REG@IWEB R
    WHERE  R.REGDATE BETWEEN v_datefrom AND v_dateto + 1
    AND    R.INPID IS NOT NULL
    AND    R.PBPID IS NOT NULL
    AND    R.REGSTS = 'N')
  LOOP
    SELECT COUNT(1) INTO v_indicator
    FROM   INPAT@IWEB I
    WHERE  I.ACMCODE IS NOT NULL
    AND    I.INPDDATE IS NOT NULL
    AND    I.INPDDATE NOT BETWEEN v_datefrom AND v_dateto + 1
    AND    I.INPID = rlOccupiedNo3.INPID;

    IF v_indicator = 1 THEN
      SELECT I.ACMCODE, I.INPDDATE, I.BEDCODE
      INTO   v_acmCode, v_inpddate, v_bedcode
      FROM   INPAT@IWEB I
      WHERE  I.ACMCODE IS NOT NULL
      AND    I.INPDDATE IS NOT NULL
      AND    I.INPDDATE NOT BETWEEN v_datefrom AND v_dateto + 1
      AND    I.INPID = rlOccupiedNo3.INPID;

      -- get gender
      SELECT P.SEX
      INTO   v_sex
      FROM   BEDPREBOK@IWEB P
      WHERE  P.PBPID = rlOccupiedNo3.PBPID;

      -- occupied when already discharge
      IF v_datefrom > TRUNC(rlOccupiedNo3.REGDATE) THEN
        v_dateCurr := v_datefrom;
      ELSE
        v_dateCurr := TRUNC(rlOccupiedNo3.REGDATE);
      END IF;

      v_stayLen := TRUNC(v_inpddate) - v_dateCurr;

      FOR v_indicator IN 0..(v_stayLen)
      LOOP
        IF v_inpddate IS NULL OR v_indicator < v_stayLen THEN
          v_status := 'F';
        ELSE
          v_status := 'C';
        END IF;

        -- insert detail
        INSERT INTO HAT_BED_BOOKED_TMP (HAT_PERIOD, HAT_WRDCODE, HAT_ACMCODE, HAT_ROMCODE, HAT_BEDCODE, HAT_BEDSEX, HAT_BOOKED_OT,
                                        HAT_BOOKED_CCIC, HAT_PATNO, HAT_DOCCODE, HAT_STATUS)
        VALUES(v_dateCurr + v_indicator, 'XX', v_acmCode, 'XXX', v_bedcode, v_sex, 0,
               0, rlOccupiedNo3.PATNO, rlOccupiedNo3.DOCCODE, v_status);
      END LOOP;
    END IF;
  END LOOP;

  --------------------------------------------------------------------------------
  -- Step 5.1. update flag for booked OT
  --------------------------------------------------------------------------------
  FOR rlOTBooked IN (
    SELECT HAT_PBPID
    FROM   HAT_BED_BOOKED_TMP
    WHERE  HAT_PERIOD >= v_datefrom
    AND    HAT_PERIOD <= v_dateto
    AND    HAT_PBPID IS NOT NULL)
  LOOP
    v_indicator := 0;

    SELECT COUNT(1) INTO v_indicator
    FROM   OT_APP@IWEB
    WHERE  PBPID = rlOTBooked.HAT_PBPID;

    IF v_indicator > 0 THEN
      UPDATE HAT_BED_BOOKED_TMP
      SET    HAT_BOOKED_OT = 1
      WHERE  HAT_PERIOD >= v_datefrom
      AND    HAT_PERIOD <= v_dateto
      AND    HAT_PBPID = rlOTBooked.HAT_PBPID;
    END IF;
  END LOOP;

  --------------------------------------------------------------------------------
  -- Step 5.2. update flag for non-booked OT
  --------------------------------------------------------------------------------
  UPDATE HAT_BED_BOOKED_TMP R
  SET    HAT_BOOKED_OT = 0
  WHERE  HAT_PERIOD >= v_datefrom
  AND    HAT_PERIOD <= v_dateto
  AND    HAT_BOOKED_OT IS NULL;

  --------------------------------------------------------------------------------
  -- Step 5.3. update romcode from bed and room
  --------------------------------------------------------------------------------
  UPDATE HAT_BED_BOOKED_TMP R
  SET   (HAT_WRDCODE, HAT_ROMCODE) = (
         SELECT M.WRDCODE, B.ROMCODE
         FROM   BED@IWEB B, ROOM@IWEB M
         WHERE  B.ROMCODE = M.ROMCODE
         AND    B.BEDCODE = R.HAT_BEDCODE )
  WHERE  R.HAT_PERIOD >= v_datefrom
  AND    R.HAT_PERIOD <= v_dateto
  AND    R.HAT_BEDCODE IS NOT NULL;

  --------------------------------------------------------------------------------
  -- Step 5.5. update patient name
  --------------------------------------------------------------------------------
  UPDATE HAT_BED_BOOKED_TMP R
  SET   (HAT_PATNAME, HAT_PATCNAME) = (
         SELECT P.PATFNAME || ' ' || P.PATGNAME, P.PATCNAME
         FROM   PATIENT@IWEB P
         WHERE  P.PATNO = R.HAT_PATNO )
  WHERE  R.HAT_PERIOD >= v_datefrom
  AND    R.HAT_PERIOD <= v_dateto
  AND    R.HAT_PATNO IS NOT NULL;

  --------------------------------------------------------------------------------
  -- Step 6.1. copy temp table to actual table
  --------------------------------------------------------------------------------
  DELETE FROM HAT_BED_BOOKED
  WHERE  HAT_PERIOD >= v_datefrom
  AND    HAT_PERIOD <= v_dateto;

  INSERT INTO HAT_BED_BOOKED (HAT_PERIOD, HAT_WRDCODE, HAT_ACMCODE, HAT_ROMCODE, HAT_BEDCODE, HAT_BEDSEX, HAT_BOOKED_OT,
                              HAT_BOOKED_CCIC, HAT_PBPID, HAT_PATNO, HAT_PATNAME, HAT_PATCNAME, HAT_DOCCODE, HAT_STATUS)
  SELECT T.HAT_PERIOD, T.HAT_WRDCODE, DECODE(D.HAT_ACMCODE, NULL, T.HAT_ACMCODE, D.HAT_ACMCODE), T.HAT_ROMCODE, T.HAT_BEDCODE, T.HAT_BEDSEX, T.HAT_BOOKED_OT,
         T.HAT_BOOKED_CCIC, T.HAT_PBPID, T.HAT_PATNO, T.HAT_PATNAME, T.HAT_PATCNAME, T.HAT_DOCCODE, T.HAT_STATUS
  FROM   HAT_BED_BOOKED_TMP T, HAT_BED_DETAIL D
  WHERE  T.HAT_PERIOD = D.HAT_PERIOD (+)
  AND    T.HAT_BEDCODE = D.HAT_BEDCODE (+)
  AND    T.HAT_PERIOD >= v_datefrom
  AND    T.HAT_PERIOD <= v_dateto;

  --------------------------------------------------------------------------------
  -- Step 7.1. update bed stat from temp table
  --------------------------------------------------------------------------------
  FOR v_indicator IN 0..(v_datenum - 1)
  LOOP
    v_dateCurr := v_datefrom + v_indicator;
    -- update booked
    FOR rlBookedTemp IN (
      SELECT HAT_WRDCODE, HAT_ACMCODE, HAT_ROMCODE,
             SUM(DECODE(HAT_BEDSEX, 'M', 1, 0)) v_bedsex_m,
             SUM(DECODE(HAT_BEDSEX, 'F', 1, 0)) v_bedsex_f,
             SUM(DECODE(HAT_STATUS, 'B', 1, 0)) v_booked,
             SUM(HAT_BOOKED_OT) v_booked_ot,
             SUM(HAT_BOOKED_CCIC) v_booked_ccic,
             SUM(DECODE(HAT_BOOKED_OT + HAT_BOOKED_CCIC, 2, 1, 0)) v_booked_both,
             SUM(DECODE(HAT_STATUS, 'F', 1, 0)) v_occupied,
             SUM(DECODE(HAT_STATUS, 'C', 1, 0)) v_discharge
      FROM   HAT_BED_BOOKED
      WHERE  HAT_PERIOD = v_dateCurr
      GROUP BY HAT_WRDCODE, HAT_ACMCODE, HAT_ROMCODE)
    LOOP
      UPDATE HAT_BED_STAT
      SET    HAT_BOOKED = HAT_BOOKED + rlBookedTemp.v_booked,
             HAT_BOOKED_OT = HAT_BOOKED_OT + rlBookedTemp.v_booked_ot,
             HAT_BOOKED_CCIC = HAT_BOOKED_CCIC + rlBookedTemp.v_booked_ccic,
             HAT_BOOKED_BOTH = HAT_BOOKED_BOTH + rlBookedTemp.v_booked_both,
             HAT_OCCUPIED = HAT_OCCUPIED + rlBookedTemp.v_occupied
      WHERE  HAT_PERIOD = v_dateCurr
      AND    HAT_WRDCODE = rlBookedTemp.HAT_WRDCODE
      AND    HAT_ACMCODE = rlBookedTemp.HAT_ACMCODE;

      -- booked no (for OT)
      UPDATE HAT_BED_STAT
      SET    HAT_BOOKED = HAT_BOOKED + rlBookedTemp.v_booked_ot
      WHERE  HAT_PERIOD = v_dateCurr
      AND    HAT_WRDCODE = 'OT'
      AND    HAT_ACMCODE = rlBookedTemp.HAT_ACMCODE;

      -- booked no (for CCIC)
      UPDATE HAT_BED_STAT
      SET    HAT_BOOKED = HAT_BOOKED + rlBookedTemp.v_booked_ccic
      WHERE  HAT_PERIOD = v_dateCurr
      AND    HAT_WRDCODE = 'CCIC'
      AND    HAT_ACMCODE = rlBookedTemp.HAT_ACMCODE;
    END LOOP;

    --------------------------------------------------------------------------------
    -- Step 7.2 update detail table for booked, occupied
    --------------------------------------------------------------------------------
    FOR rlOccupiedDetail IN (
      SELECT HAT_PERIOD, HAT_WRDCODE, HAT_ACMCODE, HAT_ROMCODE, HAT_BEDCODE,
             HAT_BEDSEX, HAT_PATNAME, HAT_PATCNAME, HAT_DOCCODE, HAT_STATUS
      FROM   HAT_BED_BOOKED
      WHERE  HAT_PERIOD = v_dateCurr
      AND    HAT_STATUS IN ('B', 'F')
      ORDER BY HAT_STATUS )
    LOOP
      UPDATE HAT_BED_DETAIL
      SET    HAT_BEDSEX = rlOccupiedDetail.HAT_BEDSEX,
             HAT_PATNAME = rlOccupiedDetail.HAT_PATNAME,
             HAT_PATCNAME = rlOccupiedDetail.HAT_PATCNAME,
             HAT_DOCCODE = rlOccupiedDetail.HAT_DOCCODE,
             HAT_STATUS = rlOccupiedDetail.HAT_STATUS
      WHERE  HAT_PERIOD = rlOccupiedDetail.HAT_PERIOD
      AND    HAT_WRDCODE = rlOccupiedDetail.HAT_WRDCODE
      AND    HAT_ACMCODE = rlOccupiedDetail.HAT_ACMCODE
      AND    HAT_ROMCODE = rlOccupiedDetail.HAT_ROMCODE
      AND    HAT_BEDCODE = rlOccupiedDetail.HAT_BEDCODE;
    END LOOP;

    --------------------------------------------------------------------------------
    -- Step 7.5. update gender from bed detail
    --------------------------------------------------------------------------------
    FOR rlGender IN (
      SELECT HAT_PERIOD, HAT_WRDCODE, HAT_ACMCODE, HAT_ROMCODE,
             SUM(DECODE(HAT_BEDSEX, 'M', 1, 0)) v_male_occupied,
             SUM(DECODE(HAT_BEDSEX, 'F', 1, 0)) v_female_occupied,
             COUNT(1) v_total
      FROM   HAT_BED_DETAIL
      WHERE  HAT_PERIOD = v_dateCurr
      GROUP BY HAT_PERIOD, HAT_WRDCODE, HAT_ACMCODE, HAT_ROMCODE )
    LOOP
      IF rlGender.v_male_occupied > 0 THEN
        v_maleAvailable := rlGender.v_total - rlGender.v_male_occupied - rlGender.v_female_occupied;
        v_femaleAvailable := 0;
        v_bothAvailable := 0;
      ELSIF rlGender.v_female_occupied > 0 THEN
        v_maleAvailable := 0;
        v_femaleAvailable := rlGender.v_total - rlGender.v_male_occupied - rlGender.v_female_occupied;
        v_bothAvailable := 0;
      ELSE
        v_maleAvailable := 0;
        v_femaleAvailable := 0;
        v_bothAvailable := rlGender.v_total;
      END IF;

      UPDATE HAT_BED_STAT
      SET    HAT_AVAILABLE_M = HAT_AVAILABLE_M + v_maleAvailable,
             HAT_AVAILABLE_F = HAT_AVAILABLE_F + v_femaleAvailable,
             HAT_AVAILABLE_X = HAT_AVAILABLE_X + v_bothAvailable
      WHERE  HAT_PERIOD = rlGender.HAT_PERIOD
      AND    HAT_WRDCODE = rlGender.HAT_WRDCODE
      AND    HAT_ACMCODE = rlGender.HAT_ACMCODE;
    END LOOP;

    --------------------------------------------------------------------------------
    -- Step 7.6. release block if discharge
    --------------------------------------------------------------------------------
    SELECT COUNT(1) INTO v_indicator2
    FROM   HAT_BED_DETAIL D, HAT_BED_BOOKED B
    WHERE  D.HAT_PERIOD = B.HAT_PERIOD
    AND    D.HAT_WRDCODE = B.HAT_WRDCODE
    AND    D.HAT_ROMCODE = B.HAT_ROMCODE
    AND    D.HAT_PERIOD = v_dateCurr
    AND    D.HAT_NEED_UNBLOCK = 'Y'  -- need unblock
    AND    B.HAT_STATUS = 'C';  -- discharge

    IF v_indicator2 > 0 THEN
      FOR releaseBlock IN (
        SELECT DISTINCT D.HAT_WRDCODE, D.HAT_ROMCODE
        FROM   HAT_BED_DETAIL D, HAT_BED_BOOKED B
        WHERE  D.HAT_PERIOD = B.HAT_PERIOD
        AND    D.HAT_WRDCODE = B.HAT_WRDCODE
        AND    D.HAT_ROMCODE = B.HAT_ROMCODE
        AND    D.HAT_PERIOD = v_dateCurr
        AND    D.HAT_NEED_UNBLOCK = 'Y'  -- need unblock
        AND    B.HAT_STATUS = 'C' ) -- discharge
      LOOP
        SELECT COUNT(1) INTO v_indicator2
        FROM   HAT_BED_DETAIL_LOG
        WHERE  HAT_PERIOD = v_dateCurr
        AND    HAT_ROMCODE = releaseBlock.HAT_ROMCODE
        AND    HAT_STATUS = 'D';

        -- unblock before?
        IF v_indicator2 = 0 THEN
          FOR releaseRoom IN (
            SELECT DISTINCT R.ACMCODE, B.BEDCODE
            FROM   ROOM@IWEB R, BED@IWEB B
            WHERE  R.ROMCODE = B.ROMCODE
            AND    R.ROMCODE = releaseBlock.HAT_ROMCODE )
          LOOP
            -- unblock all the beds in same room
            UPDATE HAT_BED_DETAIL
            SET    HAT_ACMCODE = releaseRoom.ACMCODE,
                   HAT_ENABLED = 1
            WHERE  HAT_PERIOD >= v_dateCurr
            AND    HAT_ROMCODE = releaseBlock.HAT_ROMCODE
            AND    HAT_BEDCODE = releaseRoom.BEDCODE;

            -- keep logging
            INSERT INTO HAT_BED_DETAIL_LOG (HAT_PERIOD, HAT_WRDCODE, HAT_ACMCODE, HAT_ROMCODE, HAT_BEDCODE, HAT_STATUS)
            VALUES (v_dateCurr, releaseBlock.HAT_WRDCODE, releaseRoom.ACMCODE, releaseBlock.HAT_ROMCODE, releaseRoom.BEDCODE, 'D');
          END LOOP;
        END IF;
      END LOOP;
    END IF;

    --------------------------------------------------------------------------------
    -- Step 7.7. store total no for each ward and acm
    --------------------------------------------------------------------------------
    FOR rlTotalNo IN (
      SELECT HAT_WRDCODE, HAT_ACMCODE, COUNT(1) v_total
      FROM   HAT_BED_DETAIL
      WHERE  HAT_PERIOD = v_dateCurr
      AND    HAT_ENABLED = 1
      GROUP BY HAT_WRDCODE, HAT_ACMCODE)
    LOOP
      UPDATE HAT_BED_STAT
      SET    HAT_TOTAL = rlTotalNo.v_total
      WHERE  HAT_PERIOD = v_dateCurr
      AND    HAT_WRDCODE = rlTotalNo.HAT_WRDCODE
      AND    HAT_ACMCODE = rlTotalNo.HAT_ACMCODE;
    END LOOP;
  END LOOP;

  --------------------------------------------------------------------------------
  -- Step 9.1. update available
  --------------------------------------------------------------------------------
  UPDATE HAT_BED_STAT
  SET    HAT_AVAILABLE = HAT_TOTAL - HAT_BOOKED - HAT_OCCUPIED
  WHERE  HAT_PERIOD >= v_datefrom
  AND    HAT_PERIOD <= v_dateto;

  --------------------------------------------------------------------------------
  -- Step 9.2. update ordering
  --------------------------------------------------------------------------------
  UPDATE HAT_BED_STAT
  SET    HAT_AVAILABLE = 0, HAT_WRDCODE_ORDER = 1
  WHERE  HAT_PERIOD >= v_datefrom
  AND    HAT_PERIOD <= v_dateto
  AND    HAT_WRDCODE = 'OT';

  --------------------------------------------------------------------------------
  -- Step 9.3. update ordering
  --------------------------------------------------------------------------------
  UPDATE HAT_BED_STAT
  SET    HAT_AVAILABLE = 0, HAT_WRDCODE_ORDER = 2
  WHERE  HAT_PERIOD >= v_datefrom
  AND    HAT_PERIOD <= v_dateto
  AND    HAT_WRDCODE = 'CCIC';

  COMMIT;

  RETURN 0;
END;
/