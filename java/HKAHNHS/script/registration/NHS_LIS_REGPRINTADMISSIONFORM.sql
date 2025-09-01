create or replace FUNCTION "NHS_LIS_REGPRINTADMISSIONFORM" (
	i_category VARCHAR2,
	i_patNo    VARCHAR2,
	i_slpNo    VARCHAR2,
	DUMMY 	   VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
as
	o_errCode VARCHAR2(10);
	o_errmsg VARCHAR2(200);
	outcur TYPES.CURSOR_TYPE;
	chg_cur TYPES.CURSOR_TYPE;
	v_siteCode VARCHAR2(10);
	v_printNo NUMBER(1);
	V_ALTCODE     VARCHAR2(1000);
	v_regtype 	reg.regtype%TYPE;
	v_regdate 	VARCHAR2(10);
	v_item_rc 	item.ITMCODE%TYPE;
    v_item_wr   item.ITMCODE%TYPE;
	v_doccode 	slip.doccode%TYPE;
	v_acmcode 	inpat.acmcode%TYPE;
	v_doctype	doctor.doctype%TYPE;
	v_parcde_prtno sysparam.parcde%TYPE;

	v_stnbamt_rc sliptx.stnbamt%TYPE;
	v_stnbamt_wr  sliptx.stnbamt%TYPE;
	TYPE ItemChg_Rec IS RECORD (
	-- ItemChg : begin -----------------------------------------------------------
		pkgcode        sliptx.pkgcode%TYPE,
		itmcode        SlipTx.ItmCode%TYPE,
		itmcat         item.itmcat%TYPE,
		stnoamt        sliptx.stnoamt%TYPE,
		stnbamt        sliptx.stnbamt%TYPE,
		StnDisc        Slip.Slphdisc%TYPE,
		stntdate       DATE,
		doccode        sliptx.doccode%TYPE,
		docname		   VARCHAR2(100),
		stndesc        sliptx.stndesc%TYPE,
		acmcode        sliptx.acmcode%TYPE,-- in sys.ItemChg_Rec is SlipTx.StnDIFlag%TYPE
		stndiflag      VARCHAR2(2),
		StnCpsFlag     SlipTx.StnCpsFlag%TYPE,
		Unit           SlipTx.Unit%TYPE,
		StnDesc1       SlipTx.StnDesc%TYPE,
		IRefNo         SlipTx.IRefNo%TYPE,
		StnRlvl        SlipTx.StnRlvl%TYPE,
		ItmType        SlipTx.ItmType%TYPE
	-- ItemChg : end -------------------------------------------------------------
	);
    r_charge ItemChg_Rec;
BEGIN
	v_siteCode := GET_CURRENT_STECODE;

	SELECT LISTAGG( A.ALTCODE||':'||HPRMK, '<br>' ) WITHIN GROUP ( ORDER BY A.ALTCODE ) INTO V_ALTCODE
    FROM PATALTLINK P, ALERT A,HPSTATUS H
   	WHERE P.ALTID = A.ALTID
     AND A.ALTCODE = H.HPKEY
     AND H.HPTYPE = 'INFALTDESC'
     AND P.PATNO = I_PATNO
     AND P.PALCDATE IS NULL
     AND A.ALTPRINT = -1;

	IF i_category = 'admission' AND v_siteCode = 'TWAH' THEN
		v_parcde_prtno := 'PRTNOADM';
	ELSE
		v_parcde_prtno := 'PRTNOBIS';
	END IF;

	BEGIN
		select TO_NUMBER(PARAM1) into v_printNo from sysparam where parcde = v_parcde_prtno;
	EXCEPTION
	    WHEN OTHERS THEN
	    v_printNo := 1;
	END;

	IF i_category = 'admission' THEN
		v_stnbamt_rc := null;
		v_stnbamt_wr := null;

		IF v_siteCode = 'TWAH' THEN
			BEGIN
				select 
				    r.regtype, r.regdate, F_GET_ENTRY_113@cis(rm.wrdcode, rm.romcode,  b.bedcode) item_rc, F_GET_ENTRY_111@cis(rm.wrdcode, rm.romcode,  b.bedcode) item_wr, s.doccode, i.acmcode, d.doctype
				into
					v_regtype, v_regdate, v_item_rc, v_item_wr, v_doccode, v_acmcode, v_doctype
				from reg r
				    join slip s on r.slpno = s.slpno
				    join inpat i on r.inpid = i.inpid
				    join bed b on i.bedcode = b.bedcode
				    join room rm on b.romcode = rm.romcode
				    left join doctor d on s.doccode = d.doccode
				where s.slpno = i_slpNo
					 and rownum = 1;
			EXCEPTION
			    WHEN OTHERS THEN
			    v_item_rc := null;
			    v_stnbamt_wr := null;

			    o_errcode := NHS_ACT_SYSLOG('ADD', 'Admission', 'REGPRINTADMISSIONFORM', 'patno=' || i_patNo || ',slpno=' || i_slpNo || ',get charge error:' || SQLCODE || ' ' || SQLERRM, 'SYSTEM', NULL, o_errmsg);
			END;

			-- special logic
			IF v_item_rc = 'RC171' OR v_item_rc = 'RC172' OR v_item_rc = 'RC173' OR v_item_rc = 'RC174' OR v_item_rc = 'RC113' THEN
				v_item_rc := null;
			END IF;

			IF v_item_rc = 'RC117' OR v_item_rc = 'RC122' OR v_item_rc = 'RC123' THEN
				IF v_acmcode = 'A' OR v_acmcode = 'B' OR v_acmcode = 'C' OR v_acmcode = 'E' OR v_acmcode = 'F' OR v_acmcode = 'L' THEN
					IF v_doctype <> 'I' THEN
						v_item_wr := null;
					END IF;
				END IF;

				IF v_acmcode = 'M' THEN
					v_item_rc := 'RDC';
					v_item_wr := null;
				END IF;

				IF v_acmcode = 'G' THEN
					v_item_wr := null;
				END IF;

				IF v_acmcode = 'W' THEN
					v_item_rc := null;
					v_item_wr := null;
				END IF;
			END IF;

			IF v_item_rc = 'RC119' OR v_item_rc = 'RC150' THEN
				v_item_wr := null;
			END IF;

			-- get room charge
	        chg_cur := NHS_GET_ITEMCHG(
				    'ADD',
				    i_slpNo,
				    v_regtype,
				    v_regdate,
				    v_item_rc,
				    v_doccode,
				    v_acmcode,
				    '1',
				    NULL,
				    NULL,
				    NULL,
				    '-1',
				    v_siteCode,
				    'N',
				    '0.0',
				    NULL
				  );

	        IF chg_cur IS NOT NULL THEN
	            LOOP
					FETCH chg_cur INTO r_charge;
					EXIT WHEN chg_cur%notfound;

					v_stnbamt_rc := r_charge.stnbamt;
				END LOOP;
	            CLOSE chg_cur;
	        END IF;

			-- get ward round fee
	        chg_cur := NHS_GET_ITEMCHG(
				    'ADD',
				    i_slpNo,
				    v_regtype,
				    v_regdate,
				    v_item_wr,
				    v_doccode,
				    v_acmcode,
				    '1',
				    NULL,
				    NULL,
				    NULL,
				    '-1',
				    v_siteCode,
				    'N',
				    '0.0',
				    NULL
				  );

	        IF chg_cur IS NOT NULL THEN
	            LOOP
					FETCH chg_cur INTO r_charge;
					EXIT WHEN chg_cur%notfound;

					v_stnbamt_wr := r_charge.stnbamt;
				END LOOP;
	            CLOSE chg_cur;
	        END IF;
	        
	        o_errcode := NHS_ACT_SYSLOG('ADD', 'Admission', 'REGPRINTADMISSIONFORM', 
	        	'patno=' || i_patNo || ',slpno=' || i_slpNo || ',doccode=' || v_doccode || ',acmcode=' || v_acmcode || ',item_rc=' || v_item_rc || ',stnbamt_rc=' || to_char(v_stnbamt_rc) || ',item_wr=' || v_item_wr || ',stnbamt_wr=' || to_char(v_stnbamt_wr), 
	        	'SYSTEM', NULL, o_errmsg);
		END IF;

		Open outcur For
			SELECT
				UPPER(P.patno) AS patno,
				UPPER(P.patfname) AS patfname,
				UPPER(P.patgname) AS patgname,
				UPPER(P.patcname) AS patcname,
				TO_CHAR(P.patbdate, 'DD/MM/YYYY'),
				UPPER(P.patsex) AS patsex,
				UPPER(P.patidno) AS patidno,
				UPPER(P.Racdesc) AS racdesc,
				UPPER(P.Edulevel) AS edulevel,
				UPPER(C.Coudesc) AS coudesc,
				UPPER(P.pathtel) AS pathtel,
				UPPER(P.patotel) AS patotel,
				UPPER(P.patmsts) AS patmsts,
				UPPER(P.PATPAGER) AS patpager,
				UPPER(M.Mothdesc) AS mothdesc,
				UPPER(P.patadd1) AS patadd1,
				UPPER(P.patadd2) AS patadd2,
				UPPER(P.patadd3) AS patadd3,
				UPPER(L.Locname) AS locname,
				UPPER(P.patkname) AS patkname,
				UPPER(P.patkrela) AS patkrela,
				UPPER(P.patkhtel) AS patkhtel,
				UPPER(P.PATKADD) AS patkadd,
				UPPER(A.arcname) AS arcname,
				UPPER(S.SLPPLYNO) AS slpplyno,
				UPPER(S.SlpType) AS slptype,
				UPPER(B.RomCODE) AS romcode,
				UPPER(B.BedCode) AS bedcode,
				UPPER(S.DocCode) AS doccode,
				UPPER(D.DocFName) AS docfname,
				UPPER(D.DocGname) AS docgname,
				TO_CHAR(R.RegDate, 'DD/MM/YYYY HH24:MI:SS') AS RegDate,
				UPPER(AC.Acmname) AS acmname,
				TO_CHAR(I.INPDDATE, 'DD/MM/YYYY HH24:MI:SS') AS INPDDATE,
				UPPER(O.WrdCode) AS wrdcode,
				UPPER(P.RELIGIOUS) AS religious,
				UPPER(P.OCCUPATION) AS occupation,
				UPPER(Rel.reldesc) AS reldesc,
				UPPER(P.patkotel) AS patkotel,
				UPPER(P.patkmtel) AS patkmtel,
				UPPER(P.patkptel) AS patkptel,
				UPPER(S.SlpVchNo) AS slpvchno,
				P.PatEmail AS PatEmail,
				P.PatKEmail AS PatKEmail,
				DECODE(uo.usrname, NULL, S.USRID,uo.usrname),
				UPPER(P.patcname) AS patcname,
				v_printNo AS printNo,
				P.PATSTS as mktsts,
				P.MOTHCODE as patlang,
				DECODE(SE.SLPMID, '', '', '0', 'DEP', 'DEP' || SE.SLPMID) as rmk,		
				V_ALTCODE,
				v_stnbamt_rc as room_rate,
				v_stnbamt_wr as ward_round_rate
			FROM Inpat I, Patient P, MotherLang M, Country C, Slip S, Arcode A, Acm AC,
				Location L, Bed B, Doctor D, Reg R, Room O, Religious Rel,Slip_Extra SE,USR UO
			WHERE P.Patno = S.Patno
			AND   S.Arccode = A.Arccode(+)
			AND   S.Slpno = R.Slpno
			AND   R.Inpid = I.Inpid(+)
			AND   I.Bedcode = B.Bedcode(+)
			AND   B.Romcode = O.Romcode(+)
			AND   P.Loccode = L.Loccode(+)
			AND   P.Coucode = C.Coucode(+)
			AND   P.Mothcode = M.Mothcode(+)
			AND   S.Doccode = D.Doccode
			AND   I.Acmcode = AC.Acmcode(+)
			AND   P.religious = Rel.relcode (+)
			AND   S.SLPNO = SE.SLPNO(+)
			AND   S.USRID = UO.USRID(+)
			AND   S.slpno = i_slpNo;
	ELSE
		Open outcur For
			SELECT
				UPPER(P.patno) AS patno,
				UPPER(P.patfname) AS patfname,
				UPPER(P.patgname) AS patgname,
				UPPER(P.patcname) AS patcname,
				TO_CHAR(P.patbdate, 'DD/MM/YYYY'),
				UPPER(P.patsex) AS patsex,
				UPPER(P.patidno)||NVL2(PE.DOCTYPE,'('||(SELECT HPRMK FROM HPSTATUS WHERE HPTYPE='PATDOCTYPE' AND HPACTIVE='-1'  AND HPKEY = PE.DOCTYPE)||')','')
        ||NVL2(PE.PATADDIDNO1,'<br>'||PE.PATADDIDNO1||'('||(SELECT HPRMK FROM HPSTATUS WHERE HPTYPE='PATDOCTYPE' AND HPACTIVE='-1'  AND HPKEY = PE.PATADDDOCTYPE1)||')','')
        ||NVL2(PE.PATADDIDNO2,'<br>'||PE.PATADDIDNO2||'('||(SELECT HPRMK FROM HPSTATUS WHERE HPTYPE='PATDOCTYPE' AND HPACTIVE='-1'  AND HPKEY = PE.PATADDDOCTYPE2)||')','')
        AS patidno,
				UPPER(P.Racdesc) AS racdesc,
				UPPER(P.Edulevel) AS edulevel,
				UPPER(C.Coudesc) AS coudesc,
				UPPER(P.pathtel) AS pathtel,
				UPPER(P.patotel) AS patotel,
				UPPER(P.patmsts) AS patmsts,
				UPPER(P.PATPAGER) AS patpager,
				UPPER(M.Mothdesc) AS mothdesc,
				UPPER(P.patadd1) AS patadd1,
				UPPER(P.patadd2) AS patadd2,
				UPPER(P.patadd3) AS patadd3,
				UPPER(L.Locname) AS locname,
				UPPER(P.patkname) AS patkname,
				UPPER(P.patkrela) AS patkrela,
				UPPER(P.patkhtel) AS patkhtel,
				UPPER(P.PATKADD) AS patkadd,
				'' AS arcname,
				'' AS slpplyno,
				'' AS slptype,
				'' AS romcode,
				'' AS bedcode,
				'' AS doccode,
				'' AS docfname,
				'' AS docgname,
				'' AS RegDate,
				'' AS acmname,
				'' AS INPDDATE,
				'' AS wrdcode,
				UPPER(P.RELIGIOUS) AS religious,
				UPPER(P.OCCUPATION) AS occupation,
				UPPER(Rel.reldesc) AS reldesc,
				UPPER(P.patkotel) AS patkotel,
				UPPER(P.patkmtel) AS patkmtel,
				UPPER(P.patkptel) AS patkptel,
				'' AS slpvchno,
				P.PatEmail AS PatEmail,
				P.PatKEmail AS PatKEmail,
				'' AS usrid,
				UPPER(P.patcname) AS patcname,
				v_printNo AS printNo,
			P.PATSTS as mktsts
			FROM Patient P, MotherLang M, Country C, Location L, Religious Rel, PATIENT_EXTRA PE
			WHERE P.Loccode = L.Loccode(+)
			AND   P.Coucode = C.Coucode(+)
			AND   P.Mothcode = M.Mothcode(+)
			AND   P.religious = Rel.relcode (+)
      AND   P.PATNO = PE.PATNO(+)
			AND   P.Patno = i_patNo;
	END IF;

	Return outcur;
END NHS_LIS_REGPRINTADMISSIONFORM;
/
