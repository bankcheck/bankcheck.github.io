CREATE OR REPLACE FUNCTION "NHS_LIS_ITEM"
(
	v_ITMCODE ITEM.ITMCODE%TYPE,
	v_ITMNAME ITEM.ITMNAME%TYPE,
	v_ITMTYPE ITEM.ITMTYPE%TYPE,
	v_DPTCODE ITEM.DPTCODE%TYPE,
	v_DSCCODE ITEM.DSCCODE%TYPE,
	v_ITMCAT ITEM.ITMCAT%TYPE,
	V_ITMCAT_EXCL 	VARCHAR	-- 'C', 'D'
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
	sqlbuf varchar2(500);
BEGIN
	sqlbuf := 'select I.ITMCODE,I.ITMNAME,I.ITMCNAME,I.ITMTYPE,I.ITMRLVL,I.DSCCODE,DS.DSCDESC,I.DPTCODE,D.DPTNAME,I.STECODE, ';
	sqlbuf := sqlbuf || ' I.ITMPOVERRD,I.ITMDOCCR,I.ITMCAT,I.ITMGRP ';
	sqlbuf := sqlbuf || ' from ITEM I,DPSERV DS,DEPT D where I.DSCCODE=DS.DSCCODE AND I.DPTCODE=D.DPTCODE(+) ';
	if v_ITMCAT is not null then
     	sqlbuf := sqlbuf || 'AND I.ITMCAT=''' || v_ITMCAT || '''';
  end if;
  IF v_ITMCODE IS NOT NULL THEN
		sqlbuf := sqlbuf || ' AND I.ITMCODE like ''' || v_ITMCODE || '%''';
	END IF;
	IF v_ITMNAME IS NOT NULL THEN
		sqlbuf := sqlbuf || ' AND I.ITMNAME like ''%' || v_ITMNAME || '%''';
	END IF;
	IF v_ITMTYPE IS NOT NULL THEN
		sqlbuf := sqlbuf || ' AND I.ITMTYPE=''' || v_ITMTYPE || '''';
	END IF;
	IF v_DPTCODE IS NOT NULL THEN
		sqlbuf := sqlbuf || ' AND I.DPTCODE=''' || v_DPTCODE || '''';
	END IF;
	IF v_DSCCODE IS NOT NULL THEN
		sqlbuf := sqlbuf || ' AND I.DSCCODE=''' || v_DSCCODE || '''';
	END IF;
	IF V_ITMCAT_EXCL IS NOT NULL THEN
		sqlbuf := sqlbuf || ' AND ITMCAT<> ''' || V_ITMCAT_EXCL || '''';
	END IF;
	sqlbuf := sqlbuf || ' ORDER BY I.ITMCODE';
	OPEN outcur FOR sqlbuf;
	RETURN OUTCUR;
END NHS_LIS_ITEM;
/
