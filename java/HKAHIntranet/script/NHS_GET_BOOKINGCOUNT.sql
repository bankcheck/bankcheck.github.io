create or replace
FUNCTION "NHS_GET_BOOKINGCOUNT"(V_EDC    IN VARCHAR2,
                                                  V_PCNAME IN VARCHAR2)
  RETURN TYPES.CURSOR_TYPE AS
  V_EDCDATE  DATE;
  V_WARDCODE VARCHAR2(10);
  V_maxMPreBok VARCHAR2(50);
  V_maxDPreBok VARCHAR2(50);
  V_monthlyWaitingStarts VARCHAR2(50);
  V_sOBWaitingAuto VARCHAR2(50);
  V_curMPreBok Integer;
  V_obWaitingcnt Integer;
  V_curMPreBokP_B Integer;
  V_curMPreBokP_W Integer;
  V_curDPreBok Integer;
  V_curDpreBok_W Integer;
  V_curDPreBokP_B Integer;
  V_curDPreBokP_W Integer;
  V_curMPreBok_MC Integer;
  V_curMPreBok_ALL Integer;
  V_curYPreBok_MC Integer;
  V_curYPreBok_ALL Integer;
  OUTCUR     TYPES.CURSOR_TYPE;
BEGIN
  SELECT TO_DATE(V_EDC, 'DD/MM/YYYY') INTO V_EDCDATE FROM DUAL;
  SELECT PARAM1 INTO V_WARDCODE FROM SYSPARAM@IWEB WHERE PARCDE = 'obwardcode';

  SELECT PARAM1 INTO V_maxMPreBok FROM SYSPARAM@IWEB WHERE PARCDE = 'maxmprebok' AND ROWNUM = 1;
  SELECT PARAM1 INTO V_maxDPreBok FROM SYSPARAM@IWEB WHERE PARCDE = 'maxdprebok' AND ROWNUM = 1;
  SELECT PARAM1 INTO V_monthlyWaitingStarts FROM SYSPARAM@IWEB WHERE PARCDE = 'obwaitcnt' AND ROWNUM = 1;
  SELECT PARAM1 INTO V_sOBWaitingAuto FROM SYSPARAM@IWEB WHERE PARCDE = 'OBAUTOWAIT' AND ROWNUM = 1;

  SELECT NVL(SUM(DECODE(BPBTYPE, 'B', 1, 0)), 0), NVL(SUM(DECODE(BPBTYPE, 'W', 1, 0)), 0), NVL(SUM(DECODE(ISMAINLAND, '-1', 1, 0)), 0), COUNT(1)
         INTO V_curMPreBok, V_obWaitingcnt, V_curMPreBok_MC, V_curMPreBok_ALL
    FROM BEDPREBOK@IWEB
   WHERE TO_CHAR(BPBHDATE, 'YYYYMM') = TO_CHAR(V_EDCDATE, 'YYYYMM')
     AND WRDCODE = V_WARDCODE
     AND BPBSTS IN ('F', 'N')
     AND FORDELIVERY = -1;

  SELECT NVL(SUM(DECODE(ISMAINLAND, '-1', 1, 0)), 0), COUNT(1)
         INTO V_curYPreBok_MC, V_curYPreBok_ALL
    FROM BEDPREBOK@IWEB
   WHERE TO_CHAR(BPBHDATE, 'YYYY') = TO_CHAR(V_EDCDATE, 'YYYY')
     AND WRDCODE = V_WARDCODE
     AND BPBSTS IN ('F', 'N')
     AND FORDELIVERY = -1;

  SELECT NVL(SUM(DECODE(BPBTYPE, 'B', 1, 0)), 0), NVL(SUM(DECODE(BPBTYPE, 'W', 1, 0)), 0)
         INTO V_curMPreBokP_B, V_curMPreBokP_W
    FROM STSPREBOK@IWEB
   WHERE TO_CHAR(CONFINEDATE, 'YYYYMM') = TO_CHAR(V_EDCDATE, 'YYYYMM')
     AND ENDDATE IS NULL
     AND COMPUTERNAME <> V_PCNAME;

  SELECT NVL(SUM(DECODE(BPBTYPE, 'B', 1, 0)), 0), NVL(SUM(DECODE(BPBTYPE, 'W', 1, 0)), 0)
         INTO V_curDPreBok, V_curDpreBok_W
    FROM BEDPREBOK@IWEB
   WHERE TO_CHAR(BPBHDATE, 'YYYYMMDD') = TO_CHAR(V_EDCDATE, 'YYYYMMDD')
     AND WRDCODE = V_WARDCODE
     AND BPBSTS IN ('F', 'N')
     AND FORDELIVERY = -1;

  SELECT NVL(SUM(DECODE(BPBTYPE, 'B', 1, 0)), 0), NVL(SUM(DECODE(BPBTYPE, 'W', 1, 0)), 0)
         INTO V_curDPreBokP_B, V_curDPreBokP_W
    FROM STSPREBOK@IWEB
   WHERE TO_CHAR(CONFINEDATE, 'YYYYMMDD') = TO_CHAR(V_EDCDATE, 'YYYYMMDD')
     AND ENDDATE IS NULL
     AND COMPUTERNAME <> V_PCNAME;

  OPEN OUTCUR FOR
    SELECT
           V_maxMPreBok,
           V_maxDPreBok,
           V_monthlyWaitingStarts,
           V_sOBWaitingAuto,
           V_curMPreBok,
           V_obWaitingcnt,
           V_curMPreBokP_B,
           V_curMPreBokP_W,
           V_curDPreBok,
           V_curDpreBok_W,
           V_curDPreBokP_B,
           V_curDPreBokP_W,
           V_curMPreBok_MC,
           V_curMPreBok_ALL - V_curMPreBok_MC,
           V_curMPreBok_ALL,
           V_curYPreBok_MC,
           V_curYPreBok_ALL - V_curYPreBok_MC,
           V_curYPreBok_ALL
      FROM DUAL;
  RETURN OUTCUR;
END NHS_GET_BOOKINGCOUNT;