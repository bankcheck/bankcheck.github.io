CREATE OR REPLACE FUNCTION "NHS_UTL_TICKETFORMAT" (
	v_TicketNo IN VARCHAR2,
	v_RegOPCat IN VARCHAR2
)
	RETURN VARCHAR2
IS
	v_NewRegOPCat VARCHAR2(1);
BEGIN
	IF GET_CURRENT_STECODE = 'TWAH' AND v_TicketNo IS NOT NULL THEN
		IF v_RegOPCat != 'U' THEN
			v_NewRegOPCat := 'S';
		ELSE
			v_NewRegOPCat := 'U';
		END IF;

		IF LENGTH(v_TicketNo) < 5 THEN
			RETURN LPAD(v_TicketNo, 4, '0') || v_NewRegOPCat;
		ELSE
			RETURN v_TicketNo || v_NewRegOPCat;
		END IF;
	ELSE
		RETURN v_TicketNo;
	END IF;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN NULL;
END;
/
