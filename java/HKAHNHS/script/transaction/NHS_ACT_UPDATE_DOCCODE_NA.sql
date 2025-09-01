CREATE OR REPLACE FUNCTION NHS_ACT_UPDATE_DOCCODE_NA (
	i_action  IN  VARCHAR2,
	i_slpno   IN  slip.SlpNo%TYPE,
	i_PatNo   IN  reg.patno%TYPE,
	i_doccode IN  slip.doccode%TYPE,
	i_UsrId   IN  rlock.USRID%TYPE,
	i_ComputerName IN rlock.RLKMAC%TYPE,
	O_ERRMSG OUT VARCHAR2
)
	RETURN NUMBER
IS
	O_ERRCODE NUMBER;
	o_retcode NUMBER;
	v_NOOFREC NUMBER;
	OUTCUR TYPES.CURSOR_TYPE;
	v_stnid sliptx.stnid%TYPE;
	v_doccode slip.doccode%TYPE;
	v_doccode_o slip.doccode%TYPE;
	
	DOCCODE_NA slip.doccode%TYPE := '999';
	
	empty_slpno exception;
    empty_patno exception;
    empty_doccode exception;
    empty_usrid exception;
    empty_ComputerName exception;
    lock_slip_fail exception;
    slip_not_found exception;
    update_reg_slip_doccode_fail exception;
    update_sliptx_doccode_fail exception;
    unlock_slip_fail exception;
BEGIN
	o_errcode := 0;
	O_ERRMSG := 'OK';
	o_retcode := 0;
	v_doccode_o := '999';
	
	IF i_slpno IS NULL THEN
		raise empty_slpno;
	END IF;
	
	IF i_patno IS NULL THEN
		raise empty_patno;
	END IF;
	
	IF i_doccode IS NULL THEN
		raise empty_doccode;
	END IF;	
	
	IF i_UsrId IS NULL THEN
		raise empty_usrid;
	END IF;
	
	IF i_ComputerName IS NULL THEN
		raise empty_ComputerName;
	END IF;
	
	o_retcode := NHS_ACT_RECORDLOCK('ADD', 'Slip', i_SlpNo, i_ComputerName, i_UsrId, O_ERRMSG);
	--DBMS_OUTPUT.PUT_LINE('lock slpno=' || i_SlpNo || ', o_retcode=' || o_retcode);
	
	if o_retcode < 0 then
		raise lock_slip_fail;
	end if;
	
	-- update slip, reg
	select count(1) into v_NOOFREC from slip where slpno = i_SlpNo;
	if v_NOOFREC > 0 then
		select doccode into v_doccode from slip where slpno = i_SlpNo;
		if v_doccode = DOCCODE_NA THEN
			o_retcode := NHS_ACT_TXNDOCTOR_MODIFY('MOD', i_SlpNo, i_PatNo, i_doccode, i_UsrId, O_ERRMSG);
			--DBMS_OUTPUT.PUT_LINE('update slip,reg slpno=' || i_SlpNo || ', o_retcode=' || o_retcode);
			
			if o_retcode < 0 then
				raise update_reg_slip_doccode_fail;
			end if;
		END IF;
	else
		raise slip_not_found;
	end if;
	
	-- update sliptx
	OPEN OUTCUR FOR 
		SELECT STNID FROM SLIPTX WHERE SLPNO = i_SlpNo AND DOCCODE = DOCCODE_NA;
	LOOP
		FETCH OUTCUR INTO v_stnid;
		EXIT WHEN OUTCUR%NOTFOUND;
		
		o_retcode := NHS_ACT_TXNSLIPTX_MODIFY('MOD', 'UPDATE', i_SlpNo, v_stnid, null, null, null, i_doccode, null, null, null, null, i_UsrId, O_ERRMSG);
		--DBMS_OUTPUT.PUT_LINE('update sliptx.stnid=' || v_stnid || ', o_retcode=' || o_retcode);
		
		if o_retcode < 0 then
			exit;
		else 
			UPDATE SLPPAYDTL SET DOCCODE = i_doccode WHERE SLPNO = i_SlpNo AND STNID = v_stnid AND SPHID IS NULL; -- not yet go to actual report
			UPDATE SPECOMDTL SET DOCCODE = i_doccode WHERE SLPNO = i_SlpNo AND STNID = v_stnid AND SYHID IS NULL; -- not yet go to actual report
		end if;
	END LOOP;
	CLOSE OUTCUR;		
	
	if o_retcode < 0 then
		raise update_sliptx_doccode_fail;
	end if;
	
	o_retcode := NHS_ACT_RECORDUNLOCK('DEL', 'Slip', i_SlpNo, i_ComputerName, i_UsrId, O_ERRMSG);
	if o_retcode < 0 then
		raise unlock_slip_fail;
	end if;
	
	RETURN o_errcode;
EXCEPTION
when empty_slpno then
	o_errcode := -20;
	o_errmsg := 'Slpno is empty';
	RETURN O_ERRCODE;	
when empty_patno then
	o_errcode := -21;
	o_errmsg := 'Patno is empty';
	RETURN O_ERRCODE;	
when empty_doccode then
	o_errcode := -22;
	o_errmsg := 'Doccode is empty';
	RETURN O_ERRCODE;	
when empty_usrid then
	o_errcode := -23;
	o_errmsg := 'Usrid is empty';
	RETURN O_ERRCODE;	
when empty_ComputerName then
	o_errcode := -24;
	o_errmsg := 'Computer name is empty';
	RETURN O_ERRCODE;
when slip_not_found then
	o_errcode := -12;
	o_errmsg := 'Slpno:' || i_slpno || ' not found';
	RETURN O_ERRCODE;
when lock_slip_fail then
	ROLLBACK;
	o_errcode := -10;
	RETURN O_ERRCODE;	
when unlock_slip_fail then
	ROLLBACK;
	o_errcode := -11;
	RETURN O_ERRCODE;	
when update_reg_slip_doccode_fail then
	ROLLBACK;
	o_errcode := -30;
	RETURN O_ERRCODE;	
when update_sliptx_doccode_fail then
	ROLLBACK;
	o_errcode := -31;
	RETURN O_ERRCODE;
WHEN OTHERS THEN
	ROLLBACK;
	o_errcode := -1;
	o_errmsg := SQLERRM;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN O_ERRCODE;
END NHS_ACT_UPDATE_DOCCODE_NA;
/
