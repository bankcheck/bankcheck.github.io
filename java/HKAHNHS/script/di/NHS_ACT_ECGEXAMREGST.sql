create or replace FUNCTION NHS_ACT_ECGEXAMREGST(
    v_action           IN VARCHAR2,
    i_usrid            IN VARCHAR2,
    i_DINO             IN VARCHAR2,
    i_Patno            IN VARCHAR2,
    i_PatType          IN VARCHAR2,
    i_FilmTo           IN VARCHAR2,
    i_FilmToName       IN VARCHAR2,
	v_ADDENTRY		   IN TEMPLATE_OBJ_TAB,
    o_errmsg           OUT VARCHAR2
)
	RETURN NUMBER
AS
    o_errcode  	NUMBER;
	l_JOBNO 	VARCHAR2(15);
	l_STNID 	NUMBER(22,0);
	
BEGIN
	o_errmsg := 'OK';
	o_errcode := 0;

	l_JOBNO := CASE WHEN i_DINO IS NULL THEN NHS_GET_NEXT_XJOBNO ELSE i_DINO END; --> c_JOBNO

	IF v_action = 'ADD' OR v_action = 'MOD' THEN
		FOR I IN 1..v_ADDENTRY.COUNT LOOP
			--add to sliptx
            IF V_ADDENTRY(I).COLUMN26 IS NULL THEN
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
                    NULL,-- iREF = ""
                    NULL,
                    i_usrid
                );
    
                IF o_errcode < 0 THEN
                    ROLLBACK;
                    o_errmsg := 'SLIPTX: insert fail.';
                    RETURN o_errcode;
                ELSE
                    l_STNID := o_errcode;
                END IF;
            
            ELSE 
                l_STNID := V_ADDENTRY(I).COLUMN26;
                UPDATE SLIPTX SET 
                    STNDIFLAG = NULL 
                WHERE SLPNO = V_ADDENTRY(I).COLUMN01
                AND STNID = l_STNID;
            END IF;
			
			o_errcode := NHS_ACT_ECGEXAMREG(
				l_JOBNO,
				l_STNID,
				i_PatNo,
				i_PatType,
				i_FilmTo,
				i_FilmToName,
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
				o_errmsg := 'ECGREG: insert fail.' || l_JOBNO;
				RETURN o_errcode;
			END IF;
		END LOOP;
        
        BEGIN
            -- only insert one record 
            INSERT INTO XJOB
                (XJBNO,
                PATNO,
                DOCCODE,
                XJBDATE,
                XJBFLOC,
                XJBFLOCDESC,
                XJBTLOC,
                XJBTLOCDESC
                )
                VALUES
                (l_JOBNO,
                i_Patno,
                V_ADDENTRY(1).COLUMN07,
                TO_DATE(V_ADDENTRY(1).COLUMN13, 'DD/MM/YYYY HH24:MI:SS'),
                i_PatType,
                V_ADDENTRY(1).COLUMN19,
                i_FilmTo,
                i_FilmToName
                );
        EXCEPTION WHEN OTHERS THEN
            o_errmsg := l_JOBNO;
        END;
        
            

	ELSE
		o_errmsg := 'parameter error.';
		o_errcode := -1;
	END IF;
    
    o_ErrMsg := l_JOBNO;
	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ErrMsg := SQLERRM || o_ErrMsg;

	o_errcode := -999;
	return o_errcode;
END NHS_ACT_ECGEXAMREGST;