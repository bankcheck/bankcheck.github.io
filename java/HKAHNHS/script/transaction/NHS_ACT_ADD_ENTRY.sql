CREATE OR REPLACE FUNCTION "NHS_ACT_ADD_ENTRY" (
	rs_slip	   IN SLIP%ROWTYPE,
	v_pkgcode  IN VARCHAR2,
	v_itmcode  IN VARCHAR2,
	v_stat	   IN VARCHAR2 := 'N',
	v_pkgrlvl  IN NUMBER,
	v_doccode  IN VARCHAR2,
	v_acmcode  IN VARCHAR2,
	v_stntdate IN DATE,
	v_stnoamt  IN FLOAT := 0,
	v_stnbamt  IN FLOAT := 0,
	v_override IN VARCHAR2 := 'N',
	v_ref_no   IN VARCHAR2,
	v_cpsid	   IN NUMBER,
	v_unit	   IN VARCHAR2,
	v_stndesc1 IN VARCHAR2,
	v_stndesc  IN VARCHAR2,
	v_ENTRY	   IN VARCHAR2,
	v_stndisc  IN VARCHAR2,
	v_STNSTS   IN VARCHAR2,
	v_dixref   IN VARCHAR2,
	i_usrid	   IN VARCHAR2,
	o_stnid	   OUT NUMBER,
	o_stnseq   OUT NUMBER,
	o_errmsg   OUT VARCHAR2
)
	RETURN BOOLEAN
AS
	v_stnid	SLIPTX.stnid%TYPE;
	v_slpseq SLIPTX.stnseq%TYPE;
	v_acmcode2 ACM.ACMCODE%TYPE;
	v_acmcode3 ACM.ACMCODE%TYPE;
--	v_stncpsflag VARCHAR2(1);
	v_pcyid	SLIPTX.pcyid%TYPE;
	rs_item	ITEM%ROWTYPE;
	rs_itemchg ITEMCHG%ROWTYPE;
	rs_creditchg CREDITCHG%ROWTYPE;
	rs_sliptx SLIPTX%ROWTYPE;
	v_transver SLIPTX.transver%TYPE;
	-- Start SIR_HAT_2008061101, Alex KH Lee, 2008/06/12
	v_bedcode BED.BEDCODE%TYPE;
	v_dptcode VARCHAR2(10);
	itemchgsql VARCHAR2(200);
	creditchgsql VARCHAR2(200);
	tmpcur types.cursor_type;
	-- End SIR_HAT_2008061101, Alex KH Lee, 2008/06/12
BEGIN
	-- Start SIR_HAT_2008012501, Alex KH Lee, 2008/04/02
	v_acmcode3 := null;
	-- End SIR_HAT_2008012501, Alex KH Lee, 2008/04/02

	-- STNID
	SELECT seq_sliptx.NEXTVAL INTO v_stnid FROM dual;
	rs_sliptx.STNID := v_stnid;

	-- STNSEQ
	rs_sliptx.SLPNO := rs_slip.SLPNO;
	UPDATE SLIP SET slpseq = slpseq + 1 WHERE slpno = rs_slip.SLPNO;
	SELECT slpseq - 1 INTO v_slpseq FROM SLIP WHERE slpno = rs_slip.SLPNO;
	rs_sliptx.STNSEQ := v_slpseq;

	-- STNSTS
	rs_sliptx.STNSTS := v_stnsts;

	-- GET_ACMCODE
	IF rs_slip.SLPTYPE = 'I' THEN
		-- modified by Ricky So, to ignore the passed in v_acmcode
		--v_acmcode2 := Get_Acmcode(v_acmcode,v_itmcode,v_pkgcode,NULL);
		BEGIN
			-- Start SIR_HAT_2008061101, Alex KH Lee, 2008/06/12
			SELECT inpat.acmcode, inpat.bedcode
			INTO v_acmcode3, v_bedcode
			FROM inpat
			WHERE inpid IN
				(SELECT inpid FROM reg WHERE regid = rs_slip.regid);
			--SELECT inpat.acmcode
			--INTO v_acmcode3
			--FROM inpat
			--WHERE inpid IN
			--	(SELECT inpid from reg where regid = rs_slip.regid);
			-- End SIR_HAT_2008061101, Alex KH Lee, 2008/06/12

			IF SQL%ROWCOUNT = 1 THEN
				v_acmcode2 := Get_Acmcode(
					v_acmcode3,
					v_itmcode,
					v_pkgcode,
					NULL);
			END IF;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN

			-- Start SIR_HAT_2008061101, Alex KH Lee, 2008/06/12
			begin
				v_acmcode2 := NULL;
				v_bedcode := null;
			end;
			--v_acmcode2 := NULL;
			-- End SIR_HAT_2008061101, Alex KH Lee, 2008/06/12
		END;
	ELSE
		v_acmcode2 := NULL;
	END IF;

	-- PKGCODE
	rs_sliptx.PKGCODE := v_pkgcode;
	rs_sliptx.ITMCODE := v_itmcode;

	SELECT * INTO rs_item FROM ITEM WHERE itmcode = v_itmcode;

	if v_entry = 'C' then
		creditchgsql := 'select * from CREDITCHG WHERE itmcode = ''' || v_itmcode || '''';
		if v_pkgcode is null or trim(v_pkgcode) = '' then
			creditchgsql := creditchgsql || ' and PkgCode is null ';
		else
			creditchgsql := creditchgsql || ' and PkgCode = ''' || v_pkgcode || '''';
		end if;
		creditchgsql := creditchgsql || ' and itctype = ''' || rs_slip.SLPTYPE || '''';
		if rs_slip.SLPTYPE = 'I' then
			creditchgsql := creditchgsql || ' and acmcode = ''' || v_acmcode2 || '''';
		end if;
		if v_cpsid is null or trim(v_cpsid) = '' then
			creditchgsql := creditchgsql || ' and cpsid is null';
		else
			creditchgsql := creditchgsql || ' and cpsid = ' || v_cpsid;
		end if;
		creditchgsql := creditchgsql || ' and ( cicsdt IS NULL OR cicsdt <= TO_DATE(''' || TO_CHAR(v_Stntdate, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'') ) ';
		creditchgsql := creditchgsql || ' and ( cicedt IS NULL OR cicedt >= TO_DATE(''' || TO_CHAR(v_Stntdate, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'') ) ';

		open tmpcur for creditchgsql;
			loop
				fetch tmpcur into rs_creditchg;
				exit when tmpcur%notfound;
			end loop;
		close tmpcur;
	else
		itemchgsql := 'select * from ITEMCHG WHERE itmcode = ''' || v_itmcode || '''';
		if v_pkgcode is null or trim(v_pkgcode) = '' then
			itemchgsql := itemchgsql || ' and PkgCode is null ';
		else
			itemchgsql := itemchgsql || ' and PkgCode = ''' || v_pkgcode || '''';
		end if;
		itemchgsql := itemchgsql || ' and itctype = ''' || rs_slip.SLPTYPE || '''';
		if rs_slip.SLPTYPE='I' then
			itemchgsql := itemchgsql || ' and acmcode = ''' || v_acmcode2 || '''';
		end if;
		if v_cpsid is null or trim(v_cpsid) = '' then
			itemchgsql := itemchgsql || ' and cpsid is null';
		else
			itemchgsql := itemchgsql || ' and cpsid = ' || v_cpsid;
		end if;
		itemchgsql := itemchgsql || ' and ( itcsdt IS NULL OR itcsdt <= TO_DATE(''' || TO_CHAR(v_Stntdate, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'') ) ';
		itemchgsql := itemchgsql || ' and ( itcsdt IS NULL OR itcsdt >= TO_DATE(''' || TO_CHAR(v_Stntdate, 'dd/mm/yyyy') || ''', ''dd/mm/yyyy'') ) ';

		open tmpcur for itemchgsql;
			loop
				fetch tmpcur into rs_itemchg;
				exit when tmpcur%notfound;
			end loop;
		close tmpcur;
	end if;

	-- ITMTYPE
	rs_sliptx.ITMTYPE := rs_item.ITMTYPE;

	-- STNDISC
	if v_stndisc is null then
		rs_sliptx.STNDISC := 0;
		IF rs_item.ITMTYPE = 'H' THEN
			rs_sliptx.STNDISC := rs_slip.SLPHDISC;
		END IF;
		IF rs_item.ITMTYPE = 'D' THEN
			rs_sliptx.STNDISC := rs_slip.SLPDDISC;
		END IF;
		IF rs_item.ITMTYPE = 'S' THEN
			rs_sliptx.STNDISC := rs_slip.SLPSDISC;
		END IF;
	else
		rs_sliptx.STNDISC:=to_number(v_stndisc);
	end if;

	-- STNOAMT, STNBAMT
	IF v_stat = 'Y' THEN
		if v_entry='C' then
			rs_sliptx.STNOAMT := rs_creditchg.ITCAMT2;
			rs_sliptx.STNBAMT := rs_creditchg.ITCAMT2;
		else
			rs_sliptx.STNOAMT := rs_itemchg.ITCAMT2;
			rs_sliptx.STNBAMT := rs_itemchg.ITCAMT2;
		end if;

		rs_sliptx.STNCPSFLAG := 'S'; -- Normal Stat
	ELSE
		if v_entry='C' then
			rs_sliptx.STNOAMT := rs_creditchg.ITCAMT1;
			rs_sliptx.STNBAMT := rs_creditchg.ITCAMT1;
		else
			rs_sliptx.STNOAMT := rs_itemchg.ITCAMT1;
			rs_sliptx.STNBAMT := rs_itemchg.ITCAMT1;
		end if;
		rs_sliptx.STNCPSFLAG := NULL; -- Normal
	END IF;
	-- GLCCODE
	if v_entry='C' then
		rs_sliptx.GLCCODE := rs_creditchg.GLCCODE;
	else
		rs_sliptx.GLCCODE := rs_itemchg.GLCCODE;
	end if;

	-- Start SIR_HAT_2008061101, Alex KH Lee, 2008/06/12
	IF rs_slip.SLPTYPE = 'I' and length(rs_sliptx.GLCCODE) <=4 THEN
		BEGIN
			SELECT trim(c.dptcode)
			INTO v_dptcode
			FROM bed a inner join
				room b on a.romcode = b.romcode inner join
				ward c on b.wrdcode = c.wrdcode
			WHERE a.bedcode = v_bedcode;
			IF SQL%ROWCOUNT = 1 THEN
				rs_sliptx.GLCCODE := v_dptcode || rs_sliptx.GLCCODE;
			END IF;
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
			v_dptcode := NULL;
		END;
	END IF;
	-- End SIR_HAT_2008061101, Alex KH Lee, 2008/06/12

	IF v_cpsid IS NOT NULL THEN
		BEGIN
			-- remarked by Ricky to ignore the acmcode passed in
			-- v_acmcode2 := Get_Acmcode(v_acmcode,v_itmcode,v_pkgcode,v_cpsid);
			SELECT inpat.acmcode
			INTO v_acmcode3
			FROM inpat
			WHERE inpid IN
				(SELECT inpid FROM reg WHERE regid = rs_slip.regid);
			IF SQL%ROWCOUNT = 1 THEN
			v_acmcode2 := Get_Acmcode(v_acmcode3,
				v_itmcode,
				v_pkgcode,
				v_cpsid);
			END IF;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_acmcode2 := v_acmcode2;
		END;

		BEGIN
			if v_entry='C' then
				SELECT *
				INTO rs_creditchg
				FROM CREDITCHG
				WHERE itmcode = v_itmcode AND
					NVL(pkgcode, ' ') = NVL(v_pkgcode, ' ') AND
					NVL(acmcode, ' ') = NVL(v_acmcode2, ' ') AND
					itctype = rs_slip.SLPTYPE AND
					cpsid = v_cpsid;
			else
				SELECT *
				INTO rs_itemchg
				FROM ITEMCHG
				WHERE itmcode = v_itmcode AND
					NVL(pkgcode, ' ') = NVL(v_pkgcode, ' ') AND
					NVL(acmcode, ' ') = NVL(v_acmcode2, ' ') AND
					itctype = rs_slip.SLPTYPE AND
					cpsid = v_cpsid;
			end if;

			IF SQL%ROWCOUNT = 1 THEN
				if v_entry='C' then
					IF rs_creditchg.CPSPCT IS NULL THEN
						IF v_stat = 'Y' THEN
							rs_sliptx.STNBAMT := rs_creditchg.ITCAMT2;
							rs_sliptx.STNCPSFLAG := 'T'; -- CPS Stat Fix
						ELSE
							rs_sliptx.STNBAMT := rs_creditchg.ITCAMT1;
							rs_sliptx.STNCPSFLAG := 'F'; -- CPS Fix
						END IF;
					ELSE
						rs_sliptx.STNDISC := rs_creditchg.CPSPCT;
						IF v_stat = 'Y' THEN
							rs_sliptx.STNCPSFLAG := 'U'; -- CPS Stat %
						ELSE
							rs_sliptx.STNCPSFLAG := 'P'; -- CPS %
						END IF;
					END IF;

				else
					IF rs_itemchg.CPSPCT IS NULL THEN
						IF v_stat = 'Y' THEN
							rs_sliptx.STNBAMT := rs_itemchg.ITCAMT2;
							rs_sliptx.STNCPSFLAG := 'T'; -- CPS Stat Fix
						ELSE
							rs_sliptx.STNBAMT := rs_itemchg.ITCAMT1;
							rs_sliptx.STNCPSFLAG := 'F'; -- CPS Fix
						END IF;
					ELSE
						rs_sliptx.STNDISC := rs_itemchg.CPSPCT;
						IF v_stat = 'Y' THEN
							rs_sliptx.STNCPSFLAG := 'U'; -- CPS Stat %
						ELSE
							rs_sliptx.STNCPSFLAG := 'P'; -- CPS %
						END IF;
					END IF;
				end if;
			END IF;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				dbms_output.put_line('NO CPS FOUND.');
		END;
	END IF;

	-- STNBAMT
	IF rs_sliptx.STNCPSFLAG IS NULL OR rs_sliptx.STNCPSFLAG IN ('S', 'U', 'P') THEN
		IF v_override = 'Y' THEN
			if v_entry = 'C' then
				if v_stnbamt = 0 then
					rs_sliptx.STNBAMT := 0;
					rs_sliptx.stnoamt :=0;
				else
					rs_sliptx.STNBAMT := -ABS(v_stnbamt);
					rs_sliptx.stnoamt := -ABS(v_stnoamt);
				end if;
			else
				rs_sliptx.STNBAMT := ABS(v_stnbamt);
				rs_sliptx.stnoamt := ABS(v_stnoamt);
			end if;

		END IF;
	END IF;

	-- STNNAMT
	IF v_UNIT > 0 THEN
		IF rs_sliptx.STNDISC > 0 THEN
			rs_sliptx.STNNAMT := ROUND((rs_sliptx.STNBAMT / v_UNIT) * (1 - rs_sliptx.STNDISC / 100)) * v_UNIT;
		ELSE
			rs_sliptx.STNNAMT := rs_sliptx.STNBAMT;
		END IF;
	ELSE
		rs_sliptx.STNNAMT := ROUND(rs_sliptx.STNBAMT * (1 - rs_sliptx.STNDISC / 100));
	END IF;
	-- DOCCODE
	-- modified by Ricky So on 2005.11.11
	--rs_sliptx.DOCCODE = v_doccode;
	rs_sliptx.DOCCODE := rs_slip.doccode;

	-- ACMCODE
	-- Start SIR_HAT_2008012501, Alex KH Lee, 2008/04/02
	rs_sliptx.ACMCODE := v_acmcode3;
	--rs_sliptx.ACMCODE := v_acmcode2;
	-- End SIR_HAT_2008012501, Alex KH Lee, 2008/04/02

	-- USRID
	rs_sliptx.USRID := i_usrid;
	-- STNTDATE
	rs_sliptx.STNTDATE := v_stntdate;
	-- STNCDATE
	rs_sliptx.STNCDATE := SYSDATE;
	-- STNDESC
	rs_sliptx.STNDESC := rs_item.ITMNAME;
	IF rs_item.ITMCNAME IS NOT NULL THEN
		rs_sliptx.STNDESC := rs_sliptx.STNDESC || ' ' || rs_item.ITMCNAME;
	END IF;
	IF v_ref_no IS NOT NULL THEN
		rs_sliptx.STNDESC := rs_sliptx.STNDESC || ' - ' || v_ref_no;
	END IF;
	-- STNRLVL
	IF v_pkgrlvl IS NULL THEN
		rs_sliptx.STNRLVL := rs_item.ITMRLVL;
	ELSE
		rs_sliptx.STNRLVL := v_pkgrlvl;
	END IF;
	-- STNTYPE
	rs_sliptx.STNTYPE := 'D';
	-- DSCCODE
	rs_sliptx.DSCCODE := rs_item.DSCCODE;
	-- PCYID
	BEGIN
		---start Modified on 2005/09/20
		--	SELECT s.pcyid INTO v_pcyid
		--	FROM SLIP s, ITEMSCM i
		--	WHERE
		--	s.slpno = rs_slip.SLPNO
		--	AND s.slptype = i.itctype
		--	AND s.pcyid = i.pcyid
		--	AND itmcode = v_itmcode;
		SELECT s.pcyid
		Into v_Pcyid
		FROM SLIP s,ITEM I, CMCITM CD, CMCFORM CF
		WHERE s.slpno = rs_slip.SLPNO AND
			s.slptype = CD.itctype AND
			S.Pcyid = Cd.Pcyid And
			I.Itmcode = v_Itmcode And
			Cd.Itmcode = I.Itmcode And
			Cd.Appcontr = Cf.Cid And
			Cd.Eff_Dt_Frm <= To_Date(v_Stntdate,'dd/mm/yyyy') And
			Cd.Eff_Dt_To >= To_Date(v_Stntdate,'dd/mm/yyyy');
		--end Modified on 2005/09/20
		IF SQL%ROWCOUNT = 1 THEN
			rs_sliptx.PCYID := v_pcyid;
		END IF;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			BEGIN
				SELECT CD.pcyid
				Into v_Pcyid
				From Slip S,DPSERV DS,
				CMCFORM CF, CMCDPS CD, ITEM i
				WHERE s.slpno = rs_slip.SLPNO AND
					s.slptype = CD.itctype AND
					s.pcyid = CD.pcyid AND
					I.Itmcode = v_Itmcode AND
					Ds.Dsccode = I.Dsccode AND
					Cd.Dsccode = Ds.Dsccode AND
					CD.Appcontr = Cf.Cid And
					Cd.Eff_Dt_Frm <= To_Date(v_Stntdate,'dd/mm/yyyy') And
					Cd.Eff_Dt_To >= To_Date(v_Stntdate,'dd/mm/yyyy');
				IF SQL%ROWCOUNT = 1 THEN
					rs_sliptx.PCYID := v_pcyid;
				END IF;
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					rs_sliptx.PCYID := NULL;
					dbms_output.put_line('NO PCYID.');
			END;
	END;
	-- transver
	BEGIN
		SELECT MAX(param1)
		INTO   v_transver
		FROM   sysparam
		WHERE  upper(parcde) = 'MULLANGVER';

		rs_sliptx.transver := v_transver ;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			rs_sliptx.transver := NULL;
	END;

	if v_stndesc is not null then
		RS_SLIPTX.STNDESC := v_STNDESC;
	end if;

	IF v_REF_NO IS NOT NULL THEN
		RS_SLIPTX.IREFNO := v_REF_NO;
	END IF;

	IF v_DIXREF IS NULL OR LENGTH(v_DIXREF) <= 0 THEN
		RS_SLIPTX.DIXREF := RS_SLIPTX.STNID;
	ELSE
		RS_SLIPTX.DIXREF := v_DIXREF;
	END IF;

	-- Insert SQL
	INSERT INTO SLIPTX (
		STNID,
		SLPNO,
		STNSEQ,
		STNSTS,
		PKGCODE,
		ITMCODE,
		ITMTYPE,
		STNDISC,
		STNOAMT,
		STNBAMT,
		STNNAMT,
		DOCCODE,
		ACMCODE,
		GLCCODE,
		USRID,
		STNTDATE,
		STNCDATE,
		STNADOC,
		STNDESC,
		STNRLVL,
		STNTYPE,
		STNXREF,
		DSCCODE,
		DIXREF,
		STNDIDOC,
		STNCPSFLAG,
		PCYID,
		TRANSVER,
		STNDESC1,
		UNIT,
		IREFNO
	) VALUES (
		rs_sliptx.STNID,
		rs_sliptx.SLPNO,
		rs_sliptx.STNSEQ,
		rs_sliptx.STNSTS,
		rs_sliptx.PKGCODE,
		rs_sliptx.ITMCODE,
		rs_sliptx.ITMTYPE,
		rs_sliptx.STNDISC,
		rs_sliptx.STNOAMT,
		rs_sliptx.STNBAMT,
		rs_sliptx.STNNAMT,
		rs_sliptx.DOCCODE,
		rs_sliptx.ACMCODE,
		rs_sliptx.GLCCODE,
		rs_sliptx.USRID,
		rs_sliptx.STNTDATE,
		rs_sliptx.STNCDATE,
		NULL,
		rs_sliptx.STNDESC,
		rs_sliptx.STNRLVL,
		rs_sliptx.STNTYPE,
		NULL,
		rs_sliptx.DSCCODE,
		RS_SLIPTX.DIXREF,
		NULL,
		rs_sliptx.STNCPSFLAG,
		rs_sliptx.PCYID,
		RS_SLIPTX.TRANSVER,
		v_stndesc1,
		TO_NUMBER(v_UNIT),
		RS_SLIPTX.IREFNO
	);

	-- sliptx extra
	INSERT INTO SLIPTX_EXTRA(STNID, SLPNO, STNSEQ) VALUES (rs_sliptx.STNID, rs_sliptx.SLPNO, rs_sliptx.STNSEQ);

	o_stnid  := rs_sliptx.STNID;
	o_stnseq := rs_sliptx.STNSEQ;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		o_errmsg := SQLERRM;
		RETURN FALSE;

end NHS_ACT_ADD_ENTRY;
/
