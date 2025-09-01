CREATE OR REPLACE FUNCTION NHS_GET_OBCERT (
	i_SlpNo VARCHAR2,
	v_certNo VARCHAR2,
	v_currMode varchar2
)
	RETURN Types.cursor_type
AS
	v_Count NUMBER;
	v_certCount number;
	outcur types.cursor_type;
	v_dayCount number;
	sqlbuff VARCHAR2(2000);
BEGIN
	SELECT COUNT(1) INTO v_certCount FROM OBCERT WHERE certNo = v_certNo;
	SELECT COUNT(1) INTO v_Count FROM Slip WHERE SlpNo = i_SlpNo;
	SELECT param1 INTO v_dayCount from SysParam WHERE parcde = 'addedxedoc';

	IF (v_currMode = 'newCert' or v_currMode = 'seachCtByBkNo') and v_certCount = 0 THEN
		sqlbuff :=
			'SELECT
				BPB.BPBNO,
				NVL(S.SlpfName, P.PatfName)|| '', ''|| NVL(S.SlpgName, P.PatgName),
				P.PatCName,
				S.PatNo,
				TO_CHAR(P.PatBdate, ''DD/MM/YYYY''),
				bpb.patdoctype,
				BPB.PatIDNO,
				BPB.HUSFNAME|| '', ''||BPB.HUSGNAME,
				BPB.FA_CNAME,
				BPB.FA_HKIC,
				bpb.husdoctype,
				TO_CHAR(BPB.fa_dob, ''DD/MM/YYYY''),
				BPB.Doccode,
				dr.docfname|| '', ''||dr.docgname,
				dr.hkmclicno,
				dr.docotel,
				TO_CHAR(bpb.antchkdt1, ''DD/MM/YYYY''),
				TO_CHAR(bpb.antchkdt2, ''DD/MM/YYYY''),
				TO_CHAR(bpb.antchkdt3, ''DD/MM/YYYY''),
				TO_CHAR(bpb.antchkdt4, ''DD/MM/YYYY''),
				TO_CHAR(bpb.antchkdt5, ''DD/MM/YYYY''),
				TO_CHAR(bpb.antchkdt6, ''DD/MM/YYYY''),
				TO_CHAR(S.EDC, ''DD/MM/YYYY''),
				TO_CHAR(S.EDC + '||v_dayCount||', ''DD/MM/YYYY''),
				decode(p.patsex,''F'',''Female'',''M'',''Male'',''Other''),
				'''','''','''','''','''','''','''',
				''''
			FROM SLIP S,
				PATIENT P,
				BEDPREBOK BPB,
				Doctor DR
			WHERE S.PATNO   = P.PATNO(+)
			AND   S.BPBNO     = BPB.BPBNO(+)';
		if (v_currMode = 'newCert') then
			sqlbuff := sqlbuff ||  ' AND S.SLPNO = '''||i_SlpNo||'''';
		else
			sqlbuff := sqlbuff ||  ' AND BPB.BPBNO = '''||i_SlpNo||'''';
		end if;
		sqlbuff := sqlbuff ||  ' AND BPB.doccode = dr.doccode';
	elsif v_certNo is not null or i_Slpno is not null then
		sqlbuff :=
			'SELECT
				ob.BOOKINGNO,
				ob.PATNAME,
				ob.PatCName,
				ob.PatNo,
				TO_CHAR(ob.PATDOB, ''DD/MM/YYYY''),
				ob.PATDOCTYPE,
				ob.PatIDNO,
				ob.HUSNAME,
				ob.HUSCNAME,
				ob.HUSIDNO,
				ob.ISHKSPOUSE,
				TO_CHAR(ob.HUSDOB,''DD/MM/YYYY''),
				'''',
				ob.drname,
				ob.drmchkno,
				ob.drtel,
				TO_CHAR(ob.antchkdt1, ''DD/MM/YYYY''),
				TO_CHAR(ob.antchkdt2, ''DD/MM/YYYY''),
				TO_CHAR(ob.antchkdt3, ''DD/MM/YYYY''),
				TO_CHAR(ob.antchkdt4, ''DD/MM/YYYY''),
				TO_CHAR(ob.antchkdt5, ''DD/MM/YYYY''),
				TO_CHAR(ob.antchkdt6, ''DD/MM/YYYY''),
				TO_CHAR(ob.patedc, ''DD/MM/YYYY''),
				TO_CHAR(ob.patedc + '||v_dayCount||', ''DD/MM/YYYY''),
				p.patsex,
				ob.CISSUEBY,
				TO_CHAR(ob.CISEDATE,''DD/MM/YYYY''),
				TO_CHAR(ob.VALIDTILDT,''DD/MM/YYYY''),
				ob.ISVALID,
				ob.REPLTRSN,
				TO_CHAR(ob.CANCELDATE,''DD/MM/YYYY''),
				ob.remark
			FROM OBCERT ob,patient p ';
		if v_certNo IS NOT NULL then
			sqlbuff := sqlbuff ||  ' WHERE CERTNO = '''||v_certNo||''' and ob.PATNO   = P.PATNO(+)';
		elsif i_SlpNo is not null then
			sqlbuff := sqlbuff ||  ' WHERE BOOKINGNO = '''||i_SlpNo||''' and ob.PATNO   = P.PATNO(+)';
		end if;
	ELSE
		sqlbuff :=
			'SELECT
				''''
				from dual';

	END IF;
	dbms_output.put_line(sqlbuff);

	OPEN OUTCUR FOR sqlbuff;
	RETURN outcur;
END NHS_GET_OBCERT;
/
