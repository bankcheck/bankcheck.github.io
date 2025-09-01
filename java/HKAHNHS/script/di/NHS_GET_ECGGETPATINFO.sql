create or replace FUNCTION NHS_GET_ECGGETPATINFO(
	v_patNo IN VARCHAR2,
	v_diNo IN VARCHAR2
)
	RETURN TYPES.cursor_type
AS
	OUTCUR TYPES.cursor_type;
	b_isRefPat VARCHAR2(1); 
    b_hvDiNo VARCHAR2(1); 
    
	patinfo_sql VARCHAR2(5000);
	slpinfo_sql VARCHAR2(5000);
	lastFile_sql VARCHAR2(5000);
	filmInfo_sql VARCHAR2(5000);
	jobInfo_sql VARCHAR2(5000);
    
    tmpPatno XJOB.PATNO%TYPE;
	l_patFName PATIENT.PATFNAME%TYPE;
	l_patGName PATIENT.PATGNAME%TYPE;
	l_IDNo PATIENT.PATIDNO%TYPE;
	l_DOB VARCHAR2(10);
	l_sex Patient.PATSEX%type;
	l_patCName PATIENT.PATCNAME%TYPE;
	
	l_slipNo SLIP.SLPNO%TYPE;
	l_regDate REG.REGDATE%TYPE;
	l_docCode REG.DOCCODE%TYPE;
	l_patType REG.REGTYPE%TYPE;
	l_curLocation VARCHAR2(1); -- l_curLocation = l_patType
	l_bedCode INPAT.BEDCODE%TYPE;
	l_acmCode INPAT.ACMCODE%TYPE;
	
	l_diNo XREG.XJBNO%TYPE;
	l_jbDate VARCHAR2(20);
	l_expiryDate VARCHAR2(10);
	l_disposed XEXPIRE.XEXXRDIS%TYPE;
    l_filmInDI VARCHAR2(20);
    l_filmNum INTEGER;
		
	tmpLendDate VARCHAR(20);
	tmpReturnDate VARCHAR(20);
	tmpLocCode VARCHAR2(2); 
	tmpXrlDel VARCHAR2(22);
	tmpLocDesc VARCHAR2(25);
	tmpDisDate VARCHAR2(20);
	
	l_refDocCde VARCHAR2(10);
	b_isReferral VARCHAR2(1);

    j_xjbno XJOB.XJBNO%TYPE;
    j_patno XJOB.PATNO%TYPE;
    j_docCode XJOB.DOCCODE%TYPE;
    j_loc VARCHAR2(50);
    j_clinicNo XJOB.CLINICNO%TYPE;
    j_xjbdate XJOB.XJBDATE%TYPE;
    
    
BEGIN
	b_isReferral := 'F';
    tmpPatno := v_patNo;
	
	--Check patno start with "R"?
	IF v_patNo LIKE 'R%' THEN
		b_isRefPat := 'Y';
	ELSE 
        b_isRefPat := 'N';
    END IF;
    --Check diNo is null?
    IF v_diNo IS NOT NULL THEN 
        b_hvDiNo := 'Y';
        
        SELECT PATNO INTO tmpPatno FROM XJOB WHERE XJBNO = v_diNo;
        
        jobInfo_sql := 'SELECT XJBNO, PATNO, DOCCODE, 
                        DECODE(XJBFLOCDESC, NULL, STSDESC, STSDESC || '' - '' || XJBFLOCDESC) AS LOCATION, J.CLINICNO, XJBDATE
                        FROM XJOB J , STATUS S WHERE J.XJBFLOC = S.STSKEY AND S.STSCAT = ''DILOC''
                        AND J.XJBNO = ''' || v_diNo || ''' ' ;
                        
    ELSE 
        tmpPatno := v_patNo;
        b_hvDiNo := 'N';
    END IF;
	
	IF b_isRefPat = 'Y' THEN
		patinfo_sql := 'SELECT ORPFNAME AS PATFNAME, ORPGNAME AS PATGNAME, ORPIDNO AS PATIDNO, TO_CHAR(ORPDOB, ''DD/MM/YYYY'') AS PATBDATE, ORPSEX AS PATSEX, ORPCNAME AS PATCNAME '; --ERDCODE
		patinfo_sql := patinfo_sql || 'FROM OUTREFPAT ';
		patinfo_sql := patinfo_sql || 'WHERE ORPNO = ''' || tmpPatno || ''' ';

		slpinfo_sql:= 'SELECT '''' AS SLPNO, '''' AS REGDATE, '''' AS DOCCODE, ''R'' AS REGTYPE, '''' AS BEDCODE, '''' AS ACMCODE FROM DUAL';
        
		lastFile_sql:= 'SELECT '''' AS XJBNO, '''' AS XJBDATE, '''' AS XEXXRDATE, '''' AS XEXXRDIS FROM DUAL';
	ELSE
		/*
		SELECT PATNO, PATFNAME, PATGNAME, PATIDNO, TO_CHAR(PATBDATE, ''DD/MM/YYYY'') AS PATBDATE, PATSEX, PATCNAME 
		FROM PATIENT 
		WHERE PATNO = '333333'
		*/
		patinfo_sql := 'SELECT PATFNAME, PATGNAME, PATIDNO, TO_CHAR(PATBDATE, ''DD/MM/YYYY'') AS PATBDATE, PATSEX, PATCNAME ';
		patinfo_sql := patinfo_sql || 'FROM PATIENT ';
		patinfo_sql := patinfo_sql || 'WHERE PATNO = ''' || tmpPatno || ''' ';
		
		lastFile_sql := 'SELECT J.XJBNO, TO_CHAR(J.XJBDATE, ''dd/mm/yyyy HH:MM:SS'') XJBDATE, TO_CHAR(E.XEXXRDATE, ''dd/mm/yyyy'') XEXXRDATE, E.XEXXRDIS ';
		lastFile_sql := lastFile_sql || 'FROM XREG R, XJOB J, XEXPIRE E ';
		lastFile_sql := lastFile_sql || 'WHERE R.XJBNO = J.XJBNO ';
		lastFile_sql := lastFile_sql || 'AND J.XJBNO = E.XJBNO ';
		lastFile_sql := lastFile_sql || 'AND XRGID = (SELECT MAX(XRGID) ';
		lastFile_sql := lastFile_sql || '				FROM XREG R, XJOB J ';
		lastFile_sql := lastFile_sql || '				WHERE J.PATNO = ''' || tmpPatno || ''' ';
		lastFile_sql := lastFile_sql || '				AND J.XJBNO = R.XJBNO';
		lastFile_sql := lastFile_sql || '				AND R.XRGFILM = -1 ';
		lastFile_sql := lastFile_sql || '				AND R.XRGRPTFLAG <> 1 ';
	
		--IF b_hvDiNo = 'Y' THEN
			/*
			SELECT SLPNO, REGDATE, DOCCODE, REGTYPE, BEDCODE, ACMCODE, PATNO
			FROM (
				SELECT R.SLPNO, R.REGDATE, R.DOCCODE, R.REGTYPE, I.BEDCODE, I.ACMCODE, R.PATNO
				FROM REG R, INPAT I, SLIP S
				WHERE R.SLPNO = S.SLPNO 
				AND R.INPID = I.INPID 
				AND I.INPDDATE IS NULL 
				AND R.REGSTS = 'N'  --REG_STS_NORMAL
				AND S.SLPSTS = 'A' --SLIP_STATUS_OPEN
				AND R.REGTYPE <> 'O' --SLIP_TYPE_OUTPATIENT
				AND R.PATNO = '333333'
				ORDER BY R.REGDATE DESC
			) WHERE ROWNUM = 1
			*/
			slpinfo_sql := 					'SELECT SLPNO, REGDATE, DOCCODE, REGTYPE, BEDCODE, ACMCODE ';
			slpinfo_sql := slpinfo_sql || 	'FROM ( ';
			slpinfo_sql := slpinfo_sql || 	'	SELECT R.SLPNO, R.REGDATE, R.DOCCODE, R.REGTYPE, I.BEDCODE, I.ACMCODE ';
			slpinfo_sql := slpinfo_sql || 	'	FROM REG R, INPAT I, SLIP S ';
			slpinfo_sql := slpinfo_sql || 	'	WHERE R.SLPNO = S.SLPNO ';
			slpinfo_sql := slpinfo_sql || 	'	AND R.INPID = I.INPID ';
			slpinfo_sql := slpinfo_sql || 	'	AND I.INPDDATE IS NULL ';
			slpinfo_sql := slpinfo_sql || 	'	AND R.REGSTS = ''N'' ';
			slpinfo_sql := slpinfo_sql || 	'	AND S.SLPSTS = ''A'' ';
			slpinfo_sql := slpinfo_sql || 	'	AND R.REGTYPE <> ''O'' ';
			slpinfo_sql := slpinfo_sql || 	'	AND R.PATNO = ''' || tmpPatno || ''' ';
			slpinfo_sql := slpinfo_sql || 	'	ORDER BY R.REGDATE DESC ';
			slpinfo_sql := slpinfo_sql || 	') WHERE ROWNUM = 1 ';
		IF b_hvDiNo = 'Y' THEN	
			lastFile_sql := lastFile_sql || 	'				AND J.XJBDATE <= (SELECT XJBDATE FROM XJOB WHERE XJBNO = ''' || v_diNo || ''') ';
			lastFile_sql := lastFile_sql || 	'			)';	
       -- ELSE
			/*
			SELECT SLPNO, REGDATE, DOCCODE, REGTYPE, BEDCODE, ACMCODE, PATNO
			FROM (
				SELECT R.SLPNO, R.REGDATE, R.DOCCODE, R.REGTYPE, I.BEDCODE, I.ACMCODE, R.PATNO
				FROM REG R, INPAT I
				WHERE R.INPID = I.INPID
				AND I.INPDDATE IS NULL
				AND R.REGSTS = 'N' --REG_STS_NORMAL
				AND R.PATNO = v_patNo
                ORDER BY R.REGDATE DESC
			) WHERE ROWNUM = 1
			*/
		/*	slpinfo_sql := 					'SELECT SLPNO, REGDATE, DOCCODE, REGTYPE, BEDCODE, ACMCODE ';
			slpinfo_sql := slpinfo_sql || 	'FROM ( ';
			slpinfo_sql := slpinfo_sql || 	'	SELECT R.SLPNO, R.REGDATE, R.DOCCODE, R.REGTYPE, I.BEDCODE, I.ACMCODE ';
			slpinfo_sql := slpinfo_sql || 	'	FROM REG R, INPAT I';
			slpinfo_sql := slpinfo_sql || 	'	WHERE R.INPID = I.INPID ';
			slpinfo_sql := slpinfo_sql || 	'	AND I.INPDDATE IS NULL ';			
			slpinfo_sql := slpinfo_sql || 	'	AND R.REGSTS = ''N'' ';
			slpinfo_sql := slpinfo_sql || 	'	AND R.PATNO = ''' || v_patNo || ''' ';
			slpinfo_sql := slpinfo_sql || 	'	ORDER BY R.REGDATE DESC ';
			slpinfo_sql := slpinfo_sql || 	') WHERE ROWNUM = 1 ';

			lastFile_sql := lastFile_sql || 	'			)';*/
        END IF;
	END IF;
	
	BEGIN
		EXECUTE IMMEDIATE patinfo_sql INTO l_patFName, l_patGName, l_IDNo, l_DOB, l_sex, l_patCName;
	EXCEPTION WHEN OTHERS THEN
					l_patFName := '';
					l_patGName := '';
					l_IDNo := '';
					l_DOB := '';
					l_sex := '';
					l_patCName := '';
	END;
	
	BEGIN
		EXECUTE IMMEDIATE slpinfo_sql INTO l_slipNo, l_regDate, l_docCode, l_patType, l_bedCode, l_acmCode;
	EXCEPTION WHEN OTHERS THEN
					l_slipNo := '';
					l_regDate := '';
					l_docCode := '';
					l_patType := '';
					l_bedCode := '';
					l_acmCode := '';
	END;

	BEGIN
		EXECUTE IMMEDIATE lastFile_sql INTO l_diNo, l_jbDate, l_expiryDate, l_disposed;
	EXCEPTION WHEN OTHERS THEN
					l_diNo := '';
					l_jbDate := '';
					l_expiryDate := '';
					l_disposed := '';					
	END;
    
    BEGIN
		EXECUTE IMMEDIATE jobInfo_sql INTO j_xjbno, j_patno, j_doccode, j_loc, j_clinicno, j_xjbdate;
	EXCEPTION WHEN OTHERS THEN
					j_xjbno := '';
					j_patno := '';
					j_doccode := '';
					j_loc := '';
                    j_clinicno := '';
                    j_xjbdate:= '';
	END;
    
	IF l_diNo IS NULL THEN
        l_filmInDI := 'DISPOSED';
    ELSE 
        IF l_disposed IS NULL THEN
            l_filmInDI := 'DISPOSED';
        ELSIF l_expiryDate IS NULL THEN
            BEGIN 
                SELECT COUNT(*) INTO l_filmNum
                FROM xreg
                WHERE xrgRptFlag = -1 
				AND xjbNo = l_diNo;
            EXCEPTION WHEN OTHERS THEN
                l_filmNum := 0;
            END;
			
			IF l_filmNum = 0 THEN
				BEGIN
					filmInfo_sql := 'select l.xlrLndDate, l.xlrRetDate, l.xjbtloc, l.xlrDel, s.stsDesc || '' '' || l.xjbTLocDesc, r.xrgdisdate ';
					filmInfo_sql := filmInfo_sql || 'from xreg r, xlendret l, status s ';
					filmInfo_sql := filmInfo_sql || 'where r.xjbno = ''' || l_diNo || ''' ';
					filmInfo_sql := filmInfo_sql || 'and r.xrgSts = ''N'' ';
					filmInfo_sql := filmInfo_sql || 'and r.xrgid = l.xrgid ';
					filmInfo_sql := filmInfo_sql || 'and l.xlrHist is null ';
					filmInfo_sql := filmInfo_sql || 'and l.xjbtloc = s.stskey '; 
					filmInfo_sql := filmInfo_sql || 'and s.stscat = ''DILOC'' ';
					filmInfo_sql := filmInfo_sql || 'order by l.xlrid desc ';
				
					EXECUTE IMMEDIATE filmInfo_sql INTO tmpLendDate, tmpReturnDate, tmpLocCode, tmpXrlDel, tmpLocDesc, tmpDisDate;
				
				EXCEPTION WHEN OTHERS THEN
					tmpLendDate := '';
					tmpReturnDate := '';
					tmpLocCode := '';
					tmpXrlDel := '';
					tmpLocDesc := '';
					tmpDisDate := '';
				END;
				IF tmpDisDate IS NOT NULL THEN
					l_filmInDI := 'DISPOSED';
				ELSIF tmpXrlDel = '0' AND tmpLocCode != 'I' THEN
					l_filmInDI := 'YES';
				ELSIF tmpXrlDel = '0' OR tmpLendDate IS NULL THEN
					l_filmInDI := 'DI';
				ELSIF tmpReturnDate IS NULL THEN 
					l_filmInDI := tmpLocDesc;
				ELSE
					l_filmInDI := 'YES';
				END IF;
			ELSE
				l_filmInDI := 'DI';
			END IF;
		ELSE
			l_filmInDI := 'EXPIRED';
        END IF;
    END IF;
/*		
	IF l_refDocCde IS NOT NULL OR b_isReferral = 'T' THEN --"	If CStr(varRefDoctCde) <> "" Or vIsReferral = True Then "
		l_patType := "R";
		BEGIN
			SELECT PARAM1 INTO l_docCode
			FROM SYSPARAM 
			WHERE PARCDE = 'DEFAULTDOC';
		EXCEPTION WHEN OTHERS THEN
			l_docCode := '';
		END;
	END IF;
*/
	OPEN OUTCUR FOR
        SELECT 	tmpPatno, 
				l_patFName, l_patGName, l_IDNo, l_DOB, l_sex, l_patCName, 
				l_slipNo, l_regDate, l_docCode AS getPatAttDoctor, l_patType, l_bedCode, l_acmCode,
				l_diNo, l_jbDate, l_expiryDate, l_disposed, l_filmInDI,
                j_doccode, j_loc, to_char(j_xjbdate, 'dd/mm/yyyy HH:MM:SS') as xjbdate
        FROM DUAL;

	RETURN OUTCUR;
END NHS_GET_ECGGETPATINFO;