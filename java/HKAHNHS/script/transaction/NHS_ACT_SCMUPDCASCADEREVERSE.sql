CREATE OR REPLACE FUNCTION NHS_ACT_SCMUPDCASCADEREVERSE(
	v_action  IN VARCHAR2,
	v_SlipNo  IN VARCHAR2,
	v_PcyID   IN VARCHAR2,
	o_errmsg  OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode    NUMBER;
	v_noOfRec    NUMBER;
	incur        types.cursor_type;
	coutcur      types.cursor_type;
	spdcur       types.cursor_type;
	sqlbuf       VARCHAR2(500);
	sql_pcyid    VARCHAR2(100);
	sql_main     VARCHAR2(500);
	sql_count    VARCHAR2(500);
	sql_dsccode  VARCHAR2(100);
	sql_itmcode  VARCHAR2(100);
	v_stnid      NUMBER;
	v_doccode    DOCTOR.DOCCODE%TYPE;
	v_slptype    VARCHAR2(1);
	v_dsccode    VARCHAR2(2);
	v_itmcode    ITEM.ITMCODE%TYPE;
	v_spdpct     NUMBER;
	v_spdfamt    NUMBER;
	v_dippct     NUMBER;
	v_dipfix     NUMBER;
	v_docpec_    VARCHAR2(100);
begin
	o_errcode := 0;
	o_errmsg := 'OK';

	if v_action='MOD' then
		select count(1) into v_noOfRec from slip s, sliptx tx, slppaydtl spd
		where s.slpno = v_SlipNo
		and s.slpno = tx.slpno
		and tx.stntype ='D'  ---SLIPTX_TYPE_DEBIT
		and tx.itmtype ='D'  ---TYPE_DOCTOR
		and tx.stnid = spd.stnid
		and spd.spdsts in ('N','A')--SLIP_PAYMENT_USER_ALLOCATE(N),SLIP_PAYMENT_AUTO_ALLOCATE(A)
		and spd.sphid is not null;

		if v_noOfRec=0 then
			return o_errcode;
		end if;

		open incur for
			select tx.stnid, tx.doccode, s.slptype, tx.dsccode, tx.itmcode, spd.spdpct, spd.spdfamt
			from slip s, sliptx tx, slppaydtl spd
			where s.slpno = v_SlipNo
			and s.slpno = tx.slpno
			and tx.stntype ='D'  ---SLIPTX_TYPE_DEBIT
			and tx.itmtype ='D'  ---TYPE_DOCTOR
			and tx.stnid = spd.stnid
			and spd.spdsts in ('N','A')--SLIP_PAYMENT_USER_ALLOCATE(N),SLIP_PAYMENT_AUTO_ALLOCATE(A)
			and spd.sphid is not null;
		LOOP
			fetch incur into v_stnid,v_doccode,v_slptype,v_dsccode,v_itmcode,v_spdpct,v_spdfamt;
			exit when incur%notfound;

			if v_PcyID is null then
				sql_pcyid:='  and pcyid is null ';
			else
				sql_pcyid:=' and pcyid='||v_PcyID;
			end if;
			sql_count:='select count(1) from docitmpct where doccode ='''||v_doccode||''' and slptype = '''||v_slptype||'''';
			sql_main:='select dippct, dipfix from docitmpct where doccode ='''||v_doccode||''' and slptype = '''||v_slptype||'''';
			sql_dsccode:=' and dsccode ='''||v_dsccode||'''';
			sql_itmcode:=' and itmcode ='''||v_itmcode||'''';
			sqlbuf:='';

			open coutcur for sql_count||sql_pcyid||sql_dsccode||sql_itmcode;
			fetch coutcur into v_noOfRec;
			close coutcur;

			if v_noOfRec<=0 then
				sql_itmcode:=' and itmcode is null ';
				open coutcur for sql_count||sql_pcyid||sql_dsccode||sql_itmcode;
				fetch coutcur into v_noOfRec;
				close coutcur;

				if v_noOfRec<=0 then
					sql_pcyid := ' and pcyid is null ';
					open coutcur for sql_count||sql_pcyid||sql_dsccode||sql_itmcode;
					fetch coutcur into v_noOfRec;
					close coutcur;

					if v_noOfRec<=0 then
						sqlbuf:='select DOCPCT_'||v_SlpType||' from doctor where doccode = '''||v_doccode||'''';
					end if;
				end if;
			end if;

			if sqlbuf='' then
				sqlbuf:=sql_count||sql_pcyid||sql_dsccode||sql_itmcode;
				open coutcur for sqlbuf;
				fetch coutcur into v_noOfRec;
				close coutcur;

				if v_noOfRec >0 then
					sqlbuf:= sql_main||sql_pcyid||sql_dsccode||sql_itmcode;
					open spdcur for sqlbuf;
					fetch spdcur into v_dippct,v_dipfix;
					close spdcur;

					if (to_char(v_spdpct)||'~'||to_char(v_spdfamt))<>(to_char(v_dippct)||'~'||to_char(v_dipfix)) then
						o_errcode:= NHS_ACT_SCMSLIPTXREVERSE('ADD',to_char(v_stnid),'D',o_errmsg);
						if o_errcode=-1 then
							rollback;
							return o_errcode;
						end if;
					end if;
				end if;
			else
				open spdcur for sqlbuf;
				fetch spdcur into v_docpec_;
				close spdcur;

				if (to_char(v_spdpct)||'~'||to_char(v_spdfamt))<>v_docpec_ then
					o_errcode:= NHS_ACT_SCMSLIPTXREVERSE('ADD',to_char(v_stnid),'D',o_errmsg);
					if o_errcode=-1 then
						rollback;
						return o_errcode;
					end if;
				end if;
			end if;
		END LOOP;
	else
		o_errcode:=-1;
		o_errmsg:='parameter error.';
	end if;
	return(o_errcode);
end NHS_ACT_SCMUPDCASCADEREVERSE;
/
