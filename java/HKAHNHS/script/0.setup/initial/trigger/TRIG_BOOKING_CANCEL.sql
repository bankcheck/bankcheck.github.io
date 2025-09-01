create or replace 
TRIGGER TRIG_BOOKING_CANCEL
AFTER UPDATE OF BKGSTS ON BOOKING  
FOR EACH ROW  
DECLARE  
	o_errmsg	VARCHAR2(500); 
	o_errcode	NUMBER;
	susrid       VARCHAR2(20);  
	v_syslog_remark	syslog.remark%TYPE;
BEGIN  
	IF updating THEN
		IF updating('BKGSTS') THEN
			IF :NEW.BKGSTS = 'C' THEN
				susrid := get_current_usrid;  		
				v_syslog_remark := 'Update BKGID: ' || :OLD.BKGID || ', BKGSTS from ' || :OLD.BKGSTS ||' to ' || :NEW.BKGSTS;
				IF :OLD.BKGFDATE IS NOT NULL THEN
					v_syslog_remark := v_syslog_remark || ', BKGFDATE = ' || to_char(:OLD.BKGFDATE, 'dd/mm/yyyy hh24:mi:ss');
				END IF;
				o_errcode := NHS_ACT_SYSLOG('ADD', 'Appointment', 'Cancel Booking', v_syslog_remark, susrid, NULL, o_errmsg);
			END IF;
		END iF;
	END IF;
END;
