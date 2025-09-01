create or replace FUNCTION "NHS_LIS_PATIENTSEARCH2" (
	i_PATNO       IN VARCHAR2,
	i_PATFNAME    IN VARCHAR2,
	i_PATGNAME    IN VARCHAR2,
	i_PATCNAME    IN VARCHAR2,
	i_DOCCODE     IN VARCHAR2,
	i_SLPNO       IN VARCHAR2,
	i_REGTYPE     IN VARCHAR2,
	i_RegDateFrom IN VARCHAR2,
	i_RegDateTo   IN VARCHAR2,
	i_DisDateFrom IN VARCHAR2,
	i_DisDateTo   IN VARCHAR2,
	i_REGSTS      IN VARCHAR2,
	i_CURINPAT    IN VARCHAR2,
	i_WRDCODE     IN VARCHAR2,
	i_BEDCODE     IN VARCHAR2,
	i_CreateBy    IN VARCHAR2,
	i_UsrID       IN VARCHAR2,
	i_SORT        IN VARCHAR2,
  	i_SPEC        IN VARCHAR2
)
	RETURN VARCHAR2
AS
	v_Count NUMBER;
	v_UsrInp NUMBER := 0;
	v_UsrOut NUMBER := 0;
	v_UsrDay NUMBER := 0;

	SQLSTR VARCHAR2(20000);
	INDEXSTR VARCHAR2(2000);
	wherestr VARCHAR2(2000);
	ordstr VARCHAR2(100);
	sqlbuff2 VARCHAR2(1000);

	REG_TYPE_INPATIENT VARCHAR(1) := 'I';
	REG_TYPE_DAYCASE VARCHAR(1) := 'D';
	REG_CAT_NORMAL VARCHAR(1) := 'N';
	REG_CAT_WALKIN VARCHAR(1) := 'W';
	REG_CAT_PRIORITY VARCHAR(1) := 'P';
	REG_CAT_URGENTCARE VARCHAR(1) := 'U';
	REG_TYPE_OUTPATIENT VARCHAR(1) := 'O';
BEGIN
	SELECT COUNT(1) INTO v_Count FROM Usr WHERE UsrID = i_UsrID;
	IF v_Count = 1 THEN
		SELECT UsrInp, UsrOut, UsrDay INTO v_UsrInp, v_UsrOut, v_UsrDay FROM Usr WHERE UsrID = i_UsrID;
	END IF;

--	IF i_CURINPAT = -1 THEN
--		INDEXSTR := '/*+ ORDERED USED_NL(reg,inp,pat,pck) INDEX(reg IDX_REG_05, inp IDX_INPAT_202, pat IDX_PATIENT_10) */ ';
--	ELSIF i_PATNO IS NULL AND i_SLPNO IS NULL AND (i_PATFNAME IS NOT NULL OR i_PATGNAME IS NOT NULL) THEN
--		INDEXSTR := '/*+ INDEX(pay IDX_PATIENT_102) */';
--	ELSE
		INDEXSTR := '';
--	END IF;

	Sqlstr := 'SELECT ' || Indexstr || '
			get_ALERT_CODE(reg.patno, ''' || i_UsrID || '''),
			reg.regid,
			reg.patno,
			pat.patfname,
			pat.patgname,
			pat.patcname,
			pat.stecode,
			pat.patsex,
			inp.bedcode,
			bed.extphone,
			decode(E.SPRQTID, ''0'', ''DND'', ''1'', ''INCOGNITO''),
			reg.slpno,
			reg.regtype,
			reg.regopcat,
			reg.doccode,
			inp.doccode_a,
			decode(reg.regsts, ''N'', ''Normal'', ''C'', ''Cancel'', reg.regsts),
			TO_CHAR(reg.regdate, ''DD/MM/YYYY hh24:mi:ss''),
			TO_CHAR(inp.inpddate, ''DD/MM/YYYY hh24:mi:ss''),
			pck.pkgname,
			NHS_UTL_TICKETFORMAT(reg.ticketno, reg.regopcat),
			reg.regsts,
			NVL((select usrname from usr where usrid = NVL(RE.CREATE_USER,S.USRID)), RE.CREATE_USER),
			reg.bkgid
		FROM  Reg reg, Inpat inp, Patient pat, Package pck, Bed bed, Room rom, Slip_Extra E,REG_EXTRA RE, Slip S, doctor d
		WHERE reg.patno = pat.patno
		AND   inp.bedcode = bed.bedcode(+)
		AND   reg.pkgcode = pck.pkgcode
		AND   bed.romcode = rom.romcode(+)
		AND   REG.SLPNO = E.SLPNO(+)
		AND   REG.REGID = RE.REGID(+)
		AND   REG.SLPNO = S.SLPNO(+)
    	AND   REG.DOCCODE = D.DOCCODE ';

	IF i_CURINPAT = -1 THEN
		SQLSTR := SQLSTR || ' AND reg.inpid = inp.inpid ';
	ELSE
		SQLSTR := SQLSTR || ' AND reg.inpid = inp.inpid (+) ';
	END IF;

	IF i_PATNO IS NOT NULL THEN
		SQLSTR := SQLSTR || ' AND reg.patno = ''' || i_PATNO || '''';
	END IF;

	IF i_PATFNAME IS NOT NULL THEN
		SQLSTR := SQLSTR || ' AND UPPER(pat.patfname) LIKE ''' || i_PATFNAME || '%''';
	END IF;

	IF i_PATGNAME IS NOT NULL THEN
		SQLSTR := SQLSTR || ' AND UPPER(pat.patgname) LIKE''' || i_PATGNAME || '%''';
	END IF;

	IF i_PATCNAME IS NOT NULL THEN
		SQLSTR := SQLSTR || ' AND UPPER(pat.patcname) LIKE''' || i_PATCNAME || '%''';
	END IF;

	IF i_DOCCODE IS NOT NULL THEN
		SQLSTR := SQLSTR || ' AND reg.doccode LIKE''' || i_DOCCODE || '''';
	END IF;
  
  	IF i_SPEC IS NOT NULL THEN
		SQLSTR := SQLSTR || ' AND D.SPCCODE = ''' || i_SPEC || '''';
	END IF;

	IF i_SLPNO IS NOT NULL THEN
		SQLSTR := SQLSTR || ' AND reg.slpno LIKE''' || i_SLPNO || '''';
	END IF;

	IF i_RegDateFrom IS NOT NULL THEN
		IF LENGTH(i_RegDateFrom) <= 10 THEN
			SQLSTR := SQLSTR || ' AND reg.regdate >= TO_DATE(''' || i_RegDateFrom  || ' 00:00:00'',''DD/MM/YYYY HH24:MI:SS'')';
		ELSE
			SQLSTR := SQLSTR || ' AND reg.regdate >= TO_DATE(''' || i_RegDateFrom  || ''',''DD/MM/YYYY HH24:MI:SS'')';
		END IF;
	END IF;

	IF i_RegDateTo IS NOT NULL THEN
		IF LENGTH(i_RegDateTo) <= 10 THEN
			SQLSTR := SQLSTR || ' AND reg.regdate <= TO_DATE(''' || i_RegDateTo  || ' 23:59:59'',''DD/MM/YYYY HH24:MI:SS'')';
		ELSE
			SQLSTR := SQLSTR || ' AND reg.regdate <= TO_DATE(''' || i_RegDateTo  || ''',''DD/MM/YYYY HH24:MI:SS'')';
		END IF;
	END IF;

	IF i_WRDCODE IS NOT NULL THEN
		SQLSTR := SQLSTR || ' AND rom.wrdcode = ''' || i_WRDCODE || '''';
	END IF;

	IF i_BEDCODE IS NOT NULL THEN
		SQLSTR := SQLSTR || ' AND bed.bedcode = ''' || i_BEDCODE || '''';
	END IF;

	IF i_CURINPAT = '-1' THEN
		SQLSTR := SQLSTR || ' AND reg.regsts = ''' || REG_CAT_NORMAL || '''';
		SQLSTR := SQLSTR || ' AND reg.regtype = ''' || REG_TYPE_INPATIENT || '''';
		SQLSTR := SQLSTR || ' AND inp.inpddate IS NULL ';
		IF i_CreateBy IS NOT NULL THEN
				SQLSTR := SQLSTR || ' AND RE.CREATE_USER LIKE ''' || i_CreateBy || ''' ';
		END IF;
		IF i_SORT IS NOT NULL AND i_SORT = 'U' THEN
			SQLSTR := SQLSTR || ' ORDER BY RE.CREATE_USER ASC, bed.bedcode';
		ELSE
			SQLSTR := SQLSTR || ' ORDER BY bed.bedcode';
		END IF;
	ELSE
		IF i_REGSTS IS NOT NULL THEN
			SQLSTR := SQLSTR || ' AND reg.regsts = ''' || i_REGSTS || '''';
		END IF;

		IF i_REGTYPE = REG_TYPE_INPATIENT OR i_REGTYPE = REG_TYPE_DAYCASE THEN
			SQLSTR := SQLSTR || ' AND reg.regtype = ''' || i_REGTYPE || '''';
		ELSIF i_REGTYPE = REG_CAT_NORMAL OR i_REGTYPE = REG_CAT_WALKIN OR i_REGTYPE = REG_CAT_PRIORITY OR i_REGTYPE = REG_CAT_URGENTCARE THEN
			SQLSTR := SQLSTR || ' AND reg.regtype = ''' || REG_TYPE_OUTPATIENT || '''';
			SQLSTR := SQLSTR || ' AND reg.RegOPCat = ''' ||i_REGTYPE || '''';
		ELSIF v_UsrInp = 0 OR v_UsrOut = 0 OR v_UsrDay = 0 THEN
			IF v_UsrInp = -1 THEN
				sqlbuff2 := sqlbuff2 || ' reg.regtype = ''' || REG_TYPE_INPATIENT || '''';
			END IF;
			IF v_UsrOut = -1 THEN
				IF sqlbuff2 IS NOT NULL AND LENGTH(sqlbuff2) > 0 THEN sqlbuff2 := sqlbuff2 || ' OR'; END IF;
				sqlbuff2 := sqlbuff2 || ' reg.regtype = ''' || REG_TYPE_OUTPATIENT || '''';
			END IF;
			IF v_UsrDay = -1 THEN
				IF sqlbuff2 IS NOT NULL AND LENGTH(sqlbuff2) > 0 THEN sqlbuff2 := sqlbuff2 || ' OR'; END IF;
				sqlbuff2 := sqlbuff2 || ' reg.regtype = ''' || REG_TYPE_DAYCASE || '''';
			END IF;
			IF sqlbuff2 IS NOT NULL AND LENGTH(sqlbuff2) > 0 THEN
				SQLSTR := SQLSTR || ' AND (' || sqlbuff2 || ')';
			END IF;
		END IF;

		IF i_DisDateFrom IS NOT NULL THEN
			IF LENGTH(i_DisDateFrom) <= 10 THEN
				SQLSTR := SQLSTR || ' AND inp.inpddate >= TO_DATE(''' || i_DisDateFrom  || ' 00:00:00'',''DD/MM/YYYY HH24:MI:SS'')';
			ELSE
				SQLSTR := SQLSTR || ' AND inp.inpddate >= TO_DATE(''' || i_DisDateFrom  || ''',''DD/MM/YYYY HH24:MI:SS'')';
			END IF;
		END IF;
		IF i_DisDateTo IS NOT NULL THEN
			IF LENGTH(i_DisDateTo) <= 10 THEN
				SQLSTR := SQLSTR || ' AND inp.inpddate <= TO_DATE(''' || i_DisDateTo  || ' 23:59:59'',''DD/MM/YYYY HH24:MI:SS'')';
			ELSE
				SQLSTR := SQLSTR || ' AND inp.inpddate <= TO_DATE(''' || i_DisDateTo  || ''',''DD/MM/YYYY HH24:MI:SS'')';
			END IF;
		END IF;
		IF i_CreateBy IS NOT NULL THEN
				SQLSTR := SQLSTR || ' AND RE.CREATE_USER LIKE ''' || i_CreateBy || ''' ';
		END IF;
		IF i_SORT IS NOT NULL AND i_SORT = 'U' THEN
			SQLSTR := SQLSTR || ' ORDER BY RE.CREATE_USER ASC, reg.regdate desc, reg.slpno desc';
		ELSE
			SQLSTR := SQLSTR || ' ORDER BY reg.regdate desc, reg.slpno desc';
		END IF;
	End If;
  RETURN sqlstr || wherestr || ordstr;
END NHS_LIS_PATIENTSEARCH2;
/
