create or replace FUNCTION NHS_LIS_ARCARDTYPE (
	v_arccode arcardtype.arccode%TYPE,
	v_actid arcardtype.actid%TYPE,
	v_actactive arcardtype.actactive%TYPE
)
	RETURN Types.cursor_type
AS
	OUTCUR TYPES.CURSOR_TYPE;
	SQLSTR VARCHAR2(3000);
	SQLWHERE VARCHAR2(3000);
BEGIN
	SQLSTR := 'select ActCode,
			ActRegRmkIP, ActRegRmkOP, ActRegRmkDC, ActPayRmkIP, ActPayRmkOP, ActPayRmkDC,
			RegRmkIPUrl, RegRmkOPUrl, RegRmkDCUrl, PayRmkIPUrl, PayRmkOPUrl, PayRmkDCUrl,
			ARCCODE
		from arcardtype where ';

	IF v_arccode IS NOT NULL THEN
		SQLWHERE := ' trim(arccode)=trim('''||v_arccode||''')';
		IF v_actid IS NOT NULL THEN
			SQLWHERE := SQLWHERE||' and trim(actid)=trim('''||v_actid||''')';
			IF v_actactive IS NOT NULL THEN
				SQLWHERE := SQLWHERE||' and actactive=TO_NUMBER('''||v_actactive||''')' ;
			END IF;
		ELSE
			IF v_actactive IS NOT NULL THEN
				SQLWHERE := SQLWHERE||' and actactive=TO_NUMBER('''||v_actactive||''')' ;
			END IF;
		END IF;
	ELSE
		IF v_actid IS NOT NULL THEN
			SQLWHERE := ' trim(actid)=trim('''||v_actid||''')';
			IF v_actactive IS NOT NULL THEN
				SQLWHERE := SQLWHERE||' and actactive=TO_NUMBER('''||v_actactive||''')' ;
			END IF;
		ELSE
			IF v_actactive IS NOT NULL THEN
				SQLWHERE := SQLWHERE||' and actactive=TO_NUMBER('''||v_actactive||''')' ;
			END IF;
		END IF;
	END IF;

	SQLSTR := SQLSTR||SQLWHERE;

	--SQLSTR := SQLSTR||' trim(arccode)=trim(''' ||v_arccode||''')'||' and actactive=TO_NUMBER('''||v_actactive||''')' ;

	--SQLSTR := 'SELECT '''||SQLSTR||''' FROM dual';

	open OUTCUR for SQLSTR;
	RETURN OUTCUR;
END NHS_LIS_ARCARDTYPE;
/
