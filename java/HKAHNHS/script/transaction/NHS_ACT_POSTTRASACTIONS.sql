create or replace
FUNCTION NHS_ACT_POSTTRASACTIONS (
	i_action      IN VARCHAR2,
	i_slpno       IN VARCHAR2,
	i_arcode      IN VARCHAR2,
	i_actid       IN VARCHAR2,
	i_slpplyno    IN VARCHAR2,
	i_slpvchno    IN VARCHAR2,
	i_slpauthno   IN VARCHAR2,
	i_pcyid       IN VARCHAR2,
	i_patrefno    IN VARCHAR2,
	i_misc        IN VARCHAR2,
	i_source      IN VARCHAR2,
	i_arlmamt     IN VARCHAR2,
	i_copaytyp    IN VARCHAR2,
	i_copayamt    IN VARCHAR2,
	i_copayamtact IN VARCHAR2,
	i_cvredate    IN VARCHAR2,
	i_furgrtamt   IN VARCHAR2,
	i_furgrtdate  IN VARCHAR2,
	i_slpremark   IN VARCHAR2,
	i_itmtyped    IN VARCHAR2,
	i_itmtypeh    IN VARCHAR2,
	i_itmtypes    IN VARCHAR2,
	i_itmtypeo    IN VARCHAR2,
	i_slpddisc    IN VARCHAR2,
	i_slphdisc    IN VARCHAR2,
	i_slpsdisc    IN VARCHAR2,
	i_rmkmodusr   IN VARCHAR2,
	i_rmkmoddt    IN VARCHAR2,
	i_printdate   IN VARCHAR2,
	i_slpoddisc   IN VARCHAR2,
	i_slpohdisc   IN VARCHAR2,
	i_slposdisc   IN VARCHAR2,
	i_iscomplex   IN VARCHAR2,
	i_slpmanall   IN VARCHAR2,
	i_slpusear    IN VARCHAR2,
	i_sourceno    IN VARCHAR2,
	i_sendbilld   IN VARCHAR2,
	i_sendbillt   IN VARCHAR2,
	i_spcreq      IN VARCHAR2,
	i_isrqlog     IN VARCHAR2,
	i_aracmcode   IN VARCHAR2,
	i_pbpkgcode   IN VARCHAR2,
	i_estgiven    IN VARCHAR2,
	i_nosign      IN VARCHAR2,
	i_PRINT_MRRPT IN VARCHAR2,
	i_nosignUPALL IN VARCHAR2,
	i_usrid       IN VARCHAR2,
	v_BE          IN VARCHAR2,
	o_errmsg      OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_errcode_extra NUMBER;
	v_ERRMSG_extra VARCHAR2(100);
	v_noOfRec NUMBER;
	v_CpsID Arcode.CpsID%TYPE;
	v_pcyid Slip.PcyID%TYPE;
	v_acmCode Inpat.AcmCode%TYPE;
	v_misc varchar2(20);
	v_CpsID_MISC Arcode.CpsID%TYPE;
	rs_slip Slip%ROWTYPE;
	rs_slip_extra SLIP_EXTRA%ROWTYPE;
	v_sendbilldate Date;
	v_FID FIN_EST_HOSP.FESTID%TYPE;
	i_BE FIN_EST_HOSP.OSB_BE%TYPE;
	v_Outcur TYPES.CURSOR_TYPE;

	SLIP_STATUS_CLOSE VARCHAR2(1) := 'C';
	SLIP_STATUS_REMOVE VARCHAR2(1) := 'R';
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	IF i_action != 'MOD' THEN
		o_errcode := -1;
		o_errmsg := 'Parameter fail.';
		RETURN o_errcode;
	END IF;

	SELECT COUNT(1) INTO v_noOfRec FROM Slip WHERE slpno = i_slpno;
	IF v_noOfRec = 1 THEN
		SELECT * INTO rs_slip FROM Slip WHERE slpno = i_slpno;

		SELECT COUNT(1) INTO v_noOfRec FROM SLIP_EXTRA WHERE slpno = i_slpno;
		IF v_noOfRec = 1 THEN
			SELECT * INTO rs_slip_extra FROM SLIP_EXTRA WHERE slpno = i_slpno;
		END IF;

		IF i_arcode != rs_slip.arccode
				OR (i_arcode IS NULL AND rs_slip.arccode IS NOT NULL)
				OR (i_arcode IS NOT NULL AND rs_slip.arccode IS NULL) THEN

			IF i_arcode IS NOT NULL THEN
				SELECT COUNT(1) INTO v_noOfRec FROM Arcode WHERE ArcCode = i_arcode;
				IF v_noOfRec = 1 THEN
					SELECT CpsID INTO v_CpsID FROM Arcode WHERE ArcCode = i_arcode;
				ELSE
					o_errcode := -1;
					o_errmsg := 'Invalid ArCode.';
					RETURN o_errcode;
				END IF;
			ELSE
				v_CpsID := NULL;
			END IF;

			SELECT I.AcmCode INTO v_acmCode
			FROM   Slip S
			LEFT JOIN Reg R ON S.Regid = R.Regid
			LEFT JOIN Inpat I ON R.Inpid = I.Inpid
			WHERE  S.Slpno = i_slpno;

			v_Outcur := NHS_UTL_CONPCECHANGE(i_slpno, rs_slip.slptype, v_acmCode, v_CpsID, '', '', FALSE);
			o_errcode := NHS_UTL_RECALCULATECPS(i_slpno, v_Outcur, i_usrid, o_errmsg);
      
      o_errcode :=  NHS_ACT_UPDATESLIPARDRCHG('MOD', i_slpno,'AR', rs_slip.arccode,i_arcode,i_usrid, o_errmsg);
      
			IF o_errcode < 0 THEN
				o_errcode := -1;
				o_errmsg := 'Invalid recalculate CPS.';
				ROLLBACK;
				RETURN o_errcode;
			END IF;
		END IF;

		IF i_misc != rs_slip_extra.SLPMID
			OR (i_misc IS NOT NULL AND rs_slip_extra.SLPMID IS NULL)
		OR (i_misc IS NULL AND rs_slip_extra.SLPMID IS NOT NULL) THEN
			IF i_misc IS NOT NULL THEN
				SELECT COUNT(1) INTO v_noOfRec
				FROM   HPSTATUS
				WHERE  HPTYPE = 'TRANSMISC'
				AND    HPACTIVE = -1
				AND    HPKEY = i_misc;

				IF v_noOfRec = 1 THEN
					SELECT HPSTATUS INTO v_misc
					FROM   HPSTATUS
					WHERE  HPTYPE = 'TRANSMISC'
					AND    HPACTIVE = -1
					AND    HPKEY = i_misc;
				ELSE
					o_errcode := -1;
					o_errmsg := 'Invalid MISC.';
					RETURN o_errcode;
				END IF;

				IF v_misc LIKE 'DEP%' THEN
					SELECT COUNT(1) INTO v_noOfRec FROM Arcode WHERE ArcCode = v_misc;
					IF v_noOfRec = 1 THEN
						SELECT CpsID INTO v_CpsID_MISC FROM Arcode WHERE ArcCode = v_misc;
					ELSE
						o_errcode := -1;
						o_errmsg := 'Invalid MISC.';
						RETURN o_errcode;
					END IF;
				END IF;
			ELSE
				v_CpsID_MISC := NULL;
			END IF;

			SELECT I.AcmCode INTO v_acmCode
			FROM   Slip S
			LEFT JOIN Reg R ON S.Regid = R.Regid
			LEFT JOIN Inpat I ON R.Inpid = I.Inpid
			WHERE  S.Slpno = i_slpno;
			v_Outcur := NHS_UTL_CONPCECHANGE(i_slpno, rs_slip.slptype, v_acmCode, v_CpsID_MISC, '', '', FALSE);
			o_errcode := NHS_UTL_RECALCULATECPS(i_slpno, v_Outcur, i_usrid, o_errmsg);
			IF o_errcode < 0 THEN
				o_errcode := -1;
				o_errmsg := 'Invalid recalculate MISC CPS.';
				ROLLBACK;
				RETURN o_errcode;
			END IF;
		END IF;

		v_pcyid := TO_NUMBER(i_pcyid);

		IF (v_pcyid IS NULL AND rs_slip.pcyid IS NOT NULL) OR (v_pcyid IS NOT NULL AND rs_slip.pcyid IS NULL) OR v_pcyid != rs_slip.pcyid THEN
			o_errcode := NHS_UTL_SCMUPDATE(i_slpno, i_pcyid);
			IF o_errcode < 0 THEN
				o_errcode := -1;
				o_errmsg := 'Invalid SCM update.';
			END IF;
		END IF;

		rs_slip.arccode := i_arcode;
		rs_slip.actid := i_actid;
		rs_slip.slpplyno := i_slpplyno;
		rs_slip.slpvchno := i_slpvchno;

		IF i_pcyid is NULL THEN
			rs_slip.pcyid := NULL;
		ELSE
			rs_slip.pcyid := v_pcyid;
		END IF;

		rs_slip.patrefno := i_patrefno;
--		rs_slip.slpmid := i_misc;

		rs_slip.slpsid := NULL;
		IF i_source IS NOT NULL THEN
			SELECT COUNT(1) INTO v_noOfRec FROM BookingSrc WHERE Bksid = i_source;
			IF v_noOfRec > 0 THEN
				SELECT Bksid INTO rs_slip.slpsid FROM BookingSrc WHERE Bksid = i_source;
			END IF;
		END IF;

		rs_slip.arlmtamt := TO_NUMBER(i_arlmamt);
		rs_slip.copaytyp := i_copaytyp;
		rs_slip.copayamt := TO_NUMBER(i_copayamt);
		rs_slip.copayamtact := TO_NUMBER(i_copayamtact);

		IF i_cvredate is NULL THEN
			rs_slip.cvredate := NULL;
		ELSE
			IF LENGTH(i_cvredate) = 10 THEN
				rs_slip.cvredate := TO_DATE(i_cvredate, 'dd/mm/yyyy');
			ELSE
				rs_slip.cvredate := TO_DATE(i_cvredate, 'dd/mm/yyyy hh24:mi:ss');
			END IF;
		END IF;

		rs_slip.furgrtamt := TO_NUMBER(i_furgrtamt);

		IF i_furgrtdate is NULL THEN
			rs_slip.furgrtdate := NULL;
		ELSE
			IF LENGTH(i_furgrtdate) = 10 THEN
				rs_slip.furgrtdate := TO_DATE(i_furgrtdate, 'dd/mm/yyyy');
			ELSE
				rs_slip.furgrtdate := TO_DATE(i_furgrtdate, 'dd/mm/yyyy hh24:mi:ss');
			END IF;
		END IF;

		rs_slip.itmtyped := TO_NUMBER(i_itmtyped);
		rs_slip.itmtypeh := TO_NUMBER(i_itmtypeh);
		rs_slip.itmtypes := TO_NUMBER(i_itmtypes);
		rs_slip.itmtypeo := TO_NUMBER(i_itmtypeo);
		rs_slip.slpddisc := TO_NUMBER(i_slpddisc);
		rs_slip.slphdisc := TO_NUMBER(i_slphdisc);
		rs_slip.slpsdisc := TO_NUMBER(i_slpsdisc);

		IF i_slpmanall = 'Y' THEN
			rs_slip.slpmanall := -1;
		ELSIF rs_slip.slpmanall = -1 AND i_slpmanall = 'N' THEN
			rs_slip.slpmanall := 0;
		END IF;

		IF (rs_slip.slpremark IS NULL AND i_slpremark IS NOT NULL) OR
				(i_slpremark IS NULL AND rs_slip.slpremark IS NOT NULL) OR
				rs_slip.slpremark <> i_slpremark THEN
			rs_slip.slpremark := i_slpremark;
			rs_slip.rmkmodusr := i_rmkmodusr;

			IF i_rmkmoddt is NULL THEN
				rs_slip.rmkmoddt := NULL;
			ELSE
				IF LENGTH(i_rmkmoddt) = 10 THEN
					rs_slip.rmkmoddt := TO_DATE(i_rmkmoddt, 'dd/mm/yyyy');
				ELSE
					rs_slip.rmkmoddt := TO_DATE(i_rmkmoddt, 'dd/mm/yyyy hh24:mi:ss');
				END IF;
			END IF;
		END IF;

		IF i_iscomplex = 'Y' THEN
			rs_slip.iscomplex := -1;
		ELSIF rs_slip.iscomplex = -1 AND i_iscomplex = 'N' THEN
			rs_slip.iscomplex := 0;
		END IF;

		IF i_slpusear = 'Y' THEN
			rs_slip.slpusear := -1;
		ELSIF rs_slip.slpusear = -1 AND i_slpusear = 'N' THEN
			rs_slip.slpusear := 0;
		END IF;

		IF i_printdate is NULL THEN
			rs_slip.printdate := NULL;
		ELSE
			IF LENGTH(i_printdate) = 10 THEN
				rs_slip.printdate := TO_DATE(i_printdate, 'dd/mm/yyyy');
			ELSE
				rs_slip.printdate := TO_DATE(i_printdate, 'dd/mm/yyyy hh24:mi:ss');
			END IF;
		END IF;

		IF rs_slip.SLPSTS = SLIP_STATUS_CLOSE OR rs_slip.SLPSTS = SLIP_STATUS_REMOVE THEN
			UPDATE Slip set
				slpremark = rs_slip.slpremark,
				patrefno = rs_slip.patrefno,
				rmkmodusr = rs_slip.rmkmodusr,
				rmkmoddt = rs_slip.rmkmoddt
			WHERE slpno = i_slpno;

			IF SQL%rowcount = 0 THEN
				o_errcode := -1;
				o_errmsg := 'update fail.';
				ROLLBACK;
				RETURN o_errcode;
			END IF;

			IF i_sendbilld IS NULL THEN
				v_sendbilldate := NULL;
			ELSE
				v_sendbilldate := TO_DATE(i_sendbilld, 'dd/mm/yyyy');
			END IF;

			SELECT COUNT(1) INTO v_noOfRec FROM Slip_Extra WHERE slpno = i_slpno;
			IF v_noOfRec = 0 THEN
				INSERT INTO Slip_Extra (
					slpno, sendbilldate, sendbilltype
				) VALUES (
					i_slpno, v_sendbilldate, i_sendbillt
				);
			ELSE
				UPDATE Slip_Extra set
					sendbilldate = v_sendbilldate,
					sendbilltype = i_sendbillt
				WHERE slpno = i_slpno;
			END IF;

			--IF i_nosign IS NOT NULL THEN
				v_errcode_extra := NHS_ACT_UPDATEREGNOSIGN('MOD', rs_slip.REGID, i_slpno, i_nosign, i_nosignUPALL, v_ERRMSG_extra);
			--END IF;
		ELSE
			UPDATE Slip set
				arccode = rs_slip.arccode,
				actid = rs_slip.actid,
				slpplyno = rs_slip.slpplyno,
				slpvchno = rs_slip.slpvchno,
				pcyid = rs_slip.pcyid,
--				slpmid = rs_slip.slpmid,
				slpsid = rs_slip.slpsid,
				patrefno = rs_slip.patrefno,
				arlmtamt = rs_slip.arlmtamt,
				copaytyp = rs_slip.copaytyp,
				copayamt = rs_slip.copayamt,
				copayamtact = rs_slip.copayamtact,
				cvredate = rs_slip.cvredate,
				furgrtamt = rs_slip.furgrtamt,
				furgrtdate = rs_slip.furgrtdate,
				slpremark = rs_slip.slpremark,
				itmtyped = rs_slip.itmtyped,
				itmtypeh = rs_slip.itmtypeh,
				itmtypes = rs_slip.itmtypes,
				itmtypeo = rs_slip.itmtypeo,
				slpddisc = rs_slip.slpddisc,
				slphdisc = rs_slip.slphdisc,
				slpsdisc = rs_slip.slpsdisc,
				rmkmodusr = rs_slip.rmkmodusr,
				rmkmoddt = rs_slip.rmkmoddt,
				iscomplex = rs_slip.iscomplex,
				slpusear = rs_slip.slpusear,
				printdate = rs_slip.printdate,
				slpmanall = rs_slip.slpmanall
			WHERE slpno = i_slpno;

			-- Debug
			o_errcode := NHS_ACT_SYSLOG('ADD', 'PostTx', 'pcyid', i_slpno || ' update to ' || rs_slip.pcyid, 'SYSTEM', null, o_errmsg);

			IF SQL%rowcount = 0 THEN
				o_errcode := -1;
				o_errmsg := 'update fail.';
				ROLLBACK;
				RETURN o_errcode;
			END IF;

			IF i_sendbilld IS NULL THEN
				v_sendbilldate := NULL;
			ELSE
				v_sendbilldate := TO_DATE(i_sendbilld, 'dd/mm/yyyy');
			END IF;

			Select Count(1) Into V_Noofrec From Fin_Est_Hosp Where Slpno = I_Slpno;
				If V_Noofrec = 0 Then
					IF (v_BE <> '0')THEN
						Insert Into Fin_Est_Hosp
						(Festid,SLPNO,Osb_Be)
						Values (Seq_Fest.Nextval,i_slpno, v_BE);
					End If;
				Else
					If (v_BE Is Not Null) Then
						SELECT FESTID, OSB_BE INTO V_FID,I_BE FROM FIN_EST_HOSP WHERE Slpno = I_Slpno;
						IF ( I_BE IS NOT NULL AND I_BE = '-1' AND v_BE = '0') THEN
							DELETE FROM FIN_EST_HOSP
							WHERE FESTID = V_FID;
						ELSE
							UPDATE FIN_EST_HOSP SET
								Osb_Be = v_BE
							WHERE FESTID = V_FID;
						END IF;
					End If;
			END IF;

			SELECT COUNT(1) INTO v_noOfRec FROM Slip_Extra WHERE slpno = i_slpno;
			IF v_noOfRec = 0 THEN
				INSERT INTO Slip_Extra (
					slpno, slpmid, slpsno, sendbilldate, sendbilltype, SPRQTID, ISRECLG, ARACMCODE, PBPKGCODE, ESTGIVN, INSPREAUTHNO
				) VALUES (
					i_slpno, i_misc, i_sourceno, v_sendbilldate, i_sendbillt, i_spcreq, i_isrqlog, i_aracmcode, i_pbpkgcode, i_estgiven, i_slpauthno
				);
			ELSE
				UPDATE Slip_Extra set
					slpmid = i_misc,
					slpsno = i_sourceno,
					sendbilldate = v_sendbilldate,
					sendbilltype = i_sendbillt,
					SPRQTID = i_spcreq,
					ISRECLG   = i_isrqlog,
					ARACMCODE = i_aracmcode,
					PBPKGCODE = i_pbpkgcode,
					ESTGIVN = i_estgiven,
					INSPREAUTHNO = i_slpauthno
				WHERE slpno = i_slpno;
			END IF;

		--	IF i_nosign IS NOT NULL THEN
				v_errcode_extra := NHS_ACT_UPDATEREGNOSIGN('MOD', rs_slip.REGID, i_slpno, i_nosign, i_nosignUPALL, v_ERRMSG_extra);
		--	END IF;

			o_errcode := NHS_ACT_UPDATESLIPDISCOUNT(
				'MOD', i_slpno,
				i_slpoddisc, TO_CHAR(ROUND(TO_NUMBER(i_slpddisc), 1)),
				i_slpohdisc, TO_CHAR(ROUND(TO_NUMBER(i_slphdisc), 1)),
				i_slposdisc, TO_CHAR(ROUND(TO_NUMBER(i_slpsdisc), 1)),
				i_usrid, o_errmsg);

			IF o_errcode = -1 THEN
				ROLLBACK;
				RETURN o_errcode;
			END IF;

			UPDATE REG
			SET PRINT_MRRPT =  TO_NUMBER(i_PRINT_MRRPT)
			WHERE regid = (SELECT regid FROM SLIP WHERE slpno = i_slpno);

			IF o_errcode = -1 THEN
				ROLLBACK;
				RETURN O_ERRCODE;
			END IF;

			NHS_UTL_UPDATESLIP(i_slpno);
		END IF;
	ELSE
		o_errcode := -1;
		o_errmsg := 'No record found.';
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	o_errcode := -1;
	o_errmsg := 'Fail to update. ' || SQLERRM;
	ROLLBACK;
	RETURN o_errcode;
end NHS_ACT_POSTTRASACTIONS;
/
