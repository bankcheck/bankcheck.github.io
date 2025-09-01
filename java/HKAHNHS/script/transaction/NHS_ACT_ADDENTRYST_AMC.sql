CREATE OR REPLACE FUNCTION NHS_ACT_ADDENTRYST(
    v_action           IN VARCHAR2,
    i_usrid            IN VARCHAR2,
	v_ADDENTRY		   IN TEMPLATE_OBJ_TAB,
    o_errmsg           OUT VARCHAR2
)
	RETURN NUMBER
AS
    o_errcode  NUMBER;
    
    -- DEBUG start
	o_errcode2	NUMBER;
	v_syslog_remark	syslog.remark%TYPE;
	O_ERRMSG2 VARCHAR2(100);
	-- DEBUG end
	
BEGIN
	o_errmsg := 'OK';
	o_errcode := 0;

	IF v_action = 'ADD' OR v_action = 'MOD' THEN
		FOR I IN 1..v_ADDENTRY.COUNT LOOP
			-- DEBUG start
			begin
				v_syslog_remark := 'I=' || I || 
					',01=' || V_ADDENTRY(I).COLUMN01 || ',02=' || V_ADDENTRY(I).COLUMN02 || ',03=' || V_ADDENTRY(I).COLUMN03 || ',04=' || V_ADDENTRY(I).COLUMN04 ||
					',05=' || V_ADDENTRY(I).COLUMN05 || ',06=' || V_ADDENTRY(I).COLUMN06 || ',07=' || V_ADDENTRY(I).COLUMN07 || ',08=' || V_ADDENTRY(I).COLUMN08 ||
					',09=' || V_ADDENTRY(I).COLUMN09 || ',10=' || V_ADDENTRY(I).COLUMN10 || ',11=' || V_ADDENTRY(I).COLUMN11 || ',12=' || V_ADDENTRY(I).COLUMN12 ||
					',13=' || V_ADDENTRY(I).COLUMN13 || ',14=' || V_ADDENTRY(I).COLUMN14 || ',15=' || V_ADDENTRY(I).COLUMN15 || ',16=' || V_ADDENTRY(I).COLUMN16 ||
					',17=' || V_ADDENTRY(I).COLUMN17 || ',18=' || V_ADDENTRY(I).COLUMN18 || ',19=' || V_ADDENTRY(I).COLUMN19 || ',20=' || V_ADDENTRY(I).COLUMN20 ||
					',21=' || V_ADDENTRY(I).COLUMN21 || ',22=' || V_ADDENTRY(I).COLUMN22 || ',23=' || V_ADDENTRY(I).COLUMN23 || ',24=' || V_ADDENTRY(I).COLUMN24;
				o_errcode2 := NHS_ACT_SYSLOG('ADD', 'Transction', 'Add Charge (NHS_ACT_ADDENTRYST)', v_syslog_remark, i_usrid, NULL, o_errmsg2);
				commit;
			end;
			-- DEBUG end
			
			o_errcode := NHS_UTL_ADDENTRY(
				V_ADDENTRY(I).COLUMN01,
				V_ADDENTRY(I).COLUMN02,
				V_ADDENTRY(I).COLUMN03,
				V_ADDENTRY(I).COLUMN04,
				TO_NUMBER(V_ADDENTRY(I).COLUMN05),
				TO_NUMBER(V_ADDENTRY(I).COLUMN06),
				V_ADDENTRY(I).COLUMN07,
				TO_NUMBER(V_ADDENTRY(I).COLUMN08),
				V_ADDENTRY(I).COLUMN09,
				TO_NUMBER(V_ADDENTRY(I).COLUMN10),
				V_ADDENTRY(I).COLUMN11,
				TO_DATE(V_ADDENTRY(I).COLUMN12, 'DD/MM/YYYY HH24:MI:SS'),
				TO_DATE(V_ADDENTRY(I).COLUMN13, 'DD/MM/YYYY HH24:MI:SS'),
				V_ADDENTRY(I).COLUMN14,
				V_ADDENTRY(I).COLUMN15,
				V_ADDENTRY(I).COLUMN16,
				TO_NUMBER(V_ADDENTRY(I).COLUMN17),
				CASE WHEN V_ADDENTRY(I).COLUMN18 = '-1' THEN TRUE ELSE FALSE END,
				V_ADDENTRY(I).COLUMN19,
				TO_NUMBER(V_ADDENTRY(I).COLUMN20),
				CASE WHEN V_ADDENTRY(I).COLUMN21 = '-1' THEN TRUE ELSE FALSE END,
				V_ADDENTRY(I).COLUMN22,
				TO_NUMBER(V_ADDENTRY(I).COLUMN23),
				TO_NUMBER(V_ADDENTRY(I).COLUMN24),
				V_ADDENTRY(I).COLUMN25,
				V_ADDENTRY(I).COLUMN26,
				NULL,
				i_usrid
			);

			IF o_errcode < 0 THEN
				ROLLBACK;
				o_errmsg := 'insert fail.';
				RETURN o_errcode;
			END IF;
		END LOOP;
	ELSE
		o_errmsg := 'parameter error.';
		o_errcode := -1;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ErrMsg := SQLERRM || o_ErrMsg;

	o_errcode := -999;
	return o_errcode;
END NHS_ACT_ADDENTRYST;
/
