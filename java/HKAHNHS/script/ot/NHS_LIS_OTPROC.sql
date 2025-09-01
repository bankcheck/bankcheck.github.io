create or replace FUNCTION NHS_LIS_OTPROC (
	v_otpsts IN VARCHAR2
)
	return Types.cursor_type
AS
	sqlstr varchar2(2000);
	outcur types.cursor_type;
begin
	sqlstr := 'select '''', otpcode, otpsform, otpdesc, decode(otptype, ''M'', ''Major'', ''N'', ''Minor'', ''U'', ''Ultra Major''),
			pkgcode, otpsurcharge,
			otpdur, otpint, decode(otpsts, -1, ''Y'', ''N''), otpid, ''''
		FROM OT_PROC ';
	if v_otpsts = '-1' then
		sqlstr := sqlstr || ' WHERE otpsts=-1';
	end if;
	sqlstr := sqlstr || ' ORDER BY OTPCODE';

	OPEN outcur FOR sqlstr;
	return outcur;
end NHS_LIS_OTPROC;
/
