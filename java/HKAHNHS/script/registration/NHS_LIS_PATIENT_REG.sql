create or replace FUNCTION "NHS_LIS_PATIENT_REG" (
	v_PATNO VARCHAR2,
	v_REGID_IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	OUTCUR types.cursor_type;
	v_AppLabNum VARCHAR2(50);
	v_REGID NUMBER;
	v_OtaID NUMBER;
	v_Count NUMBER;
BEGIN
	SELECT param1 INTO v_AppLabNum FROM SysParam WHERE ParCde = 'AppLabNum';
	IF TO_NUMBER(v_AppLabNum) < 0 THEN
		RETURN OUTCUR;
	END IF;

	IF v_REGID_IN IS NOT NULL THEN
		SELECT COUNT(1) INTO v_Count FROM REG WHERE PATNO = v_PATNO AND REGID = v_REGID_IN;
		IF v_Count = 1 THEN
			v_REGID := v_REGID_IN;
		END IF;
	END IF;

	IF v_REGID IS NULL THEN
		SELECT REGID_C INTO v_REGID FROM PATIENT WHERE PATNO = v_PATNO;
	END IF;

	IF v_REGID IS NOT NULL THEN
		SELECT MIN(Ota.OtaID) INTO v_OtaID FROM Reg reg, OT_App ota WHERE reg.PbpID = ota.PbpID and reg.RegID = v_REGID;
	END IF;

	OPEN outcur FOR
		SELECT DISTINCT
			R.REGTYPE,
			R.REGOPCAT,
			I.BEDCODE,
			D.DPTNAME,
			W.WRDNAME,
			I.ACMCODE,
			R.REGNB,
			R.ISMAINLAND,
			I.DOCCODE_A,
			D1.DOCFNAME || ' ' || D1.DOCGNAME,
			TO_CHAR(R.REGDATE,'dd/MM/yyyy HH24:MI:SS'),
			I.SRCCODE,
			I.AMTID,
			I.INPREMARK,
			S.SLPNO,
			S.DOCCODE,
			D2.DOCFNAME || ' ' || D2.DOCGNAME,
			S.PCYID,
			P.PCYDESC,
			S.PATREFNO,
			S.SlpSID,
			E.SlpSNo,
			S.ARCCODE,
			S.SLPPLYNO,
			S.SLPVCHNO,
			S.ARLMTAMT,
			TO_CHAR(S.CVREDATE, 'dd/MM/yyyy'),
			S.COPAYTYP,
			S.COPAYAMT,
			S.ITMTYPED,
			S.ITMTYPEH,
			S.ITMTYPES,
			S.ITMTYPEO,
			S.FURGRTAMT,
			TO_CHAR(S.FURGRTDATE, 'dd/MM/yyyy'),
			R.PKGCODE,
			R.REGSTS,
/*
			(select m.mrmdesc from medrechdr mp, MEDRECMED m
				where mp.patno = v_patno
					and mp.mrmid = m.mrmid
						and mp.mrhvollab = (select max(mrhvollab) from medrechdr where MRHSTS = 'N' and patno = v_patno))
*/
			'' as mrmdesc,
/*
			(select l.mrldesc from MEDRECLOC l where l.mrlid =
				(select mrlid_l from medrecdtl where mrdid =
				(select mp.mrdid from medrechdr mp
				where mp.patno = v_patno
				and mp.mrhvollab = (select max(mrhvollab) from medrechdr where patno = v_patno)))
			)
*/
			'' AS mrloc,
			(SELECT ar.arcname FROM arcode ar WHERE ar.arccode=s.arccode) AS arcname,
			(SELECT art.actdesc FROM arcardtype art WHERE art.actid = s.actid) AS arcardtype,
			PAT.Regid_C Regid_C,
			TO_CHAR(S.PrintDate, 'dd/MM/yyyy'),
			V_OTAID,
			PAT.REGID_L REGID_L,
			I.ACTSTAYLEN,
			R.PRINT_MRRPT,
			B.EXTPHONE,
			E.SLPMID,
			E.SPRQTID,
			E.ISRECLG,
			E.ARACMCODE,
			E.PBPKGCODE,
			decode(H.HPSTATUS, 'W', 'WINDOW', 'NW', 'NON-WINDOW', H.HPSTATUS),
			E.ESTGIVN,
			FE.FESTID,
			FE.OSB_BE,
			RE.DOCCODE_REF1,
			D3.DOCFNAME || ' ' || D3.DOCGNAME,
			RE.DOCCODE_REF2,
			D4.DOCFNAME || ' ' || D4.DOCGNAME
		FROM REG R LEFT JOIN INPAT I ON R.INPID = I.INPID
			LEFT JOIN BED B ON I.BEDCODE = B.BEDCODE
			LEFT JOIN ROOM R ON B.ROMCODE = R.ROMCODE
			LEFT JOIN WARD W ON R.WRDCODE = W.WRDCODE
			LEFT JOIN DEPT D ON W.DPTCODE = D.DPTCODE
			LEFT JOIN SLIP S ON R.slpno = S.slpno
			LEFT JOIN Slip_Extra E ON S.slpno = E.slpno
			LEFT JOIN DOCTOR D1 ON I.DOCCODE_A = D1.DOCCODE
			LEFT JOIN DOCTOR D2 ON S.DOCCODE = D2.DOCCODE
			LEFT JOIN PATCAT P ON S.PCYID = P.PCYID
			LEFT JOIN HPSTATUS H ON I.BEDCODE = H.HPKEY AND H.HPTYPE = 'Bed'
			LEFT JOIN REG_EXTRA RE ON R.REGID = RE.REGID
			LEFT JOIN DOCTOR D3 ON RE.DOCCODE_REF1 = D3.DOCCODE
			LEFT JOIN DOCTOR D4 ON RE.DOCCODE_REF2 = D4.DOCCODE
/*
			LEFT JOIN medrechdr mp
*/
			LEFT JOIN PATIENT PAT ON R.PATNO = PAT.PATNO
			LEFT JOIN FIN_EST_HOSP FE ON R.slpno = FE.SLPNO
		WHERE R.REGID = v_REGID
		AND   ROWNUM < 100
		ORDER BY R.REGID;

	RETURN OUTCUR;
END NHS_LIS_PATIENT_REG;
/
