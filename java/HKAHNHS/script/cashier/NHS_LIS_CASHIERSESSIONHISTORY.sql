CREATE OR REPLACE FUNCTION "NHS_LIS_CASHIERSESSIONHISTORY" (
	v_StartDate     IN VARCHAR2,
	v_EndDate       IN VARCHAR2,
	v_CashierCode   IN VARCHAR2
)
	return types.cursor_type
AS
	sqlstr VARCHAR2(2000);
	outcur types.cursor_type;
BEGIN
	sqlstr := 'SELECT
				CSHCODE,
				USRID,
				TO_CHAR(CshOdate, ''dd/mm/yyyy hh24:mi:ss''),
				TO_CHAR(DECODE(CshFdate, NULL, CshTS, CshFdate), ''dd/mm/yyyy hh24:mi:ss''),
				CshRcnt,
				CshCrcnt,
				CshVcnt,
				CshSID
			FROM  CASHIER_HISTORY
			WHERE CSHACT = ''HISTORY''
			AND   CshOdate > SYSDATE - 14 ';

	IF v_STARTDATE IS NOT NULL THEN
		sqlstr := sqlstr || 'AND (CshOdate >= TO_DATE(''' || v_StartDate || ' 00:00:00'', ''DD/MM/YYYY HH24:MI:SS'') ';
		sqlstr := sqlstr || 'OR   CshFdate >= TO_DATE(''' || v_StartDate || ' 00:00:00'', ''DD/MM/YYYY HH24:MI:SS'')) ';
	END IF;

	IF v_ENDDATE IS NOT NULL THEN
		sqlstr := sqlstr || 'AND (CshOdate <= TO_DATE(''' || v_EndDate || ' 23:59:59'', ''DD/MM/YYYY HH24:MI:SS'') ';
		sqlstr := sqlstr || 'OR   CshFdate <= TO_DATE(''' || v_EndDate || ' 23:59:59'', ''DD/MM/YYYY HH24:MI:SS'')) ';
	END IF;

	IF v_CashierCode IS NOT NULL THEN
		sqlstr := sqlstr || 'AND CSHCODE = ''' || v_CashierCode || ''' ';
	END IF;

	sqlstr := sqlstr || ' ORDER BY CshOdate DESC';

	OPEN outcur FOR sqlstr;
	RETURN outcur;
END NHS_LIS_CASHIERSESSIONHISTORY;
/
