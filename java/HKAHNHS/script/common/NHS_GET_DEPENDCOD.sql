CREATE OR REPLACE FUNCTION NHS_GET_DEPENDCOD (
	v_year  VARCHAR2,
	v_patno VARCHAR2
)
	RETURN NUMBER
AS
  	v_AMT NUMBER;
BEGIN
	select sum(st.stnnamt) INTO v_AMT
	from   sliptx st
	inner join slip s on st.slpno = s.slpno
	inner join patient_extra p on s.patno = p.patno
	inner join pataltlink pl on p.patno = pl.patno
	inner join alert a on pl.altid = a.altid
	where  s.slpno like v_year || '%'
	and    st.itmcode = 'COD'
	and    a.altcode = 'DRD'
	and    p.patmiscrmk like '%' || v_patno;

	IF v_AMT IS NOT NULL THEN
		RETURN v_AMT;
	ELSE
		RETURN 0;
	END IF;
END;
/
