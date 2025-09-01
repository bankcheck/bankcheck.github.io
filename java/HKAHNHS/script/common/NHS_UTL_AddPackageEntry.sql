CREATE OR REPLACE FUNCTION NHS_UTL_AddPackageEntry (
	i_SlipNo           IN VARCHAR2,
	i_PackageCode      IN VARCHAR2,
	i_ItemCode         IN VARCHAR2,
	i_StnOAmt          IN NUMBER,
	i_StnBAmt          IN NUMBER,
	i_DoctorCode       IN VARCHAR2,
	i_ReportLevel      IN NUMBER,
	i_AccomodationCode IN VARCHAR2,
	i_CaptureDate      IN DATE,
	i_TransactionDate  IN DATE,
	i_Description      IN VARCHAR2,
	i_Status           IN VARCHAR2,
--	i_CashierClosed    IN BOOLEAN := FALSE,
	i_BedCode          IN VARCHAR2,
	i_DIXRef           IN NUMBER,
	i_FlagToDi         IN BOOLEAN := FALSE,
	i_ConPceSetFlag    IN VARCHAR2,
	i_UnitAmt          IN NUMBER,
	i_Stndesc1         IN VARCHAR2,
	i_IRefNo           IN VARCHAR2,
	i_DeptCode         IN VARCHAR2,
	i_GlcCode          IN VARCHAR2,
	i_PkgcodeInLkUpGlccode IN BOOLEAN := FALSE,
	i_UsrID            IN VARCHAR2
)
	RETURN NUMBER
AS
	v_PackageCode	package.pkgcode%TYPE;
	v_GLCCode    PkgTx.GlcCode%TYPE;
	v_SlpType    Slip.SlpType%TYPE;
	v_DIDeptCode Sysparam.Param1%TYPE;
	v_DeptCode   Item.DPTCode%TYPE;
	v_DSCCode    Item.DSCCode%TYPE;
	v_PtnSeq     NUMBER;
	v_PtnID      NUMBER;
	v_STNDIFlag  NUMBER;

	SLIPTX_STATUS_NORMAL VARCHAR2(1) := 'N';
BEGIN
	IF i_GlcCode IS NULL THEN
		-- get slip type
		SELECT SlpType INTO v_SlpType FROM Slip WHERE SLPNO = i_SlipNo;

		IF i_PkgcodeInLkUpGlccode THEN
			v_PackageCode := i_PackageCode;
		ELSE
			v_PackageCode := null;
		END IF;

		v_GLCCode := NHS_UTL_LookupGlCode(
			TO_CHAR(i_TransactionDate, 'DD/MM/YYYY'),
			i_ItemCode,
			i_BedCode,
			v_SlpType,
			NULL,
			NULL,
			v_PackageCode,
			i_AccomodationCode,
			i_DeptCode);
	ELSE
		v_GLCCode := i_GlcCode;
	END IF;

	UPDATE Slip SET SLPPSeq = SLPPSeq + 1 WHERE SLPNO = i_SlipNo;

	SELECT SLPPSeq - 1 INTO v_PtnSeq FROM Slip WHERE SLPNO = i_SlipNo;

	IF i_FlagToDi THEN
		SELECT DPTCode INTO v_DeptCode FROM Item WHERE ItmCode = i_ItemCode;

		SELECT Param1 INTO v_DIDeptCode FROM Sysparam WHERE PARCDE = 'DIDeptID';

		IF v_DeptCode IS NOT NULL AND INSTR(v_DIDeptCode, v_DeptCode) > 0 THEN
			v_STNDIFlag := -1;
		END IF;
	END IF;

	-- get dsc code
	SELECT DSCCode INTO v_DSCCode FROM Item WHERE ItmCode = i_ItemCode;

	-- get next PkgTx id
	SELECT Seq_PKGTX.NEXTVAL INTO v_PtnID FROM DUAL;

	INSERT INTO PkgTx (
		Ptnid,
		PtnSeq,
		PtnSts,
		PkgCode,
		ItmCode,
		Ptnoamt,
		Ptnbamt,
		DocCode,
		AcmCode,
		GlcCode,
		Usrid,
		Ptntdate,
		Ptncdate,
		Ptnrlvl,
		Slpno,
		Ptndesc,
		DscCode,
		DIXRef,
		PtndiFlag,
		PtncpsFlag,
		Unit,
		Ptndesc1,
		IRefNo
	) VALUES (
		v_PtnID,
		v_PtnSeq,
		NVL(i_Status, SLIPTX_STATUS_NORMAL),
		i_PackageCode,
		i_ItemCode,
		i_StnOAmt,
		i_StnBAmt,
		i_DoctorCode,
		i_AccomodationCode,
		v_GLCCode,
		i_UsrID,
		NVL(i_TransactionDate, SYSDATE),
		NVL(i_CaptureDate, SYSDATE),
		i_ReportLevel,
		i_SlipNo,
		i_Description,
		v_DSCCode,
		i_DIXRef,
		v_STNDIFlag,
		i_ConPceSetFlag,
		i_UnitAmt,
		i_Stndesc1,
		i_IRefNo
	);

	RETURN v_PtnID;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -1;
END NHS_UTL_AddPackageEntry;
/
