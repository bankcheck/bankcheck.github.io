create or replace
FUNCTION "NHS_GET_CALSPECAMT"(V_SLPNO     IN VARCHAR2,
                              V_REGDATE   IN VARCHAR2,
                              V_DPTCODE   IN VARCHAR2,
                              V_ITMCODE   IN VARCHAR2,
                              V_ITMTYPE_H IN VARCHAR2,
                              V_ITMTYPE_D IN VARCHAR2,
                              V_ITMTYPE_S IN VARCHAR2,
                              V_ITMTYPE_O IN VARCHAR2,
                              V_FDATE     IN VARCHAR2,
                              V_TDATE     IN VARCHAR2)
RETURN TYPES.CURSOR_TYPE AS
  outcur          types.cursor_type;
  V_STNTDATE_F    VARCHAR2(20);
  v_stntdate_t    varchar2(20);
  sqlbuf          varchar2(500);
  itmType_sqlbuf   varchar2(100);
BEGIN
  IF V_FDATE IS NULL THEN
    V_STNTDATE_F := V_REGDATE;
  ELSE
    V_STNTDATE_F := V_FDATE;
  END IF;
  IF V_TDATE IS NULL THEN
    V_STNTDATE_T := TO_CHAR(SYSDATE, 'DD/MM/YYYY');
  ELSE
    V_STNTDATE_T := V_TDATE;
  END IF;

  sqlbuf := '
     SELECT NVL(SUM(NVL(STNNAMT, 0)), 0)
     FROM SLIPTX A, ITEM B
     WHERE A.ITMCODE = B.ITMCODE
       and a.slpno = ''' || v_slpno || '''';

  if v_dptcode is not null then
    sqlbuf := sqlbuf || ' and B.DPTCODE = ''' || V_DPTCODE || '''';
  end if;

  if v_itmcode is not null then
    sqlbuf := sqlbuf || ' and a.itmcode = ''' || v_itmcode || '''';
  end if;

  if v_itmtype_h is not null then
    if itmType_sqlbuf is not null then
      itmType_sqlbuf := itmType_sqlbuf || ',';
    end if;
    itmType_sqlbuf := itmType_sqlbuf || '''' || v_itmtype_h || '''';
  end if;
  if V_ITMTYPE_D is not null then
    if itmType_sqlbuf is not null then
      itmType_sqlbuf := itmType_sqlbuf || ',';
    end if;
    itmType_sqlbuf := itmType_sqlbuf || '''' || v_itmtype_d || '''';
  end if;
  if V_ITMTYPE_S is not null then
    if itmType_sqlbuf is not null then
      itmType_sqlbuf := itmType_sqlbuf || ',';
    end if;
    itmType_sqlbuf := itmType_sqlbuf || '''' || V_ITMTYPE_S || '''';
  end if;
  if V_ITMTYPE_O is not null then
    if itmType_sqlbuf is not null then
      itmType_sqlbuf := itmType_sqlbuf || ',';
    end if;
    itmType_sqlbuf := itmType_sqlbuf || '''' || v_itmtype_o || '''';
  end if;
  if itmType_sqlbuf is not null then
    itmType_sqlbuf := ' and A.ITMTYPE in (' || itmType_sqlbuf || ')';
  end if;

  sqlbuf := sqlbuf || itmType_sqlbuf;
  sqlbuf := sqlbuf || ' AND STNTDATE >= TO_DATE(''' || V_STNTDATE_F || ''', ''DD/MM/YYYY'')';
  sqlbuf := sqlbuf || ' AND TRUNC(STNTDATE) <= TO_DATE(''' || V_STNTDATE_T || ''', ''DD/MM/YYYY'') ';
  open outcur for sqlbuf;
  RETURN outcur;
END NHS_GET_CALSPECAMT;
/
