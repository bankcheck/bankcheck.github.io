create or replace
FUNCTION OB_BOOKING_CANCEL ( i_usrid IN VARCHAR2, i_pbpid IN VARCHAR2, i_cancelreason IN VARCHAR2 )
RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	v_bookingid INTEGER;
	v_count INTEGER;
	v_status VARCHAR2(1);
	v_errmsg VARCHAR2(100);
	v_return INTEGER;
BEGIN
	v_errmsg := '';

	-- update bedprebok table
	IF i_pbpid IS NOT NULL THEN
		v_return := NHS_ACT_BEDPREBOKDEL ('DEL', i_pbpid, i_usrid, v_errmsg);
	END IF;

	-- extract booking info
	SELECT COUNT(1) INTO v_count FROM OB_BOOKINGS WHERE OB_PBP_ID = i_pbpid AND OB_ENABLED = 1;
	IF v_count = 1 THEN
		SELECT OB_BOOKING_ID, OB_BOOKING_STATUS INTO v_bookingid, v_status FROM OB_BOOKINGS WHERE OB_PBP_ID = i_pbpid AND OB_ENABLED = 1;
		IF v_status != 'X' THEN
			-- update table
			UPDATE OB_BOOKINGS
			SET    OB_BOOKING_STATUS = 'X', OB_PBP_ID = '', OB_CANCEL_REASON = i_cancelreason
			WHERE  OB_PBP_ID = i_pbpid AND OB_ENABLED = 1 AND OB_BOOKING_STATUS != 'X';

			v_status := 'X';
			v_errmsg := '';
		ELSE
			v_errmsg := 'ob booking is already cancelled.';
		END IF;
	ELSE
		-- create dummy ob booking
		v_bookingid := OB_HATS_2_BOOKING( i_usrid, i_pbpid, 'X', i_cancelreason);
	END IF;

	-- add history
	IF v_errmsg = '' THEN
		v_return := OB_BOOKING_ADD_HISTORY(v_bookingid, i_pbpid, '', 'X', i_cancelreason, i_usrid);
	END IF;

	COMMIT;

	-- output
	OPEN OUTCUR FOR
		SELECT v_bookingid, v_status, v_errmsg FROM DUAL;
	RETURN OUTCUR;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN NULL;
END OB_BOOKING_CANCEL;
/