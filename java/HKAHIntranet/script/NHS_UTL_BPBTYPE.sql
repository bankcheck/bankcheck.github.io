create or replace
FUNCTION "NHS_UTL_BPBTYPE"(
	v_EDC IN VARCHAR2)
RETURN VARCHAR2
AS
	v_CursorType TYPES.CURSOR_TYPE;
	v_maxMPreBok VARCHAR2(50);
	v_maxDPreBok VARCHAR2(50);
	v_monthlyWaitingStarts VARCHAR2(50);
	v_sOBWaitingAuto VARCHAR2(50);
	v_curMPreBok INTEGER;
	v_obWaitingcnt INTEGER;
	v_curMPreBokP_B INTEGER;
	v_curMPreBokP_W INTEGER;
	v_curDPreBok INTEGER;
	v_curDpreBok_W INTEGER;
	v_curDPreBokP_B INTEGER;
	v_curDPreBokP_W INTEGER;
	v_curMPreBok_MC INTEGER;
	v_curMPreBok_HK INTEGER;
	v_curMPreBok_ALL INTEGER;
	v_curYPreBok_MC INTEGER;
	v_curYPreBok_HK INTEGER;
	v_curYPreBok_ALL INTEGER;
	v_ObBokStatus VARCHAR2(1);
	v_errmsg VARCHAR2(100);
	m_month_ok BOOLEAN;
	m_day_ok BOOLEAN;
BEGIN
	v_ObBokStatus := 'B';
	v_errmsg := '';
	m_month_ok := FALSE;
	m_day_ok := FALSE;

	v_CursorType := NHS_GET_BOOKINGCOUNT(v_EDC, '');
	LOOP
		FETCH v_CursorType INTO
			v_maxMPreBok,
			v_maxDPreBok,
			v_monthlyWaitingStarts,
			v_sOBWaitingAuto,
			v_curMPreBok,
			v_obWaitingcnt,
			v_curMPreBokP_B,
			v_curMPreBokP_W,
			v_curDPreBok,
			v_curDpreBok_W,
			v_curDPreBokP_B,
			v_curDPreBokP_W,
			v_curMPreBok_MC,
			v_curMPreBok_HK,
			v_curMPreBok_ALL,
			v_curYPreBok_MC,
			v_curYPreBok_HK,
			v_curYPreBok_ALL;
		EXIT WHEN v_CursorType%NOTFOUND;
	END LOOP;

	IF v_maxMPreBok < 0 THEN
		-- monthly limit is not set
		m_month_ok := TRUE;
	ELSE
		m_month_ok := v_maxMPreBok - v_curMPreBok - v_curMPreBokP_B - v_curMPreBokP_W - v_obWaitingcnt > 0;
	END IF;

	IF v_maxDPreBok < 0 THEN
		-- daily limit is not set
		m_day_ok := TRUE;
	ELSE
		m_day_ok := v_maxDPreBok - v_curDPreBok - v_curDPreBokP_B > 0;
	END IF;

	IF m_day_ok = FALSE THEN
		v_errmsg := 'Daily quota full.  Please select another EDC!';
	ELSIF m_month_ok = FALSE THEN
		v_errmsg := 'Monthly quota full.  Please select another EDC!';
	ELSE
		IF v_sOBWaitingAuto = 'NO' THEN
			If v_curMPreBok >= v_monthlyWaitingStarts - 1 AND v_obWaitingcnt < v_maxMPreBok - v_monthlyWaitingStarts + 1 THEN
				-- B=FALSE, W=TRUE
				v_ObBokStatus := 'W';
			ELSIF v_curMPreBok >= v_monthlyWaitingStarts - 1 AND v_obWaitingcnt >= v_maxMPreBok - v_monthlyWaitingStarts + 1 THEN
				-- B=FALSE, W=FALSE
				v_ObBokStatus := 'X';
				v_errmsg := 'Both Booking & Waiting Queue is full, you cannot make any booking.';
			ELSIF v_curMPreBok < v_monthlyWaitingStarts - 1 AND v_obWaitingcnt < v_maxMPreBok - v_monthlyWaitingStarts + 1 THEN
				-- B=TURE, W=TRUE
				v_ObBokStatus := 'B';
			ELSIF v_curMPreBok < v_monthlyWaitingStarts - 1 AND v_obWaitingcnt >= v_maxMPreBok - v_monthlyWaitingStarts + 1 THEN
				-- B=TRUE, W=FALSE
				v_ObBokStatus := 'B';
			END IF;
		ELSE
			IF v_curMPreBok < v_monthlyWaitingStarts - 1 THEN
				v_ObBokStatus := 'B';
			ELSE
				v_ObBokStatus := 'W';
			END IF;
		END IF;
	END IF;

	RETURN v_ObBokStatus;
END NHS_UTL_BPBTYPE;