create or replace
function "NHS_CMB_OT_CANCEL_APP" (
	v_ot_type VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
	sqlbuf varchar2(200);
begin
	sqlbuf := 'select OTCID, OTCDESC ';
	sqlbuf := sqlbuf || 'FROM OT_CODE ';
	sqlbuf := sqlbuf || 'WHERE  ROWNUM < 100 ';

	if V_OT_TYPE is not null then
		sqlbuf := sqlbuf || 'and  OTCTYPE = ''' || v_ot_type || '''';
	END IF;

		sqlbuf := sqlbuf || 'ORDER BY OTCID ';

	OPEN outcur FOR sqlbuf;
	Return Outcur;
END NHS_CMB_OT_CANCEL_APP;
/