create or replace FUNCTION "NHS_ACT_ECGREPORTEDITOR" (
	v_action   IN VARCHAR2,
	v_RPTSTATUS IN VARCHAR2,
	v_XRGID  IN VARCHAR2,
	v_XRPID IN VARCHAR2,
    v_DOCCODE IN VARCHAR2,
    v_USRID_P IN VARCHAR2,
	v_XRPTITLE IN VARCHAR2,
	v_XRPDATE IN VARCHAR2,
	v_VERNO IN VARCHAR2,
    v_XRPCONTENT IN VARCHAR2,
	v_USRID IN VARCHAR2,
	o_errmsg   OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	
	SQLSTR VARCHAR2(32767);
    getTempRpt_sql VARCHAR2(32767);

    v_PERFORM XREPORTHIST.USRID_P%TYPE;
	v_XRPPRNCNT XREPORTHIST.XRPPRNCNT%TYPE;
	v_XRPCOMBINE XREPORTHIST.XRPCOMBINE%TYPE;
	v_APPROVEDATE XREPORTHIST.APPROVEDATE%TYPE;
	v_APPROVEBY XREPORTHIST.APPROVEBY%TYPE;
	v_XRPTSTS XREPORTHIST.XRPTSTS%TYPE;
    
    l_XRPID XREPORTHIST.XRPID%TYPE;
    old_DOCCODE XREPORTHIST.DOCCODE%TYPE;
    old_XRPCONTENT XREPORTHIST.XRPCONTENT%TYPE;
    

BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';
    
    getTempRpt_sql := 'SELECT TMPCONTENT
                        FROM XRPTTEMP
                        WHERE DOCCODE = ''' || v_DOCCODE || ''' ';
	
	IF v_action = 'ADD' THEN
		SELECT SEQ_XREPORT.NEXTVAL INTO l_XRPID FROM DUAL;
		v_XRPTSTS := 'P';
		v_XRPPRNCNT := '0';
		v_XRPCOMBINE := l_XRPID;
		
        BEGIN
		EXECUTE IMMEDIATE getTempRpt_sql INTO o_errmsg;
        EXCEPTION WHEN OTHERS THEN
                        o_errmsg := '';
        END;

        
		
		INSERT INTO XREPORT 
		(XRPID, XRGID, XRPTITLE, XRPDATE, DOCCODE,
		USRID_T, USRID_P, XRPPRNCNT, XRPCOMBINE, VERNO, 
        XRPIDHIST)
		VALUES
		(l_XRPID, v_XRGID, v_XRPTITLE, SYSDATE, v_DOCCODE, 
		v_USRID, v_USRID_P, v_XRPPRNCNT, v_XRPCOMBINE, v_VERNO,
        l_XRPID);

		INSERT INTO XREPORTHIST 
		(XRPID, XRGID, XRPTITLE, XRPDATE, DOCCODE, 
		USRID_T, USRID_P, XRPPRNCNT, XRPCOMBINE, VERNO,
		XRPTSTS, XRPCONTENT)
		VALUES 
		(l_XRPID, v_XRGID, v_XRPTITLE, SYSDATE, v_DOCCODE, 
		v_USRID, v_USRID_P, v_XRPPRNCNT, v_XRPCOMBINE, v_VERNO,
		v_XRPTSTS, o_errmsg);

        o_errcode := l_XRPID;
        
        
        
	ELSIF v_action = 'MOD' THEN

        SELECT DOCCODE INTO old_DOCCODE FROM XREPORT WHERE XRPIDHIST = v_XRPID;
        old_XRPCONTENT := v_XRPCONTENT;
        
        IF v_DOCCODE != old_DOCCODE THEN
            -- SET DR INCOME NEED TO RETURN IF ALREADY PAID
            UPDATE  DOCINCOME 
            SET 
            WOFFLG = '-1'
            WHERE DIXREF = 
            (	SELECT STNID 
                FROM XREG 
                WHERE XRGID = 
                (	SELECT XRGID 
                    FROM XREPORT 
                    WHERE XRPID = v_XRPID
                )
            );
            -- RESET THE RELATED SLIPTX
            UPDATE SLIPTX 
            SET 
            STNDIDOC = NULL 
            WHERE DIXREF = 
            (	SELECT STNID 
                FROM XREG 
                WHERE XRGID = 
                (	SELECT XRGID 
                    FROM XREPORT 
                    WHERE XRPID = v_XRPID
                )
            );
            -- UPDATE REPORT TO NEW DOCTOR
            UPDATE XREPORT 
            SET
            DOCCODE = v_DOCCODE,
            USRID_P = v_USRID_P,
            USRID_T = v_USRID
            WHERE XRPID = v_XRPID;
            
            BEGIN
            EXECUTE IMMEDIATE getTempRpt_sql INTO old_XRPCONTENT;
            EXCEPTION WHEN OTHERS THEN
				old_XRPCONTENT := '';
            END;
        
            
        END IF; 

		-- UPDATE REPORT CONTENT
        UPDATE XREPORTHIST 
		SET 
			DOCCODE = v_DOCCODE,
            XRPTITLE = v_XRPTITLE,
			USRID_P = v_USRID_P,
            XRPCONTENT = old_XRPCONTENT,
            USRID_T = v_USRID
		WHERE XRPID = v_XRPID;
        
        o_errmsg := old_XRPCONTENT;
	END IF;

	RETURN o_errcode;
END NHS_ACT_ECGREPORTEDITOR;