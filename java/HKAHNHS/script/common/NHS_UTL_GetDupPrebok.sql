-- SearchFunc.bas / GetDupPrebok
CREATE OR REPLACE FUNCTION "NHS_UTL_GETDUPPREBOK" (
	i_Type     IN VARCHAR2,
	i_Sql      OUT VARCHAR2,
	i_AdmDate  IN VARCHAR2,
	i_PatNo    IN VARCHAR2,
	i_DocNo    IN VARCHAR2,
	i_PatFName IN VARCHAR2,
	i_PatGName IN VARCHAR2
)
	RETURN BOOLEAN
AS
	v_GetDupPrebok BOOLEAN;
	v_Count NUMBER;
	v_l NUMBER;
	v_n NUMBER;
	v_DupBpbDay NUMBER;
	v_DupBpbDoc NUMBER;
	v_DupBpbGN NUMBER;
	v_Param1 VARCHAR2(50);
	v_AdmDate VARCHAR2(10);
	v_DocNo VARCHAR2(10);
	v_PatGName  VARCHAR2(100);
	v_Where_Clause_SchdAdmDate VARCHAR2(1000);
	v_Sql1 VARCHAR2(2000);
	v_Sql2 VARCHAR2(2000);
	v_Sql2_PatNo VARCHAR2(1000);
	v_Sql2_docno VARCHAR2(1000);
	v_Sql2_patname VARCHAR2(1000);
	v_Lvl1 VARCHAR2(1000);
	v_Lvl2 VARCHAR2(1000);
	PB_NORMAL_STS VARCHAR2(1) := 'N';
BEGIN
	v_GetDupPrebok := FALSE;

	SELECT Param1 INTO v_Param1 FROM SysParam WHERE PARCDE = 'DUPBPCHKF';
	IF i_Type = 'Enable' THEN
		IF v_Param1 != 'Y' THEN
			v_GetDupPrebok := FALSE;
		ELSE
			v_GetDupPrebok := TRUE;
		END IF;
		RETURN v_GetDupPrebok;
	ELSE
		SELECT Param1 INTO v_Param1 FROM SysParam WHERE PARCDE = 'DUPBPCHKF';
		IF v_Param1 != 'Y' THEN
			RETURN v_GetDupPrebok;
		END IF;
	END IF;

	BEGIN
		SELECT Param1 INTO v_Param1 FROM SysParam WHERE PARCDE = 'DUPBPDAY';
		v_DupBpbDay := TO_NUMBER(v_Param1);
		IF v_DupBpbDay IS NULL OR v_DupBpbDay = 0 THEN
			v_DupBpbDay := 1;
		END IF;
	EXCEPTION WHEN OTHERS THEN
		v_DupBpbDay := 1;
	END;

	BEGIN
		SELECT Param1 INTO v_Param1 FROM SysParam WHERE PARCDE = 'DUPBPDOC';
		v_DupBpbDoc := TO_NUMBER(v_Param1);
		IF v_DupBpbDoc IS NULL OR v_DupBpbDoc = 0 THEN
			v_DupBpbDoc := 1;
		END IF;
	EXCEPTION WHEN OTHERS THEN
		v_DupBpbDoc := 1;
	END;

	BEGIN
		SELECT Param1 INTO v_Param1 FROM SysParam WHERE PARCDE = 'DUPBPGN';
		v_DupBpbGN := TO_NUMBER(v_Param1);
		IF v_DupBpbGN IS NULL OR v_DupBpbGN = 0 THEN
			v_DupBpbGN := 1;
		END IF;
	EXCEPTION WHEN OTHERS THEN
		v_DupBpbGN := 1;
	END;

	IF i_AdmDate IS NOT NULL AND LENGTH(i_AdmDate) = 10 THEN
		v_AdmDate := i_AdmDate;
	ELSE
		SELECT TO_CHAR(SYSDATE, 'DD/MM/YYYY') INTO v_AdmDate FROM DUAL;
	END IF;

	v_Where_Clause_SchdAdmDate := '
		WHERE BpbSts = ''' || PB_NORMAL_STS || '''
		AND TRUNC(BpbHDate) BETWEEN TRUNC(TO_DATE(''' || v_AdmDate || ''', ''DD/MM/YYYY''))
		AND TRUNC(TO_DATE(''' || v_AdmDate || ''', ''DD/MM/YYYY'')) + ' || v_DupBpbDay;

	v_Sql1 := 'SELECT PbpID FROM BedPreBok ' || v_Where_Clause_SchdAdmDate;

	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM BedPreBok ' || v_Where_Clause_SchdAdmDate INTO v_Count;

	IF v_Count = 0 THEN
		RETURN v_GetDupPrebok;
	END IF;

	IF i_Type = 'AllDup' THEN
		v_Lvl1 := '  /* Level1, PatNo */ ' ||
			v_Sql1 ||
			'   AND PatNo IN (SELECT PatNo FROM BedPreBok ' ||
			v_Where_Clause_SchdAdmDate ||
			'   AND PatNo IS NOT NULL ' ||
			'   GROUP BY PatNo HAVING COUNT(1) > 1) ';

		v_Lvl2 := '  /* Level2, PatIDNo */ ' ||
			v_Sql1 ||
			'    AND SUBSTR(REPLACE(UPPER(PatIDNo),'' '',''''),1,' || v_DupBpbDoc || ') IN (SELECT SUBSTR(REPLACE(UPPER(PatIDNo),'' '',''''),1,' || v_DupBpbDoc || ') FROM BedPreBok ' ||
			v_Where_Clause_SchdAdmDate ||
			'    AND PatIDNo IS NOT NULL ' ||
			'    GROUP BY SUBSTR(REPLACE(UPPER(PatIDNo),'' '',''''),1,' || v_DupBpbDoc || ') HAVING COUNT(1) > 1) ';

		v_Sql2 := v_Lvl1 || ' UNION ' || v_Lvl2;
	ELSE
		IF i_PatNo IS NOT NULL THEN
			v_Sql2_PatNo := v_Sql1 || ' AND PatNo = ''' || i_PatNo || '''';
		END IF;

		IF i_DocNo IS NOT NULL THEN
			SELECT SUBSTR(REPLACE(UPPER(i_DocNo),' ',''),1, v_DupBpbDoc) INTO v_DocNo FROM DUAL;

			IF i_PatNo IS NOT NULL THEN
				v_Sql2_docno := v_Sql1 ||
					' AND PatNo IS NULL ' ||
					' AND SUBSTR(REPLACE(UPPER(PatIDNo),'' '',''''),1,' || v_DupBpbDoc || ')= ''' || v_DocNo || '''';
			ELSE
				v_Sql2_docno := v_Sql1 ||
					' AND SUBSTR(REPLACE(UPPER(PatIDNo),'' '',''''),1,' || v_DupBpbDoc || ')= ''' || v_DocNo || '''';
			END IF;
		END IF;

		IF i_PatFName IS NOT NULL THEN
			SELECT LENGTH(I_PATGNAME) INTO V_L FROM DUAL;
			SELECT DECODE(ROUND(v_l * v_DupBpbGN / 100, 0), 0, 1, ROUND(v_l * v_DupBpbGN / 100, 0)) INTO v_n FROM DUAL;
			SELECT SUBSTR(i_PatGName, 1, v_n) INTO v_PatGName FROM DUAL;

			IF i_PatNo IS NOT NULL AND v_DocNo IS NOT NULL THEN
				v_Sql2_patname := v_Sql1 ||
					' AND PatNo IS NULL AND PatIDNo IS NULL ' ||
					' AND UPPER(patfname) = UPPER(''' || i_PatFName || ''')' ||
					' AND SUBSTR(UPPER(patgname),1,' || v_n || ') = UPPER(''' || v_PatGName || ''')';
			ELSIF i_PatNo IS NULL AND v_DocNo IS NOT NULL THEN
				v_Sql2_patname := v_Sql1 ||
					' AND PatIDNo IS NULL ' ||
					' AND UPPER(patfname) = UPPER(''' || i_PatFName || ''')' ||
					' AND SUBSTR(UPPER(patgname),1,' || v_n || ') = UPPER(''' || v_PatGName || ''')';
			ELSIF i_PatNo IS NOT NULL AND v_DocNo IS NULL THEN
				v_Sql2_patname := v_Sql1 ||
					' AND PatNo IS NULL ' ||
					' AND UPPER(patfname) = UPPER(''' || i_PatFName || ''')' ||
					' AND SUBSTR(UPPER(patgname),1,' || v_n || ') = UPPER(''' || v_PatGName || ''')';
			ELSE
				v_Sql2_patname := v_Sql1 ||
					' AND UPPER(patfname) = UPPER(''' || i_PatFName || ''')' ||
					' AND SUBSTR(UPPER(patgname),1,' || v_n || ') = UPPER(''' || v_PatGName || ''')';
			END IF;
		END IF;

		IF v_Sql2_PatNo IS NOT NULL THEN
			IF v_Sql2 IS NULL THEN
				v_Sql2 := v_Sql2_PatNo;
			ELSE
				v_Sql2 := v_Sql2 || ' UNION ' || v_Sql2_PatNo;
			END IF;
		END IF;

		IF v_Sql2_docno IS NOT NULL THEN
			IF v_Sql2 IS NULL THEN
				v_Sql2 := v_Sql2_docno;
			ELSE
				v_Sql2 := v_Sql2 || ' UNION ' || v_Sql2_docno;
			END IF;
		END IF;

		IF v_Sql2_patname IS NOT NULL THEN
			IF v_Sql2 IS NULL THEN
				v_Sql2 := v_Sql2_patname;
			ELSE
				v_Sql2 := v_Sql2 || ' UNION ' || v_Sql2_patname;
			END IF;
		END IF;
	END IF;

	i_Sql := 'SELECT DISTINCT PbpID FROM (' || v_Sql2 || ')';

	IF i_Type = 'AllDup' THEN
		v_GetDupPrebok := TRUE;
		RETURN v_GetDupPrebok;
	END IF;

	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM (' || i_Sql || ')' INTO v_Count;

	IF v_Count > 0 THEN
		IF i_Type = 'EditPB' OR i_Type = 'PatStsView' THEN
			IF v_Count > 1 THEN
				v_GetDupPrebok := TRUE;
			END IF;
		ELSE
			v_GetDupPrebok := TRUE;
		END IF;
	END IF;

	RETURN v_GetDupPrebok;

EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN NULL;
END NHS_UTL_GETDUPPREBOK;
/
