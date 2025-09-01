CREATE OR REPLACE FUNCTION "NHS_GET_CHG" (
	v_creditchg IN varchar :='C',
	v_pkgcode IN VARCHAR2,
	v_itmcode IN VARCHAR2,
	v_itctype IN VARCHAR2,
	v_acmcode IN VARCHAR2,
	v_cpsid   IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur Types.cursor_type;
	sqlbuff VARCHAR2(1000);
BEGIN
	sqlbuff:='select C.pkgcode, C.itmcode, C.acmcode, C.glccode, C.cpsid, C.cpspct, C.itctype, C.itcamt1, C.itcamt2, I.itmrlvl';

	if v_creditchg = 'C' then
		sqlbuff := sqlbuff || ' from creditchg C, item I where C.itmcode = I.itmcode ';
	else
		sqlbuff := sqlbuff || ' from itemchg C, item I where C.itmcode = I.itmcode ';
	end if;

	if v_pkgcode is not null then
		sqlbuff := sqlbuff || ' and C.pkgcode = ''' || v_pkgcode || '''';
	else
		sqlbuff := sqlbuff || ' and C.pkgcode is null ';
	end if;

	if v_itmcode is not null then
		sqlbuff := sqlbuff || ' and C.itmcode = ''' || v_itmcode || '''';
	else
		sqlbuff := sqlbuff || ' and C.itmcode is null ';
	end if;

	if v_itctype is not null then
		sqlbuff := sqlbuff || ' and C.itctype = ''' || v_itctype || '''';
	else
		sqlbuff := sqlbuff || ' and C.itctype is null ';
	end if;

	if v_acmcode is not null then
		sqlbuff := sqlbuff || ' and C.acmcode=''' || v_acmcode || '''';
	else
		sqlbuff := sqlbuff || ' and C.acmcode is null ';
	end if;

	if v_cpsid is not null then
		sqlbuff := sqlbuff || ' and C.cpsid = ' || TO_NUMBER(v_cpsid);
	else
		sqlbuff := sqlbuff || ' and C.cpsid is null ';
	end if;

	if v_creditchg = 'C' then
		sqlbuff := sqlbuff || ' and ( C.cicsdt IS NULL OR C.cicsdt <= TRUNC(SYSDATE) ) ';
		sqlbuff := sqlbuff || ' and ( C.cicedt IS NULL OR C.cicedt >= TRUNC(SYSDATE) ) ';
	else
		sqlbuff := sqlbuff || ' and ( C.itcsdt IS NULL OR C.itcsdt <= TRUNC(SYSDATE) ) ';
		sqlbuff := sqlbuff || ' and ( C.itcsdt IS NULL OR C.itcsdt >= TRUNC(SYSDATE) ) ';
	end if;

	OPEN outcur FOR sqlbuff;
	RETURN outcur;
end NHS_GET_CHG;
/
