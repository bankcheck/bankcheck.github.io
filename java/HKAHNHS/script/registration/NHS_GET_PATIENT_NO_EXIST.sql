CREATE OR REPLACE FUNCTION "NHS_GET_PATIENT_NO_EXIST" (
	i_PatNo VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
	v_Count NUMBER;
	v_isExist VARCHAR2(1);
	v_mergedNo Patient.PatNo%TYPE;
	v_fromMergedNo Patient.PatNo%TYPE;
	
	SQLSTR varchar2(200);
	cursor1 types.cursor_type; 
	v_result varchar2(10);
	v_to_PatNo_str varchar2(500);
	v_Fm_PatNo_str varchar2(500);
BEGIN
	SELECT COUNT(1) INTO v_Count FROM Patient WHERE PatNo = i_PatNo;
	IF v_Count > 0 THEN
		v_isExist := 'Y';
	ELSE
		v_isExist := 'N';
	END IF;

	OPEN cursor1 for SELECT To_PatNo FROM PatMerCht WHERE Fm_PatNo = i_PatNo;
	LOOP
		FETCH cursor1 INTO v_result;
		EXIT WHEN cursor1%NOTFOUND;
		
    	IF v_to_PatNo_str is null or INSTR(v_to_PatNo_str, v_result) = 0 THEN
			IF v_to_PatNo_str is not null THEN
				v_to_PatNo_str := v_to_PatNo_str || ', ';
			END IF;
			v_to_PatNo_str := v_to_PatNo_str || v_result;
    	END IF;
	END LOOP;
	CLOSE cursor1;

	OPEN cursor1 for SELECT Fm_PatNo FROM PatMerCht WHERE TO_PATNO = i_PatNo;
	LOOP
		FETCH cursor1 INTO v_result;
		EXIT WHEN cursor1%NOTFOUND;
		
		IF v_Fm_PatNo_str is null or INSTR(v_Fm_PatNo_str, v_result) = 0 THEN
			IF v_Fm_PatNo_str is not null THEN
				v_Fm_PatNo_str := v_Fm_PatNo_str || ', ';
			END IF;
			v_Fm_PatNo_str := v_Fm_PatNo_str || v_result;
		END IF;      
	END LOOP;
	CLOSE cursor1;

	OPEN outcur FOR
		SELECT v_isExist, v_to_PatNo_str, v_Fm_PatNo_str FROM DUAL;
	RETURN outcur;
END NHS_GET_PATIENT_NO_EXIST;
/
