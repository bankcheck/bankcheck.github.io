CREATE OR REPLACE FUNCTION "NHS_CMB_DOCTOR" (
	v_Source    IN VARCHAR2,
	v_filterDoc IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	Outcur  Types.Cursor_Type;
	sqlStr  VARCHAR2(1000);
BEGIN
	IF v_Source = 'ShowDocCode' THEN
		sqlStr := 'SELECT DocCode, DocFName || '' '' || DocGName || '' ('' || DocCode || '') '' || DECODE(company, NULL, NULL, '' - '' || company) FROM Doctor WHERE DocSts = -1 ';
		IF v_filterDoc = 'Y' THEN
			sqlStr := sqlStr || NHS_UTL_GETSKIPDOCCODE('DocCode');
		END IF;
		sqlStr := sqlStr || ' ORDER BY DocCode ';

		OPEN OUTCUR FOR sqlStr;
	ELSIF v_Source = 'OrderByName' THEN
		sqlStr := 'SELECT DocCode, DocFName || '' '' || DocGName || DECODE(company, NULL, NULL, '' - '' || company) FROM Doctor WHERE 1=1 ';
		IF v_filterDoc = 'Y' THEN
			sqlStr := sqlStr || NHS_UTL_GETSKIPDOCCODE('DocCode');
		END IF;
		sqlStr := sqlStr || ' ORDER BY 2 ';

		OPEN OUTCUR FOR sqlStr;
	ELSIF v_Source = 'CallChartOrderByName' THEN
		sqlStr := 'SELECT DocCode, DocFName || '' '' || DocGName || DECODE(company, NULL, NULL, '' - '' || company) FROM Doctor WHERE 1=1 ';
		IF v_filterDoc = 'Y' THEN
			sqlStr := sqlStr || NHS_UTL_GETSKIPDOCCODE('DocCode');
		END IF;

		IF GET_CURRENT_STECODE = 'HKAH' THEN
			sqlStr := sqlStr || ' UNION SELECT ''OPB BILLING OFFICE'', ''OPB BILLING OFFICE'' FROM DUAL ';
			sqlStr := sqlStr || ' UNION SELECT ''OPB CASHIER'', ''OPB CASHIER'' FROM DUAL ';
			sqlStr := sqlStr || ' UNION SELECT ''OPB REGISTRATION'', ''OPB REGISTRATION'' FROM DUAL ';
		END IF;

		sqlStr := sqlStr || ' ORDER BY 2 ';

		OPEN OUTCUR FOR sqlStr;
	ELSIF v_Source = 'OrderByNameOT' THEN
		sqlStr := 'SELECT DocCode, DocFName || '' '' || DocGName || '' ('' || DocCode || '') '' || DECODE(company, NULL, NULL, '' - ''||company) FROM Doctor WHERE 1=1 ';
		IF v_filterDoc = 'Y' THEN
			sqlStr := sqlStr || NHS_UTL_GETSKIPDOCCODE('DocCode');
		END IF;
		sqlStr := sqlStr || ' ORDER BY 2,1 ';

		OPEN OUTCUR FOR sqlStr;
	ELSE
		sqlStr := 'SELECT DocCode, DocFName || '' '' || DocGName FROM Doctor WHERE DocSts = -1 ';
		IF v_filterDoc = 'Y' THEN
			sqlStr := sqlStr || NHS_UTL_GETSKIPDOCCODE('DocCode');
		END IF;
		sqlStr := sqlStr || ' ORDER BY DocCode ';

		OPEN OUTCUR FOR sqlStr;
	END IF;
	RETURN Outcur;
END NHS_CMB_DOCTOR;
/
