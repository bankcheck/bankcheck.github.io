CREATE OR REPLACE FUNCTION NHS_LIS_OTMISCCODETABLE
(
	v_otctype Varchar2,
	v_otcsts varchar2
)
RETURN
	Types.cursor_type
AS
	sqlstr VARCHAR2(2000);
	outcur types.cursor_type;
BEGIN
	sqlstr:='SELECT
		'''',
		otctype,
		otcord,
		otcdesc,
		decode(otcsts,''-1'',''Y'',''0'',''N''),
		otcnum_1,
		otcchr_1,
		OTCID
		FROM OT_CODE
		WHERE
		OTCTYPE ='''|| v_otctype ||'''';
	if v_otcsts='0' then
		sqlstr:=sqlstr||' AND OTCSTS='||v_otcsts;
	end if;
	sqlstr:=sqlstr||' ORDER BY OTCORD';
	dbms_output.put_line('sql:'||sqlstr);
	OPEN outcur FOR sqlstr;
	RETURN OUTCUR;
END NHS_LIS_OTMISCCODETABLE;
/
