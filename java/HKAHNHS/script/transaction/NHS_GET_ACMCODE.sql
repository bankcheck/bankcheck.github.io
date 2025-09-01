CREATE OR REPLACE FUNCTION "NHS_GET_ACMCODE" (
	v_acmcode in VARCHAR2,
	v_itmCode in VARCHAR2,
	v_pkgcode VARCHAR2,
	v_credit  in VARCHAR2,
	v_cpsid   in VARCHAR2
)
	return VARCHAR2
as
	r_acmcode ACM.ACMCODE%TYPE;
	sqlbuf VARCHAR2(200);
	tmpcur types.cursor_type;
begin
	r_acmcode:='';
	if v_credit = 'C' then
		-- credit
		sqlbuf := 'select max(AcmCode) from creditchg where AcmCode <= ''' || v_acmcode || '''';
	else
		-- not credit
		sqlbuf := 'select max(AcmCode) from itemchg where AcmCode <= ''' || v_acmcode || '''';
	end if;
	if v_itmCode is null or trim(v_itmCode) = '' then
		sqlbuf := sqlbuf || ' and pkgcode = ''' || v_pkgcode || '''';
	else
		sqlbuf := sqlbuf || ' and itmcode = ''' || v_itmCode || '''';
		if v_pkgcode is null or trim(v_pkgcode) = '' then
			sqlbuf := sqlbuf || ' and pkgcode is null ';
		else
			sqlbuf := sqlbuf || ' and pkgcode = ''' || v_pkgcode || '''';
		end if;
		if v_cpsid is null or trim(v_cpsid) = '' then
			sqlbuf := sqlbuf || ' and cpsid is null ';
		else
			sqlbuf := sqlbuf || ' and cpsid = ' || to_number(v_cpsid);
		end if;
	end if;
	if v_credit = 'C' then
		sqlbuf := sqlbuf || ' and ( cicsdt IS NULL OR cicsdt <= TRUNC(SYSDATE) ) ';
		sqlbuf := sqlbuf || ' and ( cicedt IS NULL OR cicedt >= TRUNC(SYSDATE) ) ';
	else
		sqlbuf := sqlbuf || ' and ( itcsdt IS NULL OR itcsdt <= TRUNC(SYSDATE) ) ';
		sqlbuf := sqlbuf || ' and ( itcsdt IS NULL OR itcsdt >= TRUNC(SYSDATE) ) ';
	end if;

	open tmpcur for sqlbuf;
	LOOP
		FETCH tmpcur INTO r_acmcode;
		EXIT WHEN tmpcur%NOTFOUND;
	END LOOP;
	close tmpcur;
	if r_acmcode is null then
--		sqlbuf := replace(sqlbuf, 'and cpsid = ' || to_number(v_cpsid), 'and cpsid is null');
		open tmpcur for sqlbuf;
		LOOP
			FETCH tmpcur INTO r_acmcode;
			EXIT WHEN tmpcur%NOTFOUND;
		END LOOP;
		close tmpcur;
	end if;
	return(r_acmcode);
end NHS_GET_ACMCODE;
/
