CREATE OR REPLACE FUNCTION NHS_GET_TICKETNO (
	v_test IN varchar2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	v_date_now VARCHAR2(10);
	V_TIME_NOW VARCHAR2(10);
	i NUMBER := 0;
	v_ticketno NUMBER := -1;
	v_ticketno1 NUMBER := -1;
BEGIN
	SELECT TO_CHAR(SYSDATE,'hh:mm')
	INTO v_time_now
	FROM DUAL;

	SELECT TO_CHAR(SYSDATE,'dd/mm/yyyy')
	INTO v_date_now
	FROM DUAL;

	LOOP
		SELECT ROUND((dbms_random.value(0,1)*999) + 1, 0)
		INTO v_ticketno
		FROM dual;

		IF v_time_now < '03:00' THEN
			BEGIN
				select ticketno
				INTO v_ticketno1
				from dailyticketno
				where ticketno = v_ticketno
				and (TRUNC(regdate) = TO_DATE(v_date_now, 'dd/mm/yyyy')
				or (TRUNC(regdate) = TO_DATE(v_date_now, 'dd/mm/yyyy') - 1
				and TO_CHAR(regdate, 'HH24:MI') > '21:00'));
			EXCEPTION
			WHEN OTHERS THEN
				v_ticketno1 := v_ticketno;
				EXIT;
			END;
		ELSE
			BEGIN
				select ticketno
				INTO v_ticketno1
				from dailyticketno
				where ticketno = v_ticketno
				and TRUNC(regdate) = TO_DATE(v_date_now, 'dd/mm/yyyy');
			EXCEPTION
			WHEN OTHERS THEN
				v_ticketno1 := v_ticketno;
				EXIT;
			END;
		END IF;

		I := I + 1;
	EXIT WHEN i > 99 ;
	END LOOP;

	IF i = 100 THEN
		IF v_time_now < '03:00' THEN
			BEGIN
				select min(ticketno)
				INTO v_ticketno1
				from dailyticketno
				where ticketno not in (
					select ticketno
					from dailyticketno
					where TRUNC(regdate) = TO_DATE(v_date_now, 'dd/mm/yyyy')
					or (TRUNC(regdate) = TO_DATE(v_date_now, 'dd/mm/yyyy')-1
						and TO_CHAR(regdate,'HH24:MI') > '21:00'))
				and ticketno < 1000 and ticketno > v_ticketno;
			EXCEPTION
			WHEN OTHERS THEN
				IF v_time_now < '03:00' THEN
					BEGIN
						select min(ticketno)
						INTO v_ticketno1
						from dailyticketno
						where ticketno not in (
							select ticketno
							from dailyticketno
							where TRUNC(regdate) = TO_DATE(v_date_now, 'dd/mm/yyyy')
							or (TRUNC(regdate) = TO_DATE(v_date_now, 'dd/mm/yyyy')-1
								and TO_CHAR(regdate,'HH24:MI') > '21:00'))
							and ticketno < 1000 and ticketno > 0;
					EXCEPTION
					WHEN OTHERS THEN
						v_ticketno1 := 0;
					END;
				ELSE
					BEGIN
						select min(ticketno)
						INTO v_ticketno1
						from dailyticketno
						where ticketno not in (
							select ticketno
							from dailyticketno
							where TRUNC(regdate) = TO_DATE(v_date_now, 'dd/mm/yyyy'))
						and ticketno < 1000 and ticketno > 0;
					EXCEPTION
					WHEN OTHERS THEN
						v_ticketno1 := 0;
					END;
				END IF;
			END;
		ELSE
			BEGIN
				select min(ticketno)
				INTO v_ticketno1
				from dailyticketno
				where ticketno not in (
					select ticketno
					from dailyticketno
					where TRUNC(regdate) = TO_DATE(v_date_now, 'dd/mm/yyyy'))
				and ticketno<1000
				and ticketno > v_ticketno;
			EXCEPTION
			WHEN OTHERS THEN
				IF v_time_now < '03:00' THEN
					BEGIN
						select min(ticketno)
						INTO v_ticketno1
						from dailyticketno
						where ticketno not in (
							select ticketno
							from dailyticketno
							where TRUNC(regdate) = TO_DATE(v_date_now, 'dd/mm/yyyy')
							or (TRUNC(regdate) = TO_DATE(v_date_now, 'dd/mm/yyyy') - 1
								and TO_CHAR(regdate,'HH24:MI') > '21:00'))
							and ticketno < 1000 and ticketno > 0;
					EXCEPTION
					WHEN OTHERS THEN
						v_ticketno1 := 0;
					END;
				ELSE
					BEGIN
						select min(ticketno)
						INTO v_ticketno1
						from dailyticketno
						where ticketno not in (
							select ticketno
							from dailyticketno
							where TRUNC(regdate) = TO_DATE(v_date_now, 'dd/mm/yyyy'))
						and ticketno < 1000 and ticketno > 0;
					EXCEPTION
					WHEN OTHERS THEN
						v_ticketno1 := 0;
					END;
				END IF;
			END;
		END IF;
	END IF;
	OPEN OUTCUR FOR
		SELECT v_ticketno1 FROM DUAL;
	RETURN OUTCUR;
EXCEPTION
WHEN OTHERS THEN
	v_ticketno1 := -1;
	OPEN OUTCUR FOR
		SELECT v_ticketno1 FROM DUAL;
	RETURN OUTCUR;
END ;
/
