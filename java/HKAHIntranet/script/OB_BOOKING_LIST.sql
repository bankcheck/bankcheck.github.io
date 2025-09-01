create or replace
FUNCTION OB_BOOKING_LIST ( v_edcFrom VARCHAR2, v_edcTo VARCHAR2, v_doctorCode VARCHAR2, v_countryType VARCHAR2, v_status VARCHAR2 )
RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	SQLSTR VARCHAR2(3000);
	v_ward_code VARCHAR2(10);
BEGIN
	-- get ward code
	SELECT PARAM1 INTO v_ward_code FROM SYSPARAM@IWEB WHERE PARCDE = 'obwardcode';

	IF v_status = 'B' THEN
		SQLSTR := SQLSTR || 'SELECT BB.PBPID, B.OB_BOOKING_ID, ';
		SQLSTR := SQLSTR || '       TO_CHAR(BB.BPBHDATE, ''dd/MM/YYYY''), ';
		SQLSTR := SQLSTR || '       D.DOCFNAME || '' '' || D.DOCGNAME, ';
		SQLSTR := SQLSTR || '       BB.DOCCODE, ';
		SQLSTR := SQLSTR || '       BB.PATFNAME || '' '' || BB.PATGNAME, ';
		SQLSTR := SQLSTR || '       DECODE(BB.PATDOCTYPE, ''L'', 1, ''C'', 1, 0), ';
		SQLSTR := SQLSTR || '       BB.SLPNO, ';
		SQLSTR := SQLSTR || '       BB.BPBRMK, ';
		SQLSTR := SQLSTR || '       BB.BPBSTS, ';
		SQLSTR := SQLSTR || '       DECODE(B.OB_MODIFIED_USER, NULL, BB.EDITUSER, B.OB_MODIFIED_USER), ';
		SQLSTR := SQLSTR || '       TO_CHAR(DECODE(B.OB_MODIFIED_DATE, NULL, BB.EDITDATE, B.OB_MODIFIED_DATE), ''dd/MM/YYYY''), ';
		SQLSTR := SQLSTR || '       TO_CHAR(B.OB_HOLD_EXPIRY_DATE - 1, ''dd/MM/YYYY'') ';
		SQLSTR := SQLSTR || 'FROM   BEDPREBOK@IWEB BB, OB_BOOKINGS B, DOCTOR@IWEB D ';
		SQLSTR := SQLSTR || 'WHERE  BB.DOCCODE = D.DOCCODE (+) ';
		SQLSTR := SQLSTR || 'AND    BB.PBPID = B.OB_PBP_ID (+) ';
		SQLSTR := SQLSTR || 'AND   (BB.BPBNO LIKE ''B%'' OR BB.BPBNO LIKE ''S%'') ';
		SQLSTR := SQLSTR || 'AND    BB.BPBHDATE >= TO_DATE(''' || v_edcFrom || ' 00:00:00'',''DD/MM/YYYY HH24:MI:SS'') ';
		SQLSTR := SQLSTR || 'AND    BB.BPBHDATE <= TO_DATE(''' || v_edcTo || ' 23:59:59'',''DD/MM/YYYY HH24:MI:SS'') ';
		SQLSTR := SQLSTR || 'AND    BB.BPBSTS != ''D'' ';
		SQLSTR := SQLSTR || 'AND    BB.WRDCODE = ''' || v_ward_code || ''' ';
		SQLSTR := SQLSTR || 'AND    BB.FORDELIVERY = ''-1'' ';

		IF v_doctorCode IS NOT NULL THEN
			SQLSTR := SQLSTR || 'AND    BB.DOCCODE = ''' || v_doctorCode || ''' ';
		END IF;

		IF v_countryType = 'HK' THEN
			SQLSTR := SQLSTR || 'AND    DECODE(BB.PATDOCTYPE, ''L'', 1, ''C'', 1, 0) = 0 ';
		ELSIF v_countryType = 'ML' THEN
			SQLSTR := SQLSTR || 'AND    BB.PATDOCTYPE IN (''L'', ''C'') ';
		END IF;

		SQLSTR := SQLSTR || 'ORDER BY BB.BPBHDATE ';
	ELSE
		SQLSTR := SQLSTR || 'SELECT B.OB_PBP_ID, B.OB_BOOKING_ID, ';
		SQLSTR := SQLSTR || '       TO_CHAR(B.OB_EXPECTED_DELIVERYDATE, ''dd/MM/YYYY''), ';
		SQLSTR := SQLSTR || '       D.DOCFNAME || '' '' || D.DOCGNAME, ';
		SQLSTR := SQLSTR || '       B.OB_DOCTOR_CODE, ';

		IF v_status = 'T' THEN
			SQLSTR := SQLSTR || '       Bk.BKGPNAME, ';
		ELSE
			SQLSTR := SQLSTR || '       B.OB_LASTNAME || '' '' || B.OB_FIRSTNAME, ';
		END IF;

		SQLSTR := SQLSTR || '       DECODE(B.OB_DOC_TYPE, ''L'', 1, ''C'', 1, 0), ';
		SQLSTR := SQLSTR || '       '''', B.OB_PBOREMARK, '''', ';
		SQLSTR := SQLSTR || '       B.OB_MODIFIED_USER, ';
		SQLSTR := SQLSTR || '       TO_CHAR(B.OB_MODIFIED_DATE, ''dd/MM/YYYY''), ';
		SQLSTR := SQLSTR || '       TO_CHAR(B.OB_HOLD_EXPIRY_DATE - 1, ''dd/MM/YYYY'') ';
		SQLSTR := SQLSTR || 'FROM   OB_BOOKINGS B, DOCTOR@IWEB D ';

		IF v_status = 'T' THEN
			SQLSTR := SQLSTR || ', BOOKING@IWEB BK ';
		END IF;

		SQLSTR := SQLSTR || 'WHERE  B.OB_DOCTOR_CODE = D.DOCCODE (+) ';

		IF v_status = 'X' THEN
			SQLSTR := SQLSTR || 'AND   (B.OB_BOOKING_STATUS = ''X'' ';
			SQLSTR := SQLSTR || 'OR     B.OB_PBP_ID IN (';
			SQLSTR := SQLSTR || '            SELECT PBPID ';
			SQLSTR := SQLSTR || '            FROM   BEDPREBOK@IWEB ';
			SQLSTR := SQLSTR || '            WHERE (BPBNO LIKE ''B%'' OR BPBNO LIKE ''S%'') ';
			SQLSTR := SQLSTR || '            AND    BPBHDATE >= TO_DATE(''' || v_edcFrom || ' 00:00:00'',''DD/MM/YYYY HH24:MI:SS'') ';
			SQLSTR := SQLSTR || '            AND    BPBHDATE <= TO_DATE(''' || v_edcTo || ' 23:59:59'',''DD/MM/YYYY HH24:MI:SS'') ';
			SQLSTR := SQLSTR || '            AND    BPBSTS = ''D'' ';
			SQLSTR := SQLSTR || '            AND    WRDCODE = ''' || v_ward_code || ''' ';
			SQLSTR := SQLSTR || '            AND    FORDELIVERY = ''-1'' ';
			IF v_doctorCode IS NOT NULL THEN
				SQLSTR := SQLSTR || '            AND    DOCCODE = ''' || v_doctorCode || ''' ';
			END IF;
			SQLSTR := SQLSTR || '       )) ';
		ELSE
			SQLSTR := SQLSTR || 'AND    B.OB_BOOKING_STATUS = ''' || v_status || ''' ';
		END IF;

		SQLSTR := SQLSTR || 'AND    B.OB_EXPECTED_DELIVERYDATE >= TO_DATE(''' || v_edcFrom || ''', ''dd/MM/YYYY'') ';
		SQLSTR := SQLSTR || 'AND    B.OB_EXPECTED_DELIVERYDATE <= TO_DATE(''' || v_edcTo || ''', ''dd/MM/YYYY'') ';
		SQLSTR := SQLSTR || 'AND    B.OB_ENABLED = 1 ';

		IF v_doctorCode IS NOT NULL THEN
			SQLSTR := SQLSTR || 'AND    OB_DOCTOR_CODE = ''' || v_doctorCode || ''' ';
		END IF;

		IF v_status = 'T' THEN
			SQLSTR := SQLSTR || 'AND    B.OB_BKG_ID = BK.BKGID ';
			SQLSTR := SQLSTR || 'AND    TRUNC(B.OB_HOLD_EXPIRY_DATE) + 1 > SYSDATE ';
			SQLSTR := SQLSTR || 'AND    BK.BKGSTS IN (''N'', ''F'') ';
			SQLSTR := SQLSTR || 'AND    TRUNC(BK.BKGSDATE + 1) > SYSDATE ';
		END IF;

		IF v_countryType = 'HK' THEN
			SQLSTR := SQLSTR || 'AND    DECODE(B.OB_DOC_TYPE, ''L'', 1, ''C'', 1, 0) = 0 ';
		ELSIF v_countryType = 'ML' THEN
			SQLSTR := SQLSTR || 'AND    B.OB_DOC_TYPE IN (''L'', ''C'') ';
		END IF;

		SQLSTR := SQLSTR || 'ORDER BY B.OB_EXPECTED_DELIVERYDATE ';
	END IF;

	OPEN OUTCUR FOR SQLSTR;
	RETURN OUTCUR;
END OB_BOOKING_LIST;
/