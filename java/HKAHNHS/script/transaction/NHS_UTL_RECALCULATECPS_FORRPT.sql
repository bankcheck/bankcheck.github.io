CREATE OR REPLACE FUNCTION NHS_UTL_RECALCULATECPS_FORRPT(
	i_SlpNo  IN  VARCHAR2,
	i_OUTCUR IN  TYPES.CURSOR_TYPE,
	i_UsrId  IN  VARCHAR2,
	O_ERRMSG OUT VARCHAR2
)
	RETURN NUMBER
IS
	r_ConPceChg Sys.NewConPceChange_Rec;

	O_ERRCODE NUMBER;
--	O_ERRMSG VARCHAR2(1000);
	v_ACTION VARCHAR2(10);
	v_SLPSEQ NUMBER;
	v_STNID NUMBER;
	v_STNID_DIXREF NUMBER;
	v_NOOFREC NUMBER;
	rs_sliptx SLIPTX%ROWTYPE;
	LDIXREF NUMBER;
	v_StnTDate VARCHAR2(20);
	INCUR TYPES.CURSOR_TYPE;

	-- 2ND LOOP VARIBLE
	RS_SLPTX_RV SLIPTX%ROWTYPE;
	v_STNDESC VARCHAR2(200);
	v_userCancel NUMBER := 0;
	SLIPTX_STATUS_USER_REVERSE VARCHAR2(1) := 'U';
	SLIPTX_STATUS_REVERSE VARCHAR2(1) := 'R';
	v_stncdate VARCHAR2(20);

	v_noOfRec1 NUMBER;
	SLIPTX_STATUS_CANCEL VARCHAR2(1) := 'C';
	SLIPTX_STATUS_TRANSFER VARCHAR2(1) := 'T';
	v_STNSTS1 VARCHAR2(1);

	SQLBUF1 VARCHAR2(20000);
	OUTCUR1 TYPES.CURSOR_TYPE;
	v_STNID_SLPPAYALLREVERSE NUMBER;
	v_Count NUMBER;

	RS_SPECOMDTL SPECOMDTL%ROWTYPE;
	v_STNID_SCMSLIPTXREVERSE NUMBER;
	SQLBUF2 VARCHAR2(20000);
	OUTCUR2 TYPES.CURSOR_TYPE;
	v_spdid NUMBER;

	v_TESTCOUNT NUMBER;
	v_STNID_TEST NUMBER;
	R_CONPCECHG_TEST SYS.NEWCONPCECHANGE_REC;
	v_NOOFREC_TEST1 NUMBER;

	v_ItmRLvl NUMBER;
	memOldCPSID  NUMBER;
	memOldCPSPCT NUMBER;
	memOldRate1 NUMBER;
	memOldRate2 NUMBER;
	memOldRate3 NUMBER;
	memOldRate4 NUMBER;
BEGIN
--	DBMS_OUTPUT.PUT_LINE('start i_SlpNo:'||i_SlpNo);
	o_errcode := 0;
	O_ERRMSG := 'OK';
	v_ACTION := 'ADD';

	IF I_OUTCUR IS NOT NULL THEN

		SELECT NVL(MAX(STNID),0) INTO v_STNID
		FROM (
			SELECT MAX(STNID) AS STNID
			FROM SLIPTX_FOR_RPT
			UNION
			SELECT MAX(STNID) AS STNID
			FROM SLIPTX)
		;

		SELECT NVL(MAX(STNSEQ),0) INTO v_SLPSEQ
		FROM (
			SELECT MAX(STNSEQ) AS STNSEQ FROM SLIPTX_FOR_RPT WHERE SLPNO = I_SLPNO
			UNION
			SELECT MAX(STNSEQ) AS STNSEQ FROM SLIPTX WHERE SLPNO = I_SLPNO);

		v_SLPSEQ := v_SLPSEQ + 1;

		DBMS_OUTPUT.PUT_LINE('first v_SLPSEQ:'||v_slpseq);
		LOOP
			FETCH I_OUTCUR INTO R_CONPCECHG;
			EXIT WHEN I_OUTCUR%NOTFOUND ;
			dbms_output.put_line('[' || r_ConPceChg.StnID || '][' || r_ConPceChg.newAcmCode || ']' ||
						'Old:[' || r_ConPceChg.oldBAmt || ']%:[' || r_ConPceChg.oldDisc || ']' ||
						'New:[' || R_CONPCECHG.NEWOAMT || ']:[' || R_CONPCECHG.NEWBAMT || ']%:[' ||
						R_CONPCECHG.NEWDISC || ']Flag:[' || R_CONPCECHG.NEWCPSFLAG || '][' ||
						R_CONPCECHG.NEWGLCCODE || ']');

--			SELECT COUNT(STNID) INTO v_TESTCOUNT FROM SLIPTX_FOR_RPT WHERE STNID = R_CONPCECHG.STNID;
--			DBMS_OUTPUT.PUT_LINE('[v_TESTCOUNT]:'||v_TESTCOUNT);
			IF v_Action = 'ADD' THEN
				SELECT COUNT(1) INTO v_noOfRec FROM sliptx WHERE StnID = r_ConPceChg.StnID;
				IF v_NOOFREC <= 0 THEN
					o_errcode := -1;
					o_errmsg := 'no record found.';
					RETURN o_errcode;
				END IF;

				SELECT DIXREF INTO LDIXREF FROM SLIPTX WHERE STNID = R_CONPCECHG.STNID;

				SELECT COUNT(1) INTO v_noOfRec FROM sliptx WHERE dixref = lDixref AND StnSts = 'N';
				IF v_NOOFREC <= 0 THEN
					o_errcode := -1;
					o_errmsg := 'no record found.';
					RETURN o_errcode;
				END IF;

				SELECT * INTO rs_sliptx FROM SLIPTX WHERE DIXREF = LDIXREF AND STNSTS = 'N';

				SELECT COUNT(1) INTO v_NOOFREC FROM SLIPTX_FOR_RPT WHERE STNID = R_CONPCECHG.STNID;

				OPEN INCUR FOR SELECT STNID FROM SLIPTX WHERE SLPNO = I_SLPNO AND DIXREF = LDIXREF AND STNSTS IN ('N', 'A');
				DBMS_OUTPUT.PUT_LINE('v_noOfRec>>>>'||v_NOOFREC);

				WHILE v_NOOFREC > 0
				LOOP
--					SELECT SEQ_SLIPTX.NEXTVAL INTO v_StnID FROM DUAL;
					SELECT COUNT(1) INTO v_NOOFREC FROM SLIPTX_FOR_RPT WHERE SLPNO = I_SLPNO ;
					v_StnID := v_StnID + 1;
					SELECT COUNT(1) INTO v_NOOFREC FROM SLIPTX_FOR_RPT WHERE StnID = v_StnID;
				END LOOP;

				rs_sliptx.StnID := v_StnID;
--				UPDATE SLIP SET SLPSEQ = SLPSEQ + 1 WHERE SLPNO = v_SLIPNO;
--				SELECT slpseq - 1 INTO v_slpseq FROM SLIP WHERE slpno = i_SlpNo;
--				DBMS_OUTPUT.PUT_LINE('Stnseq1:'||v_slpseq);
				rs_sliptx.slpno := i_SlpNo;
				rs_sliptx.stnseq := v_slpseq;
				rs_sliptx.acmcode := r_ConPceChg.newAcmCode;

				IF trim(r_ConPceChg.newDisc) IS NULL THEN
					rs_sliptx.StnDisc := 0;
				ELSE
					rs_sliptx.StnDisc := TO_NUMBER(r_ConPceChg.newDisc);
				END IF;

				-- retrieve without package code if empty
				IF trim(r_ConPceChg.newOAmt) IS NULL AND trim(r_ConPceChg.newBAmt) IS NULL THEN
					NHS_SYS_LOOKUPITEMCHARGE(TO_CHAR(rs_sliptx.StnTDate, 'DD/MM/YYYY'), rs_sliptx.ItmCode, 'I', r_ConPceChg.newAcmCode, FALSE, v_ItmRLvl, memOldRate1, memOldRate2, memOldRate3, memOldRate4, memOldCPSID, memOldCPSPCT, NULL);
					IF memOldRate1 IS NOT NULL AND memOldRate2 IS NOT NULL THEN
						rs_sliptx.StnOAmt := memOldRate1;
						rs_sliptx.StnBAmt := memOldRate2;
					END IF;
				ELSE
					rs_sliptx.StnOAmt := TO_NUMBER(r_ConPceChg.newOAmt);
					rs_sliptx.StnBAmt := TO_NUMBER(r_ConPceChg.newBAmt);
				END IF;

				IF rs_sliptx.UNIT > 0 THEN
					IF rs_sliptx.StnDisc > 0 THEN
						rs_sliptx.StnNAmt := ROUND((rs_sliptx.StnBAmt / rs_sliptx.UNIT) * (1 - rs_sliptx.StnDisc / 100)) * rs_sliptx.UNIT;
					ELSE
						rs_sliptx.StnNAmt := rs_sliptx.StnBAmt;
					END IF;
				ELSE
					rs_sliptx.StnNAmt := ROUND(rs_sliptx.StnBAmt * (1 - rs_sliptx.StnDisc / 100));
				END IF;
				rs_sliptx.stncdate := SYSDATE;
				rs_sliptx.usrid := i_UsrId;
				rs_sliptx.stnadoc := NULL;
				rs_sliptx.stnascm := NULL;
				rs_sliptx.stncpsflag := r_ConPceChg.newCPSFlag;
				IF trim(r_ConPceChg.NewGlcCode) IS NOT NULL THEN
					rs_sliptx.glccode := r_ConPceChg.NewGlcCode;
				END IF;
				select COUNT(1) INTO v_noOfRec FROM xreg WHERE StnID = r_ConPceChg.StnID;

				IF v_noOfRec > 0 THEN
					rs_sliptx.stndidoc := NULL;
					rs_sliptx.stndiflag := NULL;
					rs_sliptx.stnascm := NULL;
				END IF;

				INSERT INTO SLIPTX_FOR_RPT (
					StnID,
					SLPNO,
					STNSEQ,
					StnSts,
					PkgCode,
					ItmCode,
					ItmType,
					StnDisc,
					StnOAmt,
					StnBAmt,
					StnNAmt,
					DOCCODE,
					ACMCODE,
					GLCCODE,
					USRID,
					StnTDate,
					STNCDATE,
					STNADOC,
					STNDESC,
					STNRLVL,
					STNTYPE,
					STNXREF,
					DSCCODE,
					DIXREF,
					STNDIDOC,
					STNDIFLAG,
					STNCPSFLAG,
					PCYID,
					STNASCM,
					UNIT,
					PCYID_O,
					TRANSVER,
					STNDESC1,
					CARDRATE,
					PAYMETHOD,
					IREFNO
				) VALUES (
					rs_sliptx.StnID,
					rs_sliptx.SLPNO,
					rs_sliptx.STNSEQ,
					rs_sliptx.StnSts,
					rs_sliptx.PkgCode,
					rs_sliptx.ItmCode,
					rs_sliptx.ItmType,
					rs_sliptx.StnDisc,
					rs_sliptx.StnOAmt,
					rs_sliptx.StnBAmt,
					rs_sliptx.StnNAmt,
					rs_sliptx.DOCCODE,
					rs_sliptx.ACMCODE,
					rs_sliptx.GLCCODE,
					rs_sliptx.USRID,
					rs_sliptx.StnTDate,
					rs_sliptx.STNCDATE,
					rs_sliptx.STNADOC,
					rs_sliptx.STNDESC,
					rs_sliptx.STNRLVL,
					rs_sliptx.STNTYPE,
					rs_sliptx.STNXREF,
					rs_sliptx.DSCCODE,
					rs_sliptx.DIXREF,
					rs_sliptx.STNDIDOC,
					rs_sliptx.STNDIFLAG,
					rs_sliptx.STNCPSFLAG,
					rs_sliptx.PCYID,
					rs_sliptx.STNASCM,
					rs_sliptx.UNIT,
					rs_sliptx.PCYID_O,
					rs_sliptx.TRANSVER,
					rs_sliptx.STNDESC1,
					rs_sliptx.CARDRATE,
					rs_sliptx.PAYMETHOD,
					rs_sliptx.IREFNO
				);

				IF SQL%ROWCOUNT = 0 THEN
					o_errcode := -1;
					o_errmsg := 'insert fail.';
					ROLLBACK;
					RETURN o_errcode;
				END IF;
--				DBMS_OUTPUT.PUT_LINE('Stnseq1.1:'||v_slpseq);
				v_SLPSEQ := v_SLPSEQ + 1;
				v_noOfRec := 0; -- RESET

				LOOP
					FETCH INCUR INTO v_STNID_DIXREF ;
					EXIT WHEN INCUR%NOTFOUND;
--					o_errcode := NHS_ACT_REVERSEENTRY('ADD', v_SlipNo, v_StnID, NULL, v_StnTDate, '0', v_usrid, o_errmsg);
					SELECT count(1) INTO v_noOfRec FROM sliptx where stnid = TO_NUMBER(v_StnID_dixref);

					IF v_action = 'ADD' THEN
						IF v_noOfRec > 0 THEN
							SELECT * INTO RS_SLPTX_RV FROM SLIPTX WHERE STNID = TO_NUMBER(v_STNID_DIXREF);
							v_STNID := v_STNID + 1;
--							SELECT seq_sliptx.NEXTVAL INTO v_stnid1 FROM dual;
							v_stndesc := RS_SLPTX_RV.Stndesc;

							rs_slpTx_rv.Stndiflag := '';
							rs_slpTx_rv.Stnid := v_StnID;
							rs_slpTx_rv.Stnadoc := '';
							rs_slpTx_rv.Stndidoc := '';
							rs_slpTx_rv.Stnascm := '';
							rs_slpTx_rv.Stndesc := RS_SLPTX_RV.Stnseq;

							-- stnseq
--							UPDATE SLIP SET slpseq = slpseq + 1 WHERE slpno = v_slpno;
--							SELECT slpseq - 1 INTO v_nextstnseq FROM SLIP WHERE slpno = v_slpno;
--							DBMS_OUTPUT.PUT_LINE('Stnseq2:'||v_slpseq);
							rs_slpTx_rv.Stnseq := v_slpseq;
							IF trim(rs_slpTx_rv.StnOAmt) IS NULL THEN
								rs_slpTx_rv.StnOAmt := 0;
							ELSE
								rs_slpTx_rv.StnOAmt := -rs_slpTx_rv.StnOAmt;
							END IF;
							IF trim(rs_slpTx_rv.StnBAmt) IS NULL THEN
								rs_slpTx_rv.StnBAmt := 0;
							ELSE
								rs_slpTx_rv.StnBAmt := -rs_slpTx_rv.StnBAmt;
							END IF;
							IF trim(rs_slpTx_rv.StnNAmt) IS NULL THEN
								rs_slpTx_rv.StnNAmt := 0;
							ELSE
								rs_slpTx_rv.StnNAmt := -rs_slpTx_rv.StnNAmt;
							END IF;
							rs_slpTx_rv.Usrid := i_usrid;
							IF v_userCancel = '1' THEN
								rs_slpTx_rv.Stnsts := SLIPTX_STATUS_USER_REVERSE;
							ELSE
								rs_slpTx_rv.Stnsts := SLIPTX_STATUS_REVERSE;
							END IF;
--							DBMS_OUTPUT.PUT_LINE('[rs_slpTx_rv.Stnsts]:'||rs_slpTx_rv.Stnsts);
							RS_SLPTX_RV.STNDIDOC := '';

							-- tx start
							INSERT INTO SLIPTX_FOR_RPT(
								STNID       ,
								SLPNO       ,
								STNSEQ      ,
								STNSTS      ,
								PkgCode     ,
								ItmCode     ,
								ItmType     ,
								StnDisc     ,
								StnOAmt     ,
								StnBAmt     ,
								StnNAmt     ,
								DOCCODE     ,
								ACMCODE     ,
								GLCCODE     ,
								USRID       ,
								StnTDate    ,
								STNCDATE    ,
								STNADOC     ,
								STNDESC     ,
								STNRLVL     ,
								STNTYPE     ,
								STNXREF     ,
								DSCCODE     ,
								DIXREF      ,
								STNDIDOC    ,
								STNDIFLAG   ,
								STNCPSFLAG  ,
								PCYID       ,
								STNASCM     ,
								UNIT        ,
								PCYID_O     ,
								TRANSVER    ,
								STNDESC1    ,
								CARDRATE    ,
								PAYMETHOD   ,
								IREFNO
							) values (
								rs_slpTx_rv.Stnid,
								rs_slpTx_rv.Slpno,
								rs_slpTx_rv.Stnseq,
								rs_slpTx_rv.Stnsts,
								rs_slpTx_rv.PkgCode,
								rs_slpTx_rv.ItmCode,
								rs_slpTx_rv.ItmType,
								rs_slpTx_rv.StnDisc,
								rs_slpTx_rv.StnOAmt,
								rs_slpTx_rv.StnBAmt,
								rs_slpTx_rv.StnNAmt,
								rs_slpTx_rv.DOCCODE,
								rs_slpTx_rv.ACMCODE,
								rs_slpTx_rv.GLCCODE,
								rs_slpTx_rv.USRID,
								rs_slpTx_rv.StnTDate,
								rs_slpTx_rv.Stncdate,
								rs_slpTx_rv.STNADOC ,
								rs_slpTx_rv.Stndesc,
								rs_slpTx_rv.STNRLVL,
								rs_slpTx_rv.STNTYPE,
								rs_slpTx_rv.STNXREF,
								rs_slpTx_rv.DSCCODE,
								rs_slpTx_rv.DIXREF,
								rs_slpTx_rv.STNDIDOC,
								rs_slpTx_rv.STNDIFLAG,
								rs_slpTx_rv.STNCPSFLAG,
								rs_slpTx_rv.PCYID,
								rs_slpTx_rv.STNASCM,
								rs_slpTx_rv.UNIT,
								rs_slpTx_rv.PCYID_O,
								rs_slpTx_rv.TRANSVER,
								rs_slpTx_rv.STNDESC1,
								rs_slpTx_rv.CARDRATE,
								rs_slpTx_rv.PAYMETHOD,
								rs_slpTx_rv.IREFNO
							);

--							O_ERRCODE := NHS_ACT_SETENTRY('MOD',v_STNID,'C',v_STNDESC,O_ERRMSG);
--							IF O_ERRCODE = -1 THEN
--								rollback;
--								RETURN O_ERRCODE;
--							END IF;

-- /* start NHS_ACT_SETENTRY
							SELECT COUNT(1) INTO v_NOOFREC1 FROM SLIPTX_FOR_RPT WHERE STNID = TO_NUMBER(v_STNID_DIXREF);
							v_STNSTS1 := 'C';

							IF v_noOfRec1 > 0 THEN
								IF v_STNSTS1 = SLIPTX_STATUS_CANCEL THEN
								UPDATE SLIPTX_FOR_RPT SET STNSTS = v_STNSTS1, STNDESC = v_STNDESC, STNDIFLAG = '' WHERE STNID = TO_NUMBER(v_STNID_DIXREF);
							ELSIF v_STNSTS1 = SLIPTX_STATUS_TRANSFER THEN
								UPDATE SLIPTX_FOR_RPT SET StnSts = v_STNSTS1, StnDesc = v_StnDesc, StnADoc='', StnAScm = '' WHERE StnID = to_number(v_STNID_DIXREF);
							ELSE
								o_errcode := -1;
								O_ERRMSG := 'Record not exists.';
--								DBMS_OUTPUT.PUT_LINE('1[o_errcode]:'||o_errcode);
							END IF;
						ELSE
							O_ERRCODE := -1;
							O_ERRMSG := 'Record not exists.';
--							DBMS_OUTPUT.PUT_LINE('2[o_errcode]:'||O_ERRCODE);
						END IF;
-- */ end NHS_ACT_SETENTRY

--						o_errcode := NHS_ACT_SLPPAYALLSLIPTXREVERSE(v_action,v_stnid,rs_slpTx_rv.Stntype,o_errmsg);
--						IF o_errcode = -1 THEN
--							rollback;
--							RETURN o_errcode;
--						END IF;
-- /* start NHS_ACT_SLPPAYALLSLIPTXREVERSE
						IF RS_SLPTX_RV.STNTYPE='A' THEN--SLIPTX_TYPE_PAYMENT_A
							SQLBUF1:='select spd.spdid from sliptx tx, artx d, artx c, slppaydtl spd where tx.stnid ='||TO_NUMBER(v_STNID_DIXREF);
							SQLBUF1:=SQLBUF1||' and tx.stnxref = d.atxid and d.atxid = c.atxrefid and c.arpid is not null and c.atxsts =''N''';--N ARTX_STATUS_NORMAL
							SQLBUF1:=SQLBUF1||'  and tx.stntype = spd.stntype and and c.atxid = spd.payref ';
						ELSIF RS_SLPTX_RV.STNTYPE='S' OR RS_SLPTX_RV.STNTYPE='C' THEN--SLIPTX_TYPE_PAYMENT_C or SLIPTX_TYPE_CREDIT
							SQLBUF1:= 'select spd.spdid from slppaydtl spd where spd.stntype ='''||RS_SLPTX_RV.STNTYPE||'''';
							SQLBUF1:=SQLBUF1||' and spd.payref ='||TO_NUMBER(v_STNID_DIXREF);---select stnxref from sliptx where stnid = to_number(v_stnid)
						ELSIF RS_SLPTX_RV.STNTYPE='D'  THEN--SLIPTX_TYPE_DEBIT
							sqlbuf1:='select spd.spdid from slppaydtl spd where spd.stnid ='||to_number(v_STNID_DIXREF);
						else
							RETURN O_ERRCODE;
						END IF;
						SQLBUF1:= SQLBUF1||' and spd.spdsts in (''N'',''A'')';    ----SLIP_PAYMENT_USER_ALLOCATE(N),SLIP_PAYMENT_AUTO_ALLOCATE(A)
						OPEN OUTCUR1 FOR SQLBUF1;
							fetch outcur1 into v_spdid;
						LOOP
							EXIT WHEN OUTCUR1%NOTFOUND OR O_ERRCODE=-1;
							SELECT COUNT(1) INTO v_COUNT FROM SLPPAYDTL WHERE SPDID = v_SPDID;
							IF v_Count = 1 THEN
								SELECT STNID
								INTO   v_StnID_SLPPAYALLREVERSE
								FROM   SlpPayDtl
								WHERE  SPDID = v_spdid;
							ELSE
								RETURN O_ERRCODE;
							END IF;

							UPDATE SLIPTX_FOR_RPT SET STNADOC = NULL WHERE STNID = v_StnID_SLPPAYALLREVERSE;
							FETCH OUTCUR1 INTO v_SPDID;
						END LOOP;
						CLOSE OUTCUR1;
--*/ end NHS_ACT_SLPPAYALLSLIPTXREVERSE

--						o_errcode := NHS_ACT_SCMSLIPTXREVERSE(v_action,v_stnid,rs_slpTx_rv.Stntype,o_errmsg);
--						IF o_errcode = -1 THEN
--							rollback;
--							RETURN o_errcode;
--						END IF;
-- /* start NHS_ACT_SCMSLIPTXREVERSE
						IF rs_slpTx_rv.Stntype = 'A' THEN--SLIPTX_TYPE_PAYMENT_A
							SQLBUF2 := 'select syd.sydid from sliptx tx, artx d, artx c, specomdtl syd where tx.stnid ='||TO_NUMBER(v_STNID_DIXREF);
							SQLBUF2 := SQLBUF2||' and tx.stnxref = d.atxid and d.atxid = c.atxrefid and c.arpid is not null and c.atxsts =''N''';--N ARTX_STATUS_NORMAL
							SQLBUF2 := SQLBUF2||'  and tx.stntype = syd.stntype and and c.atxid = syd.payref ';
						ELSIF rs_slpTx_rv.Stntype='S' OR rs_slpTx_rv.Stntype='C' THEN--SLIPTX_TYPE_PAYMENT_C or SLIPTX_TYPE_CREDIT
							SQLBUF2 := 'select syd.sydid from specomdtl syd where syd.stntype ='''||RS_SLPTX_RV.STNTYPE||'''';
							sqlbuf2 := sqlbuf2||' and syd.payref ='||to_number(v_stnid);---select stnxref from sliptx where stnid = to_number(v_stnid)
						ELSIF rs_slpTx_rv.Stntype='D'  THEN--SLIPTX_TYPE_DEBIT
							sqlbuf2 := 'select syd.sydid from specomdtl syd where syd.stnid ='||to_number(v_STNID_DIXREF);
						ELSE
							RETURN O_ERRCODE;
						END IF;
						SQLBUF2:= SQLBUF2||' and syd.sydsts in (''N'',''A'')';    ----SLIP_PAYMENT_USER_ALLOCATE(N),SLIP_PAYMENT_AUTO_ALLOCATE(A)
						OPEN OUTCUR2 FOR SQLBUF2;
							fetch outcur2 into v_STNID_SCMSLIPTXREVERSE;
						LOOP
							EXIT WHEN outcur2%NOTFOUND or o_errcode=-1;
							BEGIN
								SELECT * INTO rs_specomdtl  FROM specomdtl WHERE sydid = to_number(v_STNID_SCMSLIPTXREVERSE);
							EXCEPTION
							WHEN OTHERS THEN
								RS_SPECOMDTL := NULL;
							END;

							UPDATE SLIPTX_FOR_RPT
							SET STNASCM = NULL
							WHERE STNID = RS_SPECOMDTL.STNID;
--							DBMS_OUTPUT.PUT_LINE('RS_SPECOMDTL:'||RS_SPECOMDTL.STNID);
						END LOOP;
						CLOSE OUTCUR2;
-- */ end NHS_ACT_SCMSLIPTXREVERSE

--						NHS_UTL_UPDATESLIP(I_SLPNO);
--						DBMS_OUTPUT.PUT_LINE('Stnseq2.1:'||v_slpseq);
							v_SLPSEQ := v_SLPSEQ + 1; -- slip.slpseq + 1
							DBMS_OUTPUT.PUT_LINE('2 next v_SLPSEQ:'||v_slpseq);
						ELSE
							o_errcode := -1;
							o_errmsg := 'No record found.';
						END IF;
					END IF;
				END LOOP;
				CLOSE INCUR;
			ELSE
				o_errcode := -1;
				o_errmsg := 'parameter error.';
			END IF;
		END LOOP;
	ELSE
		o_errcode := -1;
		RETURN o_errcode;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	o_errcode := -1;
	o_errmsg := SQLERRM;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN O_ERRCODE;
END NHS_UTL_RECALCULATECPS_FORRPT;
/
