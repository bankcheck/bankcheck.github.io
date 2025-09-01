create or replace FUNCTION NHS_LIS_SLIPALERT(
	i_SlpNo IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	v_Count NUMBER;
  v_CountOther NUMBER;
BEGIN
	IF GET_CURRENT_STECODE = 'HKAH' THEN
  
		SELECT COUNT(1) INTO v_Count
		FROM   Slip s
		INNER JOIN SlipTx st ON s.SlpNo = st.SlpNo
		WHERE  s.SlpNo = i_SlpNo
		AND    s.SlpType = 'O'
    AND ST.STNSTS = 'N'
		AND    st.GlcCode LIKE '230%'
		AND    s.DocCode != st.DocCode;
    
    SELECT COUNT(1) INTO v_CountOther
		FROM   Slip s
		INNER JOIN SlipTx st ON s.SlpNo = st.SlpNo
		WHERE  s.SlpNo = i_SlpNo
		AND    s.SlpType = 'O'
    AND ST.STNSTS = 'N'
		AND    s.DocCode != st.DocCode;

		IF v_Count != 0 OR v_CountOther != 0 THEN
			OPEN OUTCUR FOR
				SELECT '<ul><li>There are more than one Dr''s Order in this slip.  </li><br>'||
        DECODE(v_CountOther,0,'','<li>1. Update Dr code; or </li><li>2. Change to a Correct Dr charge code RExx(F/U) </li>')||
        DECODE(v_Count,0,'','<li>3. Move LAB Charge(s) to a Correct or New Slip of the same Dr.</li>')||'</ul>'
				FROM DUAL;
		END IF;
	END IF;

	RETURN OUTCUR;
END NHS_LIS_SLIPALERT;
/
