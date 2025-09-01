CREATE OR REPLACE PROCEDURE NHS_UTL_RESERVE_NEW_PATNO
IS
	o_errCode VARCHAR2(10);
	o_errmsg VARCHAR2(200);
	v_count NUMBER;
	V_PATNO_R_NO NUMBER;
	V_PATNO_T_NO NUMBER;
	v_PATNO PATIENT.PATNO%TYPE;
	DEFAULT_PATNO_R_NO NUMBER := 20;
	DEFAULT_PATNO_T_NO NUMBER := 9;
BEGIN
	SELECT COUNT(1) INTO v_count FROM SYSPARAM WHERE PARCDE = 'PATNO_R_NO';
	IF v_count > 0 THEN
		SELECT TO_NUMBER(PARAM1) INTO V_PATNO_R_NO FROM SYSPARAM WHERE PARCDE = 'PATNO_R_NO';
	ELSE
		INSERT INTO SYSPARAM(PARCDE, PARAM1, PARDESC) VALUES('PATNO_R_NO', TO_CHAR(DEFAULT_PATNO_R_NO), 'No of reserve new patno');
		V_PATNO_R_NO := DEFAULT_PATNO_R_NO;
	END IF;
	
	SELECT COUNT(1) INTO v_count FROM SYSPARAM WHERE PARCDE = 'PATNO_T_NO';
	IF v_count > 0 THEN
		SELECT TO_NUMBER(PARAM1) INTO V_PATNO_T_NO FROM SYSPARAM WHERE PARCDE = 'PATNO_T_NO';
	ELSE
		INSERT INTO SYSPARAM(PARCDE, PARAM1, PARDESC) VALUES('PATNO_T_NO', TO_CHAR(DEFAULT_PATNO_T_NO), 'Threshold remain new patno');
		V_PATNO_T_NO := DEFAULT_PATNO_T_NO;
	END IF;
	
	SELECT COUNT(1) INTO v_count FROM PATNO_RESERVED WHERE USE_DATE IS NULL;
	IF v_count <= V_PATNO_T_NO THEN
		FOR Lcntr IN 1..V_PATNO_R_NO
		LOOP
			v_PATNO := TO_CHAR(HAT_GET_NEXT_PATNO@HKHAT);
			
			-- use auto gen Patient no
			SELECT COUNT(1) INTO v_count FROM Patient WHERE PatNo = v_PATNO;
	
			IF v_count > 0 THEN
				WHILE v_count > 0 LOOP
					v_PATNO := TO_CHAR(HAT_GET_NEXT_PATNO@HKHAT);
					
					SELECT COUNT(1) INTO v_count FROM Patient WHERE PatNo = v_PATNO;
				END LOOP;
			END IF;
			
			INSERT INTO PATNO_RESERVED(PATNO, RSV_DATE, USE_DATE) VALUES(v_PATNO, SYSDATE, NULL);
		END LOOP;

		insert into syslog(module, action,remark, userid, systime, pcname) values
			('Patient Master Index', 'NEW_PATNO', 'Get new patno reserve total: ' || TO_CHAR(V_PATNO_R_NO), 'SYSTEM', sysdate, null);
	END IF;
EXCEPTION
WHEN OTHERS THEN
    insert into syslog(module, action,remark, userid, systime, pcname) values
    	('Patient Master Index', 'NEW_PATNO', 'Fail(ERR) to get new patno reserve', 'SYSTEM', sysdate, null);
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RAISE; 
END NHS_UTL_RESERVE_NEW_PATNO;
/
