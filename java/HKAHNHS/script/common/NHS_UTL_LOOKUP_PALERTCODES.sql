create or replace
FUNCTION NHS_UTL_LOOKUP_PALERTCODES (
	v_patno varchar2
)
	RETURN varchar2
IS
	l_tmp VARCHAR2(500);
	v_errmsg VARCHAR2(1000);
begin
	l_tmp := '';
	
	FOR rec IN (select a.altcode from pataltlink p,alert a where p.usrid_c is null and p.altid=a.altid and p.patno=v_patno)
	loop
    IF rec.altcode is not null THEN
			if l_tmp is not null then
				l_tmp := l_tmp || ', ';
			end if;
			l_tmp := l_tmp || rec.altcode;
		END IF;
	END LOOP;

	RETURN l_tmp;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN l_tmp;
END NHS_UTL_LOOKUP_PALERTCODES;
/
