CREATE OR REPLACE FUNCTION "NHS_ACT_CHGAMTDIS" (
	v_action    IN VARCHAR2,
	v_slpno     IN VARCHAR2,
	v_stnid     IN VARCHAR2,
	v_tdate     IN VARChAR2,
	v_amt       IN VARCHAR2,
	v_dis       IN VARCHAR2,
	i_usrid     IN VARCHAR2,
	o_errmsg    OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	v_Cpsid   NUMBER;
	v_bedcode BED.BEDCODE%TYPE;
	v_cdate   Date;
	o_stnid  NUMBER;
	o_stnseq NUMBER;
	rs_sliptx sliptx%ROWTYPE;
	rs_slip   slip%ROWTYPE;
	AddEntryID NUMBER;
	v_flagToDi boolean;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	if v_action='ADD' then
		v_cdate := sysdate;
		begin
			select Cpsid into v_Cpsid from Slip, Arcode where Slip.Arccode = Arcode.Arccode and Slip.Slpno = v_slpno;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			v_Cpsid := Null;
		End;

		begin
			select inpat.bedcode into v_bedcode from reg, inpat where reg.INPID = inpat.INPID and reg.slpno= v_slpno;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			v_bedcode := NULL;
		end;

		select count(1) into v_noOfRec from sliptx where stnid = to_number(v_stnid);
		if v_noOfRec = 0 then
			o_errcode := -1;
			o_errmsg := 'No record found.';
		end if;

		select * into rs_sliptx from sliptx where stnid = to_number(v_stnid);
		for m in (select * from sliptx where stnsts in ('N','A') and slpno = v_slpno and dixref = rs_sliptx.dixref)
		loop
			o_errcode := NHS_ACT_REVERSEENTRY('ADD', v_slpno, to_char(m.stnid), to_char(v_cdate,'dd/mm/yyyy HH24:MI:SS'), v_tdate, '0', i_usrid, o_errmsg);
			if o_errcode=-1 then
				rollback;
				return o_errcode;
			end if;
		end loop;

		if rs_sliptx.stndiflag = '-1' then
			v_flagToDi := TRUE;
		else
			v_flagToDi := FALSE;
		end if;

		o_errcode := NHS_UTL_ADDENTRY(
			v_slpno,
			rs_sliptx.itmcode,
			rs_sliptx.itmtype,
			rs_sliptx.stntype,
			rs_sliptx.stnoamt,
			v_amt,
			rs_sliptx.doccode,
			rs_sliptx.stnrlvl,
			rs_sliptx.acmcode,
			v_dis,
			rs_sliptx.pkgcode,
			SYSDATE,
			TO_DATE(v_tdate,'DD/MM/YYYY'),
			rs_sliptx.stndesc,
			rs_sliptx.stnsts,
			rs_sliptx.glccode,
			rs_sliptx.stnxref,
			false,
			v_bedcode,
			rs_sliptx.dixref,
			v_flagToDi,
			rs_sliptx.stncpsflag,
			v_Cpsid,
			rs_sliptx.unit,
			rs_sliptx.stndesc1,
			rs_sliptx.irefno,
			null,
			i_usrid --rs_sliptx.usrid
		);

		IF o_errcode >= 0 THEN
			update sliptx
			set
				itmcode = rs_sliptx.itmcode,
				stnrlvl = rs_sliptx.stnrlvl,
				transver = rs_sliptx.transver
			where stnid = o_stnid;
			NHS_UTL_UPDATESLIP(v_slpno);
		end if;
	end if;
	return o_errcode;
end NHS_ACT_CHGAMTDIS;
/
