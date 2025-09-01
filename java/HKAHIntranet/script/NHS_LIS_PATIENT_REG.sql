create or replace
FUNCTION "NHS_LIS_PATIENT_REG"
(v_PATNO VARCHAR2)
  RETURN Types.cursor_type
AS
  OUTCUR types.cursor_type;
  v_AppLabNum VARCHAR2(50);
  v_REGID number;
BEGIN
  select param1 into v_AppLabNum from sysparam@IWEB where parcde = 'AppLabNum';
  IF TO_NUMBER(v_AppLabNum) < 0 THEN
    RETURN OUTCUR;
  END IF;

  SELECT RegID_C into v_REGID FROM PATIENT@IWEB WHERE PatNo = v_PATNO;
  OPEN outcur FOR
    SELECT
        R.REGTYPE,
        R.REGOPCAT,
        I.BEDCODE,
        D.DPTNAME,
        W.WRDNAME,
        I.ACMCODE,
        R.REGNB,
        I.DOCCODE_A,
        D1.DOCFNAME || ' ' || D1.DOCGNAME,
        TO_CHAR(R.REGDATE,'dd/MM/yyyy HH24:MI:SS'),
        I.SRCCODE,
        I.INPREMARK,
        S.SLPNO,
        S.DOCCODE,
        D2.DOCFNAME || ' ' || D2.DOCGNAME,
        P.PCYCODE,
        S.PATREFNO,
        S.ARCCODE,
        S.SLPPLYNO,
        S.SLPVCHNO,
        S.ARLMTAMT,
        TO_CHAR(S.CVREDATE, 'dd/MM/yyyy'),
        S.COPAYTYP,
        S.COPAYAMT,
        S.ITMTYPED,
        S.ITMTYPEH,
        S.ITMTYPES,
        S.ITMTYPEO,
        S.FURGRTAMT,
        TO_CHAR(S.FURGRTDATE, 'dd/MM/yyyy'),
        R.PKGCODE,
        R.REGSTS,
        (select m.mrmdesc from medrechdr@IWEB mp, MEDRECMED@IWEB m
        where mp.patno=v_patno
        and mp.mrmid=m.mrmid
        and mp.mrhvollab=(select max(mrhvollab) from medrechdr@IWEB where MRHSTS = 'N' and patno = v_patno)) as mrmdesc,
        (select l.mrldesc  from MEDRECLOC@IWEB l where l.mrlid=
        (select mrlid_l from medrecdtl@IWEB where mrdid=
        (select mp.mrdid from medrechdr@IWEB mp
        where mp.patno=v_patno
        and mp.mrhvollab=(select max(mrhvollab) from medrechdr@IWEB where patno=v_patno))))
    FROM REG@IWEB R, INPAT@IWEB I, BED@IWEB B, ROOM@IWEB R, WARD@IWEB W, DEPT@IWEB D, SLIP@IWEB S, DOCTOR@IWEB D1, DOCTOR@IWEB D2, PATCAT@IWEB P,
    medrechdr@IWEB mp
    WHERE R.INPID = I.INPID (+)
    AND   I.BEDCODE = B.BEDCODE (+)
    AND   B.ROMCODE = R.ROMCODE (+)
    AND   R.WRDCODE = W.WRDCODE (+)
    AND   W.DPTCODE = D.DPTCODE (+)
    AND   R.slpno = S.slpno (+)
    AND   I.DOCCODE_A = D1.DOCCODE (+)
    AND   S.DOCCODE = D2.DOCCODE (+)
    AND   S.PCYID = P.PCYID (+)
    AND   R.REGID = v_REGID
    AND ROWNUM < 100
    ORDER BY R.REGID;
  RETURN OUTCUR;
END NHS_LIS_PATIENT_REG;