CREATE OR REPLACE FUNCTION NHS_UTL_SCMUPDATE (
	v_slpno  IN VARCHAR2,
	v_pcyid  IN VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_errmsg VARCHAR2(100);
	v_noOfRec NUMBER;
	rs_sliptx sliptx%ROWTYPE;
	v_sydid VARCHAR2(10);
	v_pcyid_old sliptx.pcyid%type;
	rs_specomdtl specomdtl%ROWTYPE;
	SLIP_PAYMENT_USER_ALLOCATE VARCHAR2(1) := 'N';
	SLIP_PAYMENT_AUTO_ALLOCATE VARCHAR2(1) := 'A';
begIN
	v_errmsg := 'OK';
	o_errcode := 0;

	UPDATE sliptx SET pcyid = NULL WHERE slpno = v_slpno AND pcyid IS NOT NULL;
	
	-- Debug
	o_errcode := NHS_ACT_SYSLOG('ADD', 'SCMUpdate', 'pcyid', v_slpno || ' reset pcyid', 'SYSTEM', null, v_errmsg);

	IF v_pcyid IS NOT NULL THEN
		FOR rs_sliptx IN (SELECT * FROM sliptx WHERE slpno = v_slpno)
		LOOP
			SELECT count(1) INTO v_noOfRec
			FROM   SLIP S
			INNER JOIN SLIPTX TX ON S.SLPNO = TX.SLPNO
			INNER JOIN ITEM I ON TX.ITMCODE = I.ITMCODE
			INNER JOIN CMCITM CD ON S.SLPTYPE = CD.ITCTYPE AND I.ITMCODE = CD.ITMCODE
			INNER JOIN CMCFORM CF ON CD.APPCONTR = CF.CID
			WHERE TX.STNID =  rs_sliptx.stnid
			AND   TX.STNTDATE >= CD.EFF_DT_FRM
			AND   TX.STNTDATE <= CD.EFF_DT_TO
			AND   CD.PCYID = v_pcyid;

			IF v_noOfRec <= 0 then
				SELECT  count(1) INTO v_noOfRec
				FROM   SLIP S
				INNER JOIN SLIPTX TX ON S.SLPNO = TX.SLPNO
				INNER JOIN ITEM I ON TX.ITMCODE = I.ITMCODE
				INNER JOIN DPSERV DS ON I.DSCCODE = DS.DSCCODE
				INNER JOIN CMCDPS CD ON S.SLPTYPE = CD.ITCTYPE AND DS.DSCCODE = CD.DSCCODE
				INNER JOIN CMCFORM CF ON CD.APPCONTR = CF.CID
				WHERE TX.STNID = rs_sliptx.stnid
				AND   TX.STNTDATE >= CD.EFF_DT_FRM
				AND   TX.STNTDATE <= CD.EFF_DT_TO
				AND   CD.PCYID = v_pcyid;
			END IF;

			IF v_noOfRec > 0 then
				SELECT  pcyid INTO v_pcyid_old
				FROM   sliptx
				WHERE stnid = rs_sliptx.stnid;
			
				UPDATE sliptx SET pcyid = v_pcyid WHERE stnid = rs_sliptx.stnid;
				
				-- Debug
				o_errcode := NHS_ACT_SYSLOG('ADD', 'SCMUpdate', 'pcyid', 'stnid:' || rs_sliptx.stnid || ', update pcyid from ' || v_pcyid_old || ' to ' || v_pcyid, 'SYSTEM', null, v_errmsg);
			END IF;
		END LOOP;

		FOR rs_specomdtl IN (SELECT * FROM specomdtl WHERE slpno = v_slpno AND sydsts IN(SLIP_PAYMENT_USER_ALLOCATE, SLIP_PAYMENT_AUTO_ALLOCATE)) LOOP
			v_sydid := to_char(rs_specomdtl.sydid);
			o_errcode := NHS_ACT_SCMREVERSE('ADD', v_sydid, '', '1', v_errmsg);
			IF o_errcode = -1 then
				RETURN o_errcode;
			END IF;
		END LOOP;
	END IF;
	o_errcode := NHS_ACT_SCMUPDCASCADEREVERSE('MOD', v_slpno, v_pcyid, v_errmsg);

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	o_errcode := -1;
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN o_errcode;
END NHS_UTL_SCMUPDATE;
/
