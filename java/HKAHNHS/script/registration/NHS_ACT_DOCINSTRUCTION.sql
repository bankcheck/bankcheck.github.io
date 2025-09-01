create or replace
FUNCTION "NHS_ACT_DOCINSTRUCTION"(V_ACTION         IN VARCHAR2,
                                                    V_DOCCODE        IN VARCHAR2,
                                                    V_DAYINSTRUCTION IN VARCHAR2,
                                                    V_INPINSTRUCTION IN VARCHAR2,
                                                    V_OUPINSTRUCTION IN VARCHAR2,
                                                    V_PAYINSTRUCTION IN VARCHAR2,
                                                    V_SMDINSTRUCTION IN VARCHAR2,
                                                    O_ERRMSG         OUT VARCHAR2)

 RETURN NUMBER AS
  O_ERRCODE NUMBER;
  v_noOfRec NUMBER;
BEGIN
  O_ERRCODE := 0;
  O_ERRMSG  := 'OK';
  SELECT count(1) into v_noOfRec from doctor_extra where doccode= v_doccode;
  IF V_ACTION = 'MOD' THEN
    UPDATE DOCTOR
       SET DAYINSTRUCTION = V_DAYINSTRUCTION,
           INPINSTRUCTION = V_INPINSTRUCTION,
           OUPINSTRUCTION = V_OUPINSTRUCTION,
           PAYINSTRUCTION = V_PAYINSTRUCTION
     WHERE DOCCODE = V_DOCCODE;
    
    IF v_noOfRec = 0 THEN
          INSERT INTO DOCTOR_EXTRA
          (DOCCODE,SMDINSTRUCTION)
          VALUES
          (V_DOCCODE,V_SMDINSTRUCTION);
    ELSE
        UPDATE DOCTOR_EXTRA set
					SMDINSTRUCTION = V_SMDINSTRUCTION
				WHERE DOCCODE = V_DOCCODE;
    END IF;
  END IF;
  RETURN O_ERRCODE;
END NHS_ACT_DOCINSTRUCTION;
/
