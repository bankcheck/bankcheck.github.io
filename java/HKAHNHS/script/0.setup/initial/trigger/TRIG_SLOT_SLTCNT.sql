create or replace 
TRIGGER TRIG_SLOT_SLTCNT
AFTER UPDATE OF SLTID, SLTCNT ON SLOT  
FOR EACH ROW  
DECLARE  
	o_errmsg	VARCHAR2(500); 
	o_errcode	NUMBER;
	susrid       VARCHAR2(20);  
	v_syslog_remark	syslog.remark%TYPE;
BEGIN  
	IF updating THEN
		IF updating('SLTCNT') THEN
			IF :NEW.SLTCNT < 0 THEN
				susrid := get_current_usrid;  
				v_syslog_remark := 'Update SLTID: ' || :OLD.SLTID || ', SLTCNT from ' || :OLD.SLTCNT ||' to ' || :NEW.SLTCNT;
				o_errcode := NHS_ACT_SYSLOG('ADD', 'Appointment', 'Booking Update', v_syslog_remark, susrid, NULL, o_errmsg);
			END IF;
		END iF;
	END IF;
END;
