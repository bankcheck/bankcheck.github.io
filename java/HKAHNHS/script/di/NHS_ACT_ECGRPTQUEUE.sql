create or replace FUNCTION "NHS_ACT_ECGRPTQUEUE" (
	v_action   IN VARCHAR2,
	v_SELECTITEM  IN VARCHAR2,
	v_USRID IN VARCHAR2,
	o_errmsg   OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	
	v_XRPID XREPORT.XRPID%TYPE;
    v_OLDDOCCODE XREPORT.DOCCODE%TYPE;
	v_XRGID XREPORT.XRGID%TYPE;
	v_DOCCODE XREPORT.DOCCODE%TYPE;
    CURSOR v_EachRecord IS 
        SELECT REGEXP_SUBSTR(v_SELECTITEM,'[^;]+', 1, LEVEL) AS TEMP FROM DUAL 
        CONNECT BY REGEXP_SUBSTR(v_SELECTITEM,'[^;]+', 1, LEVEL) IS NOT NULL;      
        
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	IF v_action = 'ADD' THEN
        FOR VAL IN v_EachRecord LOOP
			BEGIN
                EXECUTE IMMEDIATE 
                'SELECT 
					REGEXP_SUBSTR('''||VAL.TEMP||''',''(^|,)([^,]*)'',1,1,null,2),
					REGEXP_SUBSTR('''||VAL.TEMP||''',''(^|,)([^,]*)'',1,2,null,2)
				FROM DUAL'
                INTO v_XRGID, v_DOCCODE;
            EXCEPTION WHEN OTHERS THEN
                ROLLBACK;
                o_errcode:='-1';
            END;
			
			SELECT SEQ_XREPORT.NEXTVAL INTO v_XRPID FROM DUAL;
			
			INSERT INTO XREPORT
			(XRPID, XRGID, XRPDATE, XRPPRNCNT, XRPCOMBINE, USRID_P, USRID_T, DOCCODE)
			VALUES
			(v_XRPID, v_XRGID, SYSDATE, 0, v_XRPID, v_USRID, v_USRID, v_DOCCODE);
			
			
		END LOOP;
	ELSIF v_action = 'MOD' THEN
        FOR VAL IN v_EachRecord LOOP
			BEGIN
                EXECUTE IMMEDIATE 
                'SELECT 
					REGEXP_SUBSTR('''||VAL.TEMP||''',''(^|,)([^,]*)'',1,1,null,2),
					REGEXP_SUBSTR('''||VAL.TEMP||''',''(^|,)([^,]*)'',1,2,null,2)
				FROM DUAL'
                INTO v_XRGID, v_DOCCODE;
            EXCEPTION WHEN OTHERS THEN
                ROLLBACK;
                o_errcode:='-1';
            END;
			
			SELECT DOCCODE INTO v_OLDDOCCODE FROM XREPORT WHERE XRGID = v_XRGID;
			
			IF v_DOCCODE != v_OLDDOCCODE THEN
				UPDATE DOCINCOME 
				SET 
					WOFFLG = '-1'
				WHERE DIXREF = (SELECT STNID FROM XREG WHERE XRGID = v_XRGID);
				
				UPDATE SLIPTX 
				SET STNDIDOC = NULL 
				WHERE DIXREF = (SELECT STNID FROM XREG WHERE XRGID = v_XRGID);
			END IF;
			
            UPDATE XREPORT 
            SET 
                DOCCODE = v_DOCCODE,
                USRID_P = v_USRID,
                USRID_T = v_USRID
            WHERE XRGID = v_XRGID;
          
		END LOOP;
	END IF;

	RETURN o_errcode;
END NHS_ACT_ECGRPTQUEUE;