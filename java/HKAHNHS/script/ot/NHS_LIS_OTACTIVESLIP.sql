CREATE OR REPLACE FUNCTION "NHS_LIS_OTACTIVESLIP" (
	i_PatNo       IN VARCHAR2,
	i_UserType    IN VARCHAR2,
	i_OperateDate IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	SLIP_STATUS_OPEN VARCHAR2(1) := 'A';
	sSql VARCHAR2(2000);
	sSubSql VARCHAR2(2000);
	sOrderSql VARCHAR2(1000);
	v_OperateDate DATE;
	v_slip1 Slip.slpno%TYPE;
	v_slip2 Slip.slpno%TYPE;
	bIsDate BOOLEAN;
BEGIN
	bIsDate := FALSE;
	BEGIN
		v_OperateDate := to_date(i_OperateDate, 'dd/mm/yyyy');
		bIsDate := TRUE;
	EXCEPTION
	WHEN OTHERS THEN
		bIsDate := FALSE;
	END;

	sSql := 'select s.slpNo, s.slpType from Slip s,Reg r, Inpat i ' ||
		'where  s.regid = r.regid and s.slpsts = ''' || SLIP_STATUS_OPEN || ''' and r.Regsts = ''N'' ' ||
		'and    r.PatNo = ''' || i_PatNo || ''' and r.RegType = ''' || i_UserType || ''' and r.inpid = i.inpid (+) ';

	IF i_UserType = 'I' THEN
		IF bIsDate THEN
			sSubSql := ' and (( trunc(to_date( ''' || i_OperateDate || ''',''dd/mm/yyyy'')) between trunc(regdate) and trunc(i.inpddate) ) or ((to_date(''' || i_OperateDate || ''',''dd/mm/yyyy'')>=trunc(regdate)) and i.inpddate is null)) ';
		ELSE
			sSubSql := ' ';
		END IF;
		sOrderSql := 'order by s.slpno desc';
	ELSIF i_UserType = 'O' THEN
		v_slip1 := TO_CHAR(sysdate - 1, 'yyyyddd') || '0000';
		v_slip2 := TO_CHAR(sysdate + 1, 'yyyyddd') || '9999';
		IF bIsDate THEN
			sSql := 'select s.slpNo, s.slpType from Slip s, Reg r, Inpat i where s.regid = r.regid and r.Regsts = ''N'' ' ||
				'and r.PatNo = ''' || i_PatNo || ''' and r.RegType = ''O'' and r.inpid = i.inpid (+) ' ||
				'and (to_date( ''' || i_OperateDate || ''',''dd/mm/yyyy'') between trunc(regdate) and regdate + 1) ' ||
				'and s.regid is not null and s.slpsts = ''' || SLIP_STATUS_OPEN || ''' ' ||
				'Union ' ||
				'select slpNo, slpType from slip where patNo = ''' || i_PatNo || ''' and slpType = ''O'' and regid is null ' ||
				'and    slpNo between ''' || v_slip1 || ''' and ''' || v_slip2 || ''' and slpsts = ''' || SLIP_STATUS_OPEN || ''' ';
		ELSE
			sSql := 'select s.slpNo, s.slpType from Slip s, Reg r, Inpat i where s.regid = r.regid and r.Regsts = ''N'' ' ||
				'and r.PatNo = ''' || i_PatNo || ''' and r.RegType = ''O'' and r.inpid = i.inpid (+) ' ||
				'and s.regid is not null and s.slpsts = ''' || SLIP_STATUS_OPEN || ''' ' ||
				'Union ' ||
				'select slpNo, slpType from slip where patNo = ''' || i_PatNo || ''' and slpType = ''O'' and regid is null ' ||
				'and    slpNo between ''' || v_slip1 || ''' and ''' || v_slip2 || ''' and slpsts = ''' || SLIP_STATUS_OPEN || ''' ';
		END IF;
		sOrderSql := 'order by slpno desc';
	ELSIF i_UserType = 'D' THEN
		IF bIsDate THEN
			sSubSql := ' and (to_date( ''' || i_OperateDate || ''',''dd/mm/yyyy'') between trunc(regdate) and regdate + 1) ';
		ELSE
			sSubSql := ' ';
		END IF;
		sOrderSql := 'order by s.slpno desc';
	END IF;

	OPEN OUTCUR FOR
		sSql || sSubSql || sOrderSql;
	RETURN OUTCUR;
END NHS_LIS_OTACTIVESLIP;
/
