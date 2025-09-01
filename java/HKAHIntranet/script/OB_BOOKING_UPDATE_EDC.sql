create or replace
FUNCTION OB_BOOKING_UPDATE_EDC (
	i_usrid IN VARCHAR2,
	i_bookingid VARCHAR2,
	i_edc VARCHAR2
)
RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	v_count INTEGER;

	v_pbpid VARCHAR2(10);
	v_edc VARCHAR2(10);

	v_status VARCHAR2(1);

	v_errmsg VARCHAR2(100);
	v_return NUMBER;
BEGIN
	-- set default to waiting
	v_errmsg := '';

	-- extract booking info
	SELECT COUNT(1) INTO v_count FROM OB_BOOKINGS WHERE OB_BOOKING_ID = i_bookingid AND OB_ENABLED = 1;

	IF v_count = 1 THEN
		SELECT OB_PBP_ID, TO_CHAR(OB_EXPECTED_DELIVERYDATE, 'dd/MM/YYYY'), OB_BOOKING_STATUS INTO v_pbpid, v_edc, v_status FROM OB_BOOKINGS WHERE OB_BOOKING_ID = i_bookingid AND OB_ENABLED = 1;

		UPDATE OB_BOOKINGS
		SET    OB_EXPECTED_DELIVERYDATE = TO_DATE(i_edc, 'dd/MM/YYYY'),
		       OB_MODIFIED_DATE = SYSDATE, OB_MODIFIED_USER = i_usrid
		WHERE  OB_BOOKING_ID = i_bookingid AND OB_ENABLED = 1;

		IF v_status = 'B' AND v_pbpid IS NOT NULL THEN
			-- update booking to HATS
			UPDATE BEDPREBOK@IWEB
			   SET BPBHDATE = TO_DATE(i_edc, 'dd/MM/YYYY')
			 WHERE PBPID = v_pbpid;
		END IF;

		v_status := 'U';
		v_errmsg := 'ob booking EDC is updated.';
	ELSE
		v_status := 'X';
		v_errmsg := 'ob booking is invalid.';
	END IF;

	IF v_edc IS NOT NULL THEN
		v_return := OB_BOOKING_ADD_HISTORY(i_bookingid, v_pbpid, i_edc, v_status, 'OLD EDC ' || v_edc, i_usrid);
	END IF;

	commit;

	-- output
	OPEN OUTCUR FOR
		SELECT v_status, v_errmsg FROM DUAL;
	RETURN OUTCUR;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN NULL;
END OB_BOOKING_UPDATE_EDC;
/