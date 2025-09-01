create or replace
FUNCTION "NHS_RPT_RPTOVERRIDEFEEDISC" (
  v_SDate VARCHAR2,
  v_EDate VARCHAR2,
  v_SteCode VARCHAR2,  
  v_Percentage VARCHAR2
)
  RETURN TYPES.cursor_type
--RETURN VARCHAR2
AS
  outcur TYPES.cursor_type;
  MSG VARCHAR2(5000);
BEGIN
  MSG := 'SELECT
        st.itmcode,
        it.itmname,
        st.stnbamt,
        st.stnnamt,
        st.stndisc,
        st.slpno,
        st.doccode,
        st.usrid,
        sit.stename,
        st.stnsts,
        TO_CHAR(st.stncdate,''DD/MM/YYYY'') AS stncdate
  FROM
       sliptx st,
       slip s,
       site sit,
       item it,
       doctor d
  WHERE
         st.stncdate >= to_date('''||v_SDate||''',''dd/mm/yyyy'')
         and st.stncdate < to_date('''||v_EDate||''', ''dd/mm/yyyy'') + 1
         and st.stnsts IN (''N'', ''A'')
         and st.stntype= ''D''
         and st.stnbamt <> stnnamt';
  IF v_Percentage IS NOT NULL THEN
    MSG := MSG||' and st.stndisc= '||v_Percentage;
  END IF;
  MSG := MSG||' and st.doccode= d.doccode
         and st.itmcode = it.itmcode
         and st.slpno= s.slpno
         and s.stecode= '''||v_SteCode||''' AND s.stecode= sit.stecode
  ORDER BY st.itmcode,st.slpno';
  OPEN outcur FOR MSG;
  DBMS_OUTPUT.PUT_LINE('outcur = ' ||SQL%ROWCOUNT  );
  RETURN outcur;
--  RETURN MSG;
END NHS_RPT_RPTOVERRIDEFEEDISC;
/