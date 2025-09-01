create or replace FUNCTION NHS_LIS_ARCSERCH (
	v_ArcCode IN VARCHAR2
)
	RETURN Types.cursor_type
--	RETURN VARCHAR2  
AS
	OUTCUR types.cursor_type;
  SQLSTR VARCHAR2(32767);  
BEGIN
  SQLSTR := '
		SELECT
      		ARCT.ACTID,
			AR.ArcCode,
      		ARCT.ACTCODE,
			AR.ArcName,
      		ARCT.ACTDESC,
			AR.ArcTel,
			AR.ArcCT,
			AR.ArcAdd1,
			AR.ArcAdd2,
			AR.ArcAdd3,
			AR.ArcTitle,
			AR.ArcUAmt,
			AR.ArcAmt      
		FROM  ArCode AR, ARCARDTYPE ARCT
		WHERE ROWNUM < 1000
		AND AR.ARCCODE = ARCT.ARCCODE
		AND  ((UPPER(AR.ArcCode) LIKE UPPER('''||v_ArcCode||''') || ''%'') OR
		(UPPER(AR.ArcName) LIKE ''%'' || UPPER('''||v_ArcCode||''') || ''%'') OR
		(UPPER(AR.ArcTel) LIKE ''%'' || UPPER('''||v_ArcCode||''') || ''%'') OR
		(UPPER(AR.ArcCT) LIKE ''%'' || UPPER('''||v_ArcCode||''')|| ''%'') OR
    (UPPER(ARCT.ACTCODE) LIKE ''%'' || UPPER('''||v_ArcCode||''') || ''%'') OR
    (UPPER(ARCT.ACTDESC) LIKE ''%'' || UPPER('''||v_ArcCode||''') || ''%''))
		ORDER BY AR.ARCCODE';
	OPEN OUTCUR FOR SQLSTR;   
	RETURN OUTCUR;
--RETURN SQLSTR;  
END NHS_LIS_ARCSERCH;
/