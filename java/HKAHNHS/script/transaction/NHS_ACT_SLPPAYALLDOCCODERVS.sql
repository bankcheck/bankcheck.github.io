create or replace
FUNCTION "NHS_ACT_SLPPAYALLDOCCODERVS" (
        v_action    IN VARCHAR2,
        v_stnid     IN VARCHAR2,
        v_docCode   IN VARCHAR2,
        o_errmsg    OUT VARCHAR2
)
	return varchar2
AS
	o_errcode NUMBER;
	v_stntype sliptx.stntype%TYPE;
	memDocCode sliptx.DOCCODE%TYPE;
	V_itmtype sliptx.itmtype%TYPE;
	SQLSTR VARCHAR2(1000);
	update_str VARCHAR2(500);
	TYPE_DOCTOR VARCHAR2(1) := 'D';
  	O_ERRCODE2	NUMBER;
  	O_ERRMSG2 VARCHAR2(100);
BEGIN
  	o_errcode := 0;
  	o_errmsg := 'OK';

  	if v_docCode IS NOT NULL then
    		update_str := 'DocCode = ''' || v_docCode || '''';
  	end if;

  	if v_stntype IS NOT NULL then
    		if update_str IS NOT NULL then
      			update_str := update_str || ', stntdate = ''' || v_stntype ||'''';
    		else
      			update_str := 'stntdate = ''' || v_stntype ||'''';
    		end if;
  	end if;
  	SQLSTR := 'update sliptx set ' || update_str || ' where stnid = ''' || v_stnid || '''  and stnadoc is null ';

  	if v_docCode IS NOT NULL then
    		select stntype, doccode, itmtype
    		INTO v_stntype, memDocCode, V_itmtype
    		from sliptx
    		where stnid = v_stnid;

    		if memDocCode = v_docCode then
      			o_errcode := 0;
    		else
      			if v_itmtype = TYPE_DOCTOR then
        			o_errcode := NHS_ACT_SLPPAYALLSLIPTXREVERSE(v_action, v_stnid, v_stntype, o_errmsg);
      			end if;
    		end if;
  	end if;

  	IF O_ERRCODE >= 0 THEN
       O_ERRCODE2 := NHS_ACT_SYSLOG('ADD', 'SLPPAYALLDOCCODERVS', 'update doctor code', 'Update stnid:'||V_STNID||' from Doctor '||MEMDOCCODE||' to '||V_DOCCODE, NULL, NULL, O_ERRMSG2);
    		EXECUTE IMMEDIATE SQLSTR;
    		if sqlcode <> 0  then
      			rollback;
      			o_errcode := -1;
      			o_errmsg := 'SQL Error: '||SQLCODE||' - '||SQLERRM;
    		end if;
  	end if;

  	RETURN o_errcode;
end NHS_ACT_SLPPAYALLDOCCODERVS;
/
