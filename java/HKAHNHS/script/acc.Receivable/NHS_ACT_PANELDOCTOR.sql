create or replace FUNCTION NHS_ACT_PANELDOCTOR 
(   v_ACTION    IN VARCHAR2,
    v_BY        IN VARCHAR2,
    v_ARCCODE   IN VARCHAR2,
    v_ARCLIST   IN VARCHAR2,
    v_DOCCODE   IN VARCHAR2,
    v_DOCLIST   IN VARCHAR2,
    v_ARDOCCODE IN VARCHAR2
)
  RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	o_ERROR NUMBER;
        
    CURSOR v_RECORD IS 
        SELECT REGEXP_SUBSTR(v_ARCLIST,'[^,]+', 1, LEVEL) AS TEMP FROM DUAL 
        CONNECT BY REGEXP_SUBSTR(v_ARCLIST,'[^,]+', 1, LEVEL) IS NOT NULL;      
    
    CURSOR v_RECORD2 IS 
        SELECT REGEXP_SUBSTR(v_DOCLIST,'[^,]+', 1, LEVEL) AS TEMP2 FROM DUAL 
        CONNECT BY REGEXP_SUBSTR(v_DOCLIST,'[^,]+', 1, LEVEL) IS NOT NULL; 
        
BEGIN
	o_ERROR := '0';
    IF v_ACTION = 'ADD' THEN
        
        IF v_BY = 'AR' THEN
--            DELETE FROM PANDOCTOR 
--            WHERE ARCCODE = v_ARCCODE;
            
            /*ADD DOCCODE TO THE ARCCODE*/
            FOR VAL2 IN v_RECORD2 LOOP
                INSERT INTO PANDOCTOR 
                (ARCCODE, DOCCODE) 
                VALUES 
                (v_ARCCODE, VAL2.TEMP2);
            END LOOP;
            o_ERROR:= 0;
        ELSIF v_BY = 'DR' THEN
--            DELETE FROM PANDOCTOR 
--            WHERE DOCCODE = v_DOCCODE;
            
            /*ADD DOCCODE TO THE ARCCODE*/
            FOR VAL IN v_RECORD LOOP
                INSERT INTO PANDOCTOR 
                (ARCCODE, DOCCODE) 
                VALUES 
                (VAL.TEMP, v_DOCCODE);
            END LOOP;
            o_ERROR:= 0;
        ELSE 
            o_ERROR:= -1;
        END IF;
    ELSIF v_ACTION = 'MOD' THEN
          UPDATE PANDOCTOR
          SET ARDOCCODE = v_ARDOCCODE
          WHERE ARCCODE = v_ARCCODE
          AND DOCCODE = v_DOCCODE;
           o_ERROR:= 0;
    
    ELSIF v_ACTION = 'DEL' THEN
        DELETE FROM PANDOCTOR 
        WHERE ARCCODE = v_ARCCODE
        AND DOCCODE = v_DOCCODE;
        o_ERROR:= 0;
    END IF;  
	
    OPEN OUTCUR FOR
        SELECT o_ERROR FROM DUAL;
    RETURN OUTCUR;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
    OPEN OUTCUR FOR
        SELECT '-1' FROM DUAL;
    RETURN OUTCUR;
END NHS_ACT_PANELDOCTOR;
/
