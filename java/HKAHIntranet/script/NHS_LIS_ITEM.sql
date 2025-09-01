create or replace
FUNCTION "NHS_LIS_ITEM"
(
	v_ITMCODE ITEM.ITMCODE@IWEB%TYPE,
	v_ITMNAME ITEM.ITMNAME@IWEB%TYPE,
	v_ITMTYPE ITEM.ITMTYPE@IWEB%TYPE,
	v_DPTCODE ITEM.DPTCODE@IWEB%TYPE,
	v_DSCCODE ITEM.DSCCODE@IWEB%TYPE,
	v_ITMCAT ITEM.ITMCAT@IWEB%TYPE
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
	sqlbuf varchar2(500);
BEGIN
	sqlbuf := 'select I.ITMCODE,I.ITMNAME,I.ITMCNAME,I.ITMTYPE,I.ITMRLVL,I.DSCCODE,DS.DSCDESC,I.DPTCODE,D.DPTNAME,I.STECODE, ';
	sqlbuf := sqlbuf || ' I.ITMPOVERRD,I.ITMDOCCR,I.ITMCAT,I.ITMGRP ';
	sqlbuf := sqlbuf || ' from ITEM@IWEB I,DPSERV@IWEB DS,DEPT@IWEB D where I.DSCCODE=DS.DSCCODE AND I.DPTCODE=D.DPTCODE(+) ';
	if v_ITMCAT is not null then
     	sqlbuf := sqlbuf || 'AND I.ITMCAT=''' || v_ITMCAT || '''';
  end if;
  IF v_ITMCODE IS NOT NULL THEN
		sqlbuf := sqlbuf || ' AND I.ITMCODE=''' || v_ITMCODE || '''';
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
	sqlbuf := sqlbuf || ' ORDER BY I.ITMCODE';
	OPEN outcur FOR sqlbuf;
	RETURN OUTCUR;
END NHS_LIS_ITEM;