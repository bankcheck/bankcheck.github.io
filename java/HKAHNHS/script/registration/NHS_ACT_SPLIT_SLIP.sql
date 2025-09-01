CREATE OR REPLACE FUNCTION "NHS_ACT_SPLIT_SLIP"(V_ACTION  IN VARCHAR2,
                                                V_REGID   IN VARCHAR2,
                                                V_PATNO   IN VARCHAR2,
                                                V_STECODE IN VARCHAR2,
                                                V_USRID   IN VARCHAR2,
                                                O_ERRMSG  OUT VARCHAR2)
  RETURN NUMBER AS
  O_ERRCODE NUMBER;
  SMAXSLPNO VARCHAR2(20);
  RS_SLIP   SLIP%ROWTYPE;
BEGIN
  O_ERRCODE := -1;
  SELECT MAX(TO_NUMBER(SLPNO))
    INTO SMAXSLPNO
    FROM SLIP
   WHERE PATNO = V_PATNO
     AND SLPTYPE = 'I';
  SELECT ARCCODE,
         SLPPLYNO,
         SLPVCHNO,
         NVL(PCYID, 0),
         NVL(ARLMTAMT, 0),
         NVL(FURGRTAMT, 0),
         CVREDATE,
         FURGRTDATE,
         COPAYTYP,
         NVL(COPAYAMT, 0),
         --COPAYAMTACT,
         NVL(ITMTYPED, 0),
         NVL(ITMTYPEH, 0),
         NVL(ITMTYPES, 0),
         NVL(ITMTYPEO, 0),
         PATREFNO,
         PRINTDATE
    INTO RS_SLIP.ARCCODE,
         RS_SLIP.SLPPLYNO,
         RS_SLIP.SLPVCHNO,
         RS_SLIP.PCYID,
         RS_SLIP.ARLMTAMT,
         RS_SLIP.FURGRTAMT,
         RS_SLIP.CVREDATE,
         RS_SLIP.FURGRTDATE,
         RS_SLIP.COPAYTYP,
         RS_SLIP.COPAYAMT,
         RS_SLIP.ITMTYPED,
         RS_SLIP.ITMTYPEH,
         RS_SLIP.ITMTYPES,
         RS_SLIP.ITMTYPEO,
         RS_SLIP.PATREFNO,
         RS_SLIP.PRINTDATE
    FROM SLIP
   WHERE SLPNO = SMAXSLPNO;

  O_ERRCODE := NHS_ACT_SPLITSLIP('ADD',
                                 V_REGID,
                                 V_STECODE,
                                 V_USRID,
                                 O_ERRMSG);
  IF O_ERRCODE <> -1 THEN
    IF RS_SLIP.PCYID = 0 THEN
      UPDATE SLIP
         SET ARCCODE    = RS_SLIP.ARCCODE,
             SLPPLYNO   = RS_SLIP.SLPPLYNO,
             SLPVCHNO   = RS_SLIP.SLPVCHNO,
             ARLMTAMT   = RS_SLIP.ARLMTAMT,
             FURGRTAMT  = RS_SLIP.FURGRTAMT,
             CVREDATE   = RS_SLIP.CVREDATE,
             FURGRTDATE = RS_SLIP.FURGRTDATE,
             PRINTDATE  = RS_SLIP.PRINTDATE,
             COPAYTYP   = RS_SLIP.COPAYTYP,
             COPAYAMT   = RS_SLIP.COPAYAMT,
             ITMTYPED   = RS_SLIP.ITMTYPED,
             ITMTYPEH   = RS_SLIP.ITMTYPEH,
             ITMTYPES   = RS_SLIP.ITMTYPES,
             ITMTYPEO   = RS_SLIP.ITMTYPEO,
             PATREFNO   = RS_SLIP.PATREFNO
       WHERE SLPNO = TO_CHAR(O_ERRCODE);
    ELSE
      UPDATE SLIP
         SET ARCCODE    = RS_SLIP.ARCCODE,
             SLPPLYNO   = RS_SLIP.SLPPLYNO,
             SLPVCHNO   = RS_SLIP.SLPVCHNO,
             PCYID      = RS_SLIP.PCYID,
             ARLMTAMT   = RS_SLIP.ARLMTAMT,
             FURGRTAMT  = RS_SLIP.FURGRTAMT,
             CVREDATE   = RS_SLIP.CVREDATE,
             FURGRTDATE = RS_SLIP.FURGRTDATE,
             PRINTDATE  = RS_SLIP.PRINTDATE,
             COPAYTYP   = RS_SLIP.COPAYTYP,
             COPAYAMT   = RS_SLIP.COPAYAMT,
             ITMTYPED   = RS_SLIP.ITMTYPED,
             ITMTYPEH   = RS_SLIP.ITMTYPEH,
             ITMTYPES   = RS_SLIP.ITMTYPES,
             ITMTYPEO   = RS_SLIP.ITMTYPEO,
             PATREFNO   = RS_SLIP.PATREFNO
       WHERE SLPNO = TO_CHAR(O_ERRCODE);
    END IF;

  END IF;
  RETURN O_ERRCODE;
END NHS_ACT_SPLIT_SLIP;
/
