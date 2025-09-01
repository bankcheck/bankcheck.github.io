create or replace FUNCTION NHS_RPT_RPTTRANSTOCMPAR_XLS
( v_SDate VARCHAR2,
  v_EDate VARCHAR2,
  v_SteCode VARCHAR2
)
  RETURN Types.cursor_type
--RETURN VARCHAR2
IS
  outcur types.cursor_type;
  V_SLPTYPE VARCHAR2(3);
  V_SLPCNT NUMBER := 0;
  V_ISLPCNT NUMBER := 0;
  V_OSLPCNT NUMBER := 0;
  V_DSLPCNT NUMBER := 0;
  sqlbuf VARCHAR2(5000);

CURSOR c_getSlipCount IS
    SELECT SLPTYPE, COUNT(SLPTYPE) AS SLPCNT
    FROM (
    SELECT
    S.PATNO,
    ST.STNTYPE,
    s.slptype,
    (atxamt) as amt,
    decode(s.patno, null, s.slpfname || ' ' || s.slpgname, p.patfname || ' ' || p.patgname) as name,
    st.slpno, to_char(stntdate, 'DD/MM/YYYY') as billon, a.Arccode, ar.arcname
    From
    sliptx st, slip s, patient p, artx a, arcode ar
    Where
    STNTYPE = 'P'
    and a.ATXCDATE >= to_date(v_SDate, 'DD/MM/YYYY')
    and a.ATXCDATE < to_date(v_EDate, 'DD/MM/YYYY') + 1
    and a.slpno = s.slpno
    and a.arccode = ar.arccode
    and a.arpid is null
    AND S.PATNO = P.PATNO (+)
    and s.stecode = v_SteCode
    AND A.ATXREFID = ST.STNID
    Group By
    s.slptype,s.patno, st.stntype, atxamt,
    DECODE(S.PATNO,NULL,S.SLPFNAME || ' ' || S.SLPGNAME, P.PATFNAME || ' ' || P.PATGNAME),
    ST.SLPNO, TO_CHAR(STNTDATE, 'DD/MM/YYYY'), A.ARCCODE, AR.ARCNAME, a.atxid
    ) GROUP BY SLPTYPE;
BEGIN
/*
  OPEN OUTCUR FOR
  SELECT
  DTL.PATNO,
  DTL.STNTYPE,
  DTL.SLPTYPENAME,
  DTL.AMT,
  DTL.NAME,
  DTL.SLPNO,
  DTL.BILLON,
  DTL.ARCCODE,
  DTL.ARCNAME,
  DTL.SLPTYPE,
  CNT.SLPCNT
  FROM
  (
    SELECT
    S.PATNO,
    ST.STNTYPE,
    s.slptype,
    decode(s.slptype,'D','Day-Case','I','In-Patient','O','Out-Patient','Unknown')slptypename,
    (atxamt) as amt,
    decode(s.patno, null, s.slpfname || ' ' || s.slpgname, p.patfname || ' ' || p.patgname) as name,
    ST.SLPNO,
    TO_CHAR(STNTDATE, 'DD/MM/YYYY') AS BILLON,
    A.ARCCODE,
    ar.arcname
    From
    sliptx st, slip s, patient p, artx a, arcode ar
    Where
    stntype = 'P'
    and a.ATXCDATE >= to_date(v_SDate, 'DD/MM/YYYY')
    and a.ATXCDATE < to_date(v_EDate, 'DD/MM/YYYY') + 1
    and a.slpno = s.slpno
    and a.arccode = ar.arccode
    and a.arpid is null
    and s.patno = p.patno (+)
    and s.stecode = v_SteCode
    AND A.ATXREFID = ST.STNID
    Group By
    s.slptype,s.patno, st.stntype, atxamt,
    DECODE(S.PATNO,NULL,S.SLPFNAME || ' ' || S.SLPGNAME, P.PATFNAME || ' ' || P.PATGNAME),
    ST.SLPNO, TO_CHAR(STNTDATE, 'DD/MM/YYYY'), A.ARCCODE, AR.ARCNAME, a.atxid) DTL,
  (
    SELECT SLPTYPE, COUNT(SLPTYPE) AS SLPCNT
    FROM (
    SELECT
    S.PATNO,
    ST.STNTYPE,
    s.slptype,
    (atxamt) as amt,
    decode(s.patno, null, s.slpfname || ' ' || s.slpgname, p.patfname || ' ' || p.patgname) as name,
    st.slpno, to_char(stntdate, 'DD/MM/YYYY') as billon, a.Arccode, ar.arcname
    From
    sliptx st, slip s, patient p, artx a, arcode ar
    Where
    STNTYPE = 'P'
    and a.ATXCDATE >= to_date(v_SDate, 'DD/MM/YYYY')
    and a.ATXCDATE < to_date(v_EDate, 'DD/MM/YYYY') + 1
    and a.slpno = s.slpno
    and a.arccode = ar.arccode
    and a.arpid is null
    AND S.PATNO = P.PATNO (+)
    and s.stecode = v_SteCode
    AND A.ATXREFID = ST.STNID
    Group By
    s.slptype,s.patno, st.stntype, atxamt,
    DECODE(S.PATNO,NULL,S.SLPFNAME || ' ' || S.SLPGNAME, P.PATFNAME || ' ' || P.PATGNAME),
    ST.SLPNO, TO_CHAR(STNTDATE, 'DD/MM/YYYY'), A.ARCCODE, AR.ARCNAME, a.atxid
    ) GROUP BY SLPTYPE) CNT
  WHERE DTL.SLPTYPE = CNT.SLPTYPE(+)
  order by DTL.slptype,DTL.arccode,DTL.billon;

  RETURN OUTCUR;
*/
		OPEN c_getSlipCount;
		LOOP
		FETCH c_getSlipCount INTO V_SLPTYPE, V_SLPCNT;
		EXIT WHEN c_getSlipCount%NOTFOUND;
      IF V_SLPTYPE = 'I' THEN
        V_ISLPCNT := V_SLPCNT;
      ELSIF V_SLPTYPE = 'O' THEN
        V_OSLPCNT := V_SLPCNT;
      ELSIF V_SLPTYPE = 'D' THEN
        V_DSLPCNT := V_SLPCNT;
      END IF;
		END LOOP;
		CLOSE c_getSlipCount;

  IF V_ISLPCNT+V_OSLPCNT+V_DSLPCNT>0 THEN
  sqlbuf:=' SELECT
            PATNO,
            STNTYPE,
            SLPTYPENAME,
            AMT,
            NAME,
            SLPNO,
            BILLON,
            ARCCODE,
            ARCNAME,
            SLPTYPE,
            SLPCNT FROM (';
  END IF;

  sqlbuf:=sqlbuf||' SELECT
            DTL.PATNO,
            DTL.STNTYPE,
            DTL.SLPTYPENAME,
            DTL.AMT,
            DTL.NAME,
            DTL.SLPNO,
            DTL.BILLON,
            DTL.ARCCODE,
            DTL.ARCNAME,
            DTL.SLPTYPE';
  sqlbuf:=sqlbuf||', DECODE(DTL.SLPTYPE,''I'','||V_ISLPCNT||',''O'','||V_OSLPCNT||',''D'','||V_DSLPCNT||') SLPCNT';
  sqlbuf:=sqlbuf||' FROM (
            SELECT
            S.PATNO,
            ST.STNTYPE,
            s.slptype,
            decode(s.slptype,''D'',''Day-Case'',''I'',''In-Patient'',''O'',''Out-Patient'',''Unknown'')slptypename,
            (atxamt) as amt,
            decode(s.patno, null, s.slpfname || '' '' || s.slpgname, p.patfname || '' '' || p.patgname) as name,
            ST.SLPNO,
            TO_CHAR(STNTDATE, ''DD/MM/YYYY'') AS BILLON,
            A.ARCCODE,
            ar.arcname
            From
            sliptx st, slip s, patient p, artx a, arcode ar
            Where
            stntype = ''P''
            and a.ATXCDATE >= to_date('''||v_SDate||''', ''DD/MM/YYYY'')
            and a.ATXCDATE < to_date('''||v_EDate||''', ''DD/MM/YYYY'') + 1
            and a.slpno = s.slpno
            and a.arccode = ar.arccode
            and a.arpid is null
            and s.patno = p.patno (+)
            and s.stecode = '''||v_SteCode||
            ''' AND A.ATXREFID = ST.STNID
            Group By
            s.slptype,s.patno, st.stntype, atxamt,
            DECODE(S.PATNO,NULL,S.SLPFNAME || '' '' || S.SLPGNAME, P.PATFNAME || '' '' || P.PATGNAME),
            ST.SLPNO, TO_CHAR(STNTDATE, ''DD/MM/YYYY''), A.ARCCODE, AR.ARCNAME, a.atxid) DTL';

  IF V_ISLPCNT+V_OSLPCNT+V_DSLPCNT>0 THEN
    IF V_ISLPCNT = 0 THEN
      sqlbuf:=sqlbuf||' UNION ';    
      sqlbuf:=sqlbuf||' SELECT NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,''I'',0 FROM DUAL';
      IF V_OSLPCNT = 0 THEN
        sqlbuf:=sqlbuf||' UNION SELECT NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,''O'',0 FROM DUAL';
      ELSIF V_DSLPCNT = 0 THEN
        sqlbuf:=sqlbuf||' UNION SELECT NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,''D'',0 FROM DUAL';
      END IF;
    ELSIF V_OSLPCNT = 0 THEN
      sqlbuf:=sqlbuf||' UNION ';    
      sqlbuf:=sqlbuf||' SELECT NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,''O'',0 FROM DUAL';
      IF V_ISLPCNT = 0 THEN
        sqlbuf:=sqlbuf||' UNION SELECT NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,''I'',0 FROM DUAL';
      ELSIF V_DSLPCNT = 0 THEN
        sqlbuf:=sqlbuf||' UNION SELECT NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,''D'',0 FROM DUAL';
      END IF;
    ELSIF V_DSLPCNT = 0 THEN
      sqlbuf:=sqlbuf||' UNION ';    
      sqlbuf:=sqlbuf||' SELECT NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,''D'',0 FROM DUAL';
      IF V_ISLPCNT = 0 THEN
        sqlbuf:=sqlbuf||' UNION SELECT NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,''I'',0 FROM DUAL';
      ELSIF V_OSLPCNT = 0 THEN
        sqlbuf:=sqlbuf||' UNION SELECT NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,''O'',0 FROM DUAL';
      END IF;
    END IF;
    sqlbuf:=sqlbuf||')';
  END IF;

  sqlbuf:=sqlbuf||' order by slptype,arccode,billon';

  OPEN outcur FOR sqlbuf;
  RETURN OUTCUR;
--RETURN sqlbuf;
END NHS_RPT_RPTTRANSTOCMPAR_XLS;
/