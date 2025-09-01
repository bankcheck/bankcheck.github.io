CREATE OR REPLACE FUNCTION NHS_LIS_TELLOG(
	i_slpno   IN VARCHAR2,
	i_slpstr   IN VARCHAR2,
	i_chgcode IN VARCHAR2,
	i_his     IN VARCHAR2,
	i_from    IN VARCHAR2,
	i_to      IN VARCHAR2,
	i_sort    IN VARCHAR2
)
	RETURN types.cursor_type
AS
	outcur types.cursor_type;
	sqlstr VARCHAR2(2000);
begin
	sqlstr := 'SELECT Logid, Fromsys, Txtype, Slpno, Chargecde, Unit, Amount, ';
	sqlstr := sqlstr || '       Irefno, Reasons, DECODE(Status,''D'',''Delete'', ''Normal''), ';
	sqlstr := sqlstr || '       Delusr, to_char(Lastupdt, ''DD/MM/YYYY HH24:MI:SS''), ';
	sqlstr := sqlstr || '       DocCode, AcmCode, StnTDate, StnDesc1, ChrgType, DeptCode ';
	sqlstr := sqlstr || 'FROM   Tellog WHERE 1=1 ';

	IF i_his='0' then
		sqlstr := sqlstr || ' AND (Status <> ''D'' OR Status IS NULL)';
	END IF;

	IF i_from IS NOT NULL THEN
		sqlstr := sqlstr || ' AND TRUNC(lastupdt) >= TO_DATE(''' || i_from || ''', ''DD/MM/YYYY'')';
	END IF;

	IF i_to IS NOT NULL THEN
		sqlstr := sqlstr || ' AND TRUNC(lastupdt) <= TO_DATE(''' || i_to || ''', ''DD/MM/YYYY'')';
	END IF;

	IF i_slpno IS NOT NULL THEN
		IF i_slpstr IS NOT NULL THEN
			sqlstr := sqlstr || ' AND slpNo in (' || i_slpstr || ')';
		ELSE
			sqlstr := sqlstr || ' and slpNo = ''' || i_slpno || '''';
		END IF;
	END IF;

	IF i_chgcode IS NOT NULL THEN
		sqlstr := sqlstr || ' AND UPPER(CHARGECDE) = ''' || UPPER(i_chgcode) || '''';
	END IF;

	IF i_sort='FS' then
		sqlstr := sqlstr || ' ORDER BY Fromsys ';
	ELSIF i_sort='SLPNO' then
		sqlstr := sqlstr || ' ORDER BY Slpno ';
	ELSE
		sqlstr := sqlstr || ' ORDER BY Chargecde ';
	END IF;

	OPEN outcur FOR sqlstr;
	return outcur;
end NHS_LIS_TELLOG;
/
