create or replace PROCEDURE PROC_EPO_CANCEL_APPROVED(
	as_reqNo IN varchar2,
	as_mod_by IN varchar2
)
IS
	ls_poNo EPO_PO_M.PO_NO%TYPE;
	li_count number := 0;
	ld_insDate date := sysdate;
	CONST_REQ_STATUS_CANCEL varchar2(1) := 'C';
	ERR_PO_NOT_CANCEL EXCEPTION;
BEGIN
	-- Check if PO is cancelled
	SELECT PO_NO
	INTO ls_poNo
	FROM EPO_PO_M
	WHERE REQ_NO = as_reqNo;

	SELECT COUNT(1)
	INTO li_count
	FROM EPO_PO_M
	WHERE REQ_NO = as_reqNo
		AND SOUNDEX(PO_NO) IN ('C240', 'C243', 'C254', 'C524');	-- variation/typo of 'cancel' wordings

	IF li_count = 0 THEN
		RAISE ERR_PO_NOT_CANCEL;
	END IF;
	
	-- cancel epo
	UPDATE EPO_REQUEST_M 
	SET REQ_STATUS = CONST_REQ_STATUS_CANCEL, MOD_DATE = ld_insDate, MOD_BY = as_mod_by
	WHERE REQ_NO = as_reqNo;
	
	INSERT INTO EPO_REQUEST_LOG(EPO_NO, RECORD_STATUS, INSERT_BY, INSERT_DATE) 
	VALUES (as_reqNo, CONST_REQ_STATUS_CANCEL, as_mod_by, ld_insDate);
	
	UPDATE EPO_REQUEST_D
	SET MOD_BY = as_mod_by, MOD_DATE = ld_insDate
	WHERE REQ_NO = as_reqNo;
EXCEPTION 
WHEN ERR_PO_NOT_CANCEL THEN
	ROLLBACK;
	dbms_output.put_line(as_reqNo||' PO is active. PO no.:' || ls_poNo);
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line(SQLCODE||' -ERROR- '||SQLERRM);
END;
/