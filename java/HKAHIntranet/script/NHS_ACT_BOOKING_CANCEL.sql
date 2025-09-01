create or replace
FUNCTION "NHS_ACT_BOOKING_CANCEL" (
	i_action IN VARCHAR2,
	i_bkgid  IN VARCHAR2,
	i_usrid  IN VARCHAR2,
	o_errmsg OUT VARCHAR2)
RETURN  NUMBER
AS
	v_noOfRec NUMBER;
	cnt       NUMBER;
	v_schid   NUMBER;
	v_sltid   NUMBER;
BEGIN
	v_noOfRec := -1;
	o_errmsg := 'OK';

	SELECT count(1) INTO v_noOfRec FROM BOOKING@IWEB WHERE bkgid = TO_NUMBER(i_bkgid);
	IF v_noOfRec > 0 THEN
		UPDATE BOOKING@IWEB SET bkgsts='C', cancelby=i_usrid where bkgid = TO_NUMBER(i_bkgid);
		SELECT bkgscnt, schid, sltid INTO cnt,v_schid,v_sltid FROM booking@IWEB WHERE bkgid = TO_NUMBER(i_bkgid);
		UPDATE schedule@IWEB SET SCHCNT = SCHCNT - cnt WHERE schid = v_schid;
		For var in 1..cnt LOOP
			UPDATE SLOT@IWEB
			SET    SLTCNT = SLTCNT - 1
			WHERE  SCHID = v_schid
			AND    SLTID = v_sltid + var - 1;
		END LOOP;
	ELSE
		v_noOfRec := -1;
		o_errmsg := 'Fail to cancel the appointment.';
	END IF;

	-- cancel OB Booking if necessary
	SELECT count(1) INTO v_noOfRec FROM OB_BOOKINGS WHERE OB_BKG_ID = TO_NUMBER(i_bkgid);
	IF v_noOfRec > 0 THEN
		UPDATE OB_BOOKINGS SET OB_ENABLED = 0 WHERE OB_BKG_ID = TO_NUMBER(i_bkgid);
	END IF;

	COMMIT;

	RETURN v_noOfRec;
EXCEPTION
WHEN   OTHERS   THEN
	ROLLBACK;
	o_errmsg := 'Fail to cancel the appointment.';
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	return -1;
END NHS_ACT_BOOKING_CANCEL;