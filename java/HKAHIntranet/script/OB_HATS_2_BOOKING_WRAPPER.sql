create or replace
FUNCTION OB_HATS_2_BOOKING_WRAPPER ( i_usrid IN VARCHAR2, i_pbpid IN VARCHAR2, i_status IN VARCHAR2, i_cancelreason IN VARCHAR2 )
RETURN TYPES.CURSOR_TYPE
AS
  	OUTCUR TYPES.CURSOR_TYPE;
	v_bookingid INTEGER;
BEGIN
	v_bookingid := OB_HATS_2_BOOKING (i_usrid, i_pbpid, i_status, i_cancelreason);

	-- output
	OPEN OUTCUR FOR
		SELECT v_bookingid FROM DUAL;
  RETURN OUTCUR;
END OB_HATS_2_BOOKING_WRAPPER;
/
