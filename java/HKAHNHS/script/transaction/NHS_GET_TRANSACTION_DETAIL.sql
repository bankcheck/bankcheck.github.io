create or replace FUNCTION NHS_GET_TRANSACTION_DETAIL (
	i_SlpNo SLIP.SlpNo%TYPE
)
	RETURN Types.cursor_type
AS
	outcur Types.cursor_type;
	v_TotDCharges NUMBER;
	v_TotSCharges NUMBER;
	v_TotHCharges NUMBER;
	v_TotRefund NUMBER;
	v_OTCount NUMBER;
	v_OTSpecCount NUMBER;
	v_TellLogCount NUMBER;
	v_MiscOSCount NUMBER;
	v_DepositCount NUMBER;
	v_LABCount NUMBER;
	v_Count NUMBER;
	v_SlpMid NUMBER;
	v_SlpSNo VARCHAR2(20);
	v_SendBillDate DATE;
	v_SendBillType VARCHAR2(10);
	v_SmtRmk VARCHAR2(2000);
	v_SpRqtId  VARCHAR2(10);
	v_ISRECLG NUMBER;
	v_ARACMCODE  VARCHAR2(10);
	v_PBPKGCODE VARCHAR2(10);
	v_ESTGIVEN NUMBER;
	v_NOSIGN VARCHAR2(10);
	v_PatNo Patient.PatNo%TYPE;
	TYPE_DOCTOR VARCHAR2(1);
	TYPE_HOSPITAL VARCHAR2(1);
	TYPE_SPECIAL VARCHAR2(1);
	SLIPTX_TYPE_REFUND VARCHAR2(1);
	v_FestID FIN_EST_HOSP.FESTID%Type;
	v_BE FIN_EST_HOSP.OSB_BE%TYPE;
  v_ISAPPUSER VARCHAR2(2);
BEGIN
	v_TotDCharges := 0;
	v_TotSCharges := 0;
	v_TotHCharges := 0;
	v_TotRefund := 0;
	TYPE_DOCTOR := 'D';
	TYPE_HOSPITAL := 'H';
	TYPE_SPECIAL := 'S';
	SLIPTX_TYPE_REFUND := 'R';

	-- Hospital/Doctor/Charges
	SELECT COUNT(1) INTO v_Count FROM Sliptx WHERE SlpNo = i_SlpNo;
	IF v_Count > 0 THEN
		SELECT
			SUM(DECODE(ItmType, TYPE_DOCTOR, StnNAmt)),
			SUM(DECODE(ItmType, TYPE_HOSPITAL, DECODE(StnType, SLIPTX_TYPE_REFUND, 0, StnNAmt), 0)),
			SUM(DECODE(ItmType, TYPE_HOSPITAL, DECODE(StnType, SLIPTX_TYPE_REFUND, StnNAmt, 0), 0)),
			SUM(DECODE(ItmType, TYPE_SPECIAL, StnNAmt))
		INTO   v_TotDCharges, v_TotHCharges, v_TotRefund, v_TotSCharges
		FROM   Sliptx
		WHERE  SlpNo = i_SlpNo;
	END IF;

	-- Get Slip Misc
	SELECT COUNT(1) INTO v_Count FROM Slip_Extra WHERE SlpNo = i_SlpNo;
	IF v_Count = 1 THEN
		SELECT SlpMid, SlpSNo, SendBillDate, SendBillType, SMTRMK, SPRQTID, ISRECLG, ARACMCODE, PBPKGCODE, ESTGIVN, NOSIGN
		INTO   v_SlpMid, v_SlpSNo, v_SendBillDate, v_SendBillType, v_SmtRmk, v_SpRqtId, v_ISRECLG, v_ARACMCODE, v_PBPKGCODE, v_ESTGIVEN, v_NOSIGN
		FROM   Slip_Extra
		WHERE  SlpNo = i_SlpNo;
	END IF;

	-- OT Count
	SELECT COUNT(1) INTO v_OTCount FROM OT_log WHERE SlpNo = i_SlpNo AND (OTLSTS = 'A' OR OTLSTS = 'C');

	-- OT Spec Count
	SELECT COUNT(1) INTO v_OTSpecCount FROM OT_log WHERE SlpNo = i_SlpNo AND (OTLSTS = 'A' OR OTLSTS = 'C') AND OTLSPEC = -1;

	-- Log button
	SELECT COUNT(1) INTO v_TellLogCount FROM TELLOG WHERE SlpNo = i_SlpNo AND (STATUS <> 'D' OR STATUS IS NULL);

	-- check Misc 
	SELECT PatNo INTO v_PatNo FROM Slip WHERE SlpNo = i_SlpNo;
	SELECT COUNT(1) INTO v_MiscOSCount FROM RIS_AUTO_MATCH_LOG WHERE PATNO = v_PatNo AND STATUS = 'FAILED' AND ORDERDATE >= SYSDATE - 1;

	-- check deposit
	SELECT COUNT(1) INTO v_DepositCount FROM DEPOSIT D, SLIP S WHERE D.SLPNO_S = S.SLPNO AND S.PATNO = v_PatNo AND D.DPSSTS = 'A';

	-- check lab
	SELECT COUNT(1) INTO v_LABCount FROM sliptx sx,slip s WHERE s.slpno = sx.slpno AND s.SlpNo = i_SlpNo AND sx.dsccode='CL'
	and  SX.STNSTS IN ('N','A') and s.slptype = 'I';

	-- check *be
 	 SELECT COUNT(1) INTO v_Count FROM Fin_Est_Hosp WHERE SLPNO = i_SlpNo;
 	 IF v_COUNT = 1 THEN
  		Select Osb_Be, FESTID Into v_Be,v_FestID
		From Fin_Est_Hosp Fe
		Where Fe.Slpno = I_Slpno;
	 END IF;
   
   --check app user
   SELECT COUNT(1) INTO V_COUNT FROM PATIENT_EXTRA WHERE PATNO = v_PATNO;
 	 IF v_COUNT = 1 THEN
  		Select   DECODE(PE.APPPATNO,'','N','Y') Into v_ISAPPUSER
		From PATIENT_EXTRA PE
		Where PE.PATNO = v_PATNO;
	 END IF;   

	OPEN outcur FOR
		SELECT
			S.SlpNo, S.Regid, S.Slptype, S.Slpsts, S.Dptcode, S.Slpcamt, S.Slpdamt,
			S.Slppamt,
			S.Slpcamt + S.Slpdamt + S.Slppamt AS Balance,
			DECODE(v_TotDCharges, NULL, 0, v_TotDCharges),
			DECODE(v_TotSCharges, NULL, 0, v_TotSCharges),
			DECODE(v_TotHCharges, NULL, 0, v_TotHCharges),
			DECODE(v_TotRefund, NULL, 0, v_TotRefund),
			v_OTCount,
			P.PATNO,
			NVL(S.Slpfname, P.Patfname) AS PATFNAME,
			NVL(S.Slpgname, P.Patgname) AS PATGNAME,
			I.Bedcode, B.Extphone,
			TO_CHAR(R.Regdate, 'DD/MM/YYYY HH24:MI:SS'),
			D.DOCCODE, D.Docfname, D.Docgname,
			I.Acmcode, DECODE(S.Slptype, 'I', 'IP-' || I.Acmcode, 'D', 'DC', DECODE(S.RegOPCat, '', 'OP', 'OP-' || S.RegOPCat)),
			TO_CHAR(I.Inpddate, 'DD/MM/YYYY HH24:MI:SS'),
			Sp.Spcname, I.Inpid, S.Pcyid, S.Patrefno, SE.SlpMid, BS.BkSDesc, S.Slpplyno, S.Slpvchno,
			S.Arccode, AR.Arcname, S.Actid, DECODE(ACT.ActActive, -1, ACT.Actcode, NULL),
			DECODE(P.PatStaff, -1, 'Y', 'N'),
			S.Slpremark, S.Copaytyp, S.Arlmtamt,
			TO_CHAR(S.Cvredate, 'DD/MM/YYYY'), S.Copayamt,
			DECODE(S.ItmTypeh, -1, 'Y', 'N'),
			DECODE(S.ItmTyped, -1, 'Y', 'N'),
			DECODE(S.ItmTypes, -1, 'Y', 'N'),
			DECODE(S.ItmTypeo, -1, 'Y', 'N'),
			S.Furgrtamt,
			TO_CHAR(S.FurGrtDate, 'DD/MM/YYYY'),
			TO_CHAR(S.PrintDate, 'DD/MM/YYYY'),
			S.Copayamtact, S.Rmkmodusr, TO_CHAR(S.RMKMODDT, 'DD/MM/YYYY HH24:MI:SS'),
			DECODE(S.SlpUsear, -1, 'Y', 'N'),
			DECODE(S.SlpManall, -1, 'Y', 'N'),
			S.SlpRemark, S.SlpHDisc, S.SlpDDisc, S.SlpSDisc,
			S.SlpAddRmk, S.AddRmkModusr, S.AddRmkModdt,
			DECODE(S.IsComplex, -1, 'Y', 'N'),
			P.PatCName, P.PatSex,
			SE.SlpSNo, TO_CHAR(SE.SendBillDate, 'DD/MM/YYYY'), SE.SendBillType,
			SE.SmtRmk, SE.SpRqtId, DECODE(SE.ISRECLG, -1, 'Y', 'N'), SE.ARACMCODE, SE.PBPKGCODE, 
      SE.ESTGIVN, SE.NOSIGN,
			LENGTH(HS.HPKEY),
			v_TellLogCount,
			0,
			DECODE(P.MOTHCODE, 'TRC', P.MOTHCODE, 'SMC', P.MOTHCODE, 'ENG'),
			v_OTSpecCount,
			R.PRINT_MRRPT,
			v_DepositCount,
			v_LABCount,
			v_FestID,
			v_BE,
			LENGTH(HSI.HPKEY),
			SE.INSPREAUTHNO,
      R.PKGCODE
		FROM Slip S
      LEFT JOIN Slip_Extra SE ON S.SlpNo = SE.SlpNo
			LEFT JOIN Doctor D ON S.Doccode = D.Doccode
			LEFT JOIN Arcode AR ON S.Arccode = AR.Arccode
			LEFT JOIN Spec SP ON D.Spccode = SP.Spccode
			LEFT JOIN Reg R ON S.Regid = R.Regid
			LEFT JOIN Patient P ON S.Patno = P.Patno
			LEFT JOIN Arcardtype ACT ON S.Actid = ACT.Actid
			LEFT JOIN Inpat I ON R.Inpid = I.Inpid
			LEFT JOIN Bed B ON I.Bedcode = B.Bedcode
			LEFT JOIN Acm A ON I.Acmcode = A.Acmcode
			LEFT JOIN BookingSrc BS ON S.SlpSID = BS.BKSID
			LEFT JOIN Hpstatus Hs On S.Arccode = Hs.Hpkey And Hs.Hptype = 'ARSIGN' And Hs.Hpstatus = 'SIGNATURE' And Hpactive = -1
			LEFT JOIN HPSTATUS HSI ON S.Arccode = HSI.HPKEY And HSI.Hptype = 'ARSIGN' AND HSI.HPSTATUS = 'IPSIGNATURE' AND HSI.HPACTIVE = -1
		WHERE S.SlpNo = i_SlpNo;
	RETURN outcur;
END NHS_GET_TRANSACTION_DETAIL;