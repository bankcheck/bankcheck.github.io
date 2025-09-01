CREATE OR REPLACE FUNCTION "NHS_ACT_ITEMCHG" (
	v_action    IN  VARCHAR2,
	v_slpno     IN  SLIP.SLPNO%TYPE,
	v_pkgcode   IN  VARCHAR2,
	v_itmcode   IN  VARCHAR2,
	v_amount    IN  VARCHAR2,
	v_StnOAmt   IN  VARCHAR2,
	v_StnBAmt   IN  VARCHAR2,
	v_discount  IN  VARCHAR2,
	v_stntdate  IN  VARCHAR2,
	v_doccode   IN  VARCHAR2,
	v_acmcode   IN  VARCHAR2,
	v_flagToDi  IN  VARCHAR2,
	v_cpsid     IN  VARCHAR2,
	v_unit      IN  VARCHAR2,
	v_stndesc1  IN  VARCHAR2,
	v_ref_no    IN  VARCHAR2,
	v_pkgrlvl   IN  VARCHAR2,
	v_StnType   IN  VARCHAR2,
	v_ItmCat    IN  VARCHAR2,
	v_BedCode   IN  VARCHAR2,
	i_usrid     IN  VARCHAR2,
	o_errmsg    OUT VARCHAR2
)
	RETURN NUMBER
AS
	p_usrid USR.USRID%TYPE;
	p_ItmCat ITEM.ITMCAT%TYPE;
	p_DpsCDate DATE;
	p_StnDisc SlipTx.STNDISC%TYPE;
	p_StnCDate SlipTx.STNCDATE%TYPE;
	p_StnTDate SlipTx.STNTDATE%TYPE;
	p_stndesc ITEM.ITMNAME%TYPE;
	p_StnSts SlipTx.STNSTS%TYPE;
	p_GlcCode SlipTx.GLCCODE%TYPE;
	p_StnXRef SlipTx.STNXREF%TYPE;
	p_DixRef SlipTx.DIXREF%TYPE;
	p_StnDiFlag SlipTx.STNDIFLAG%TYPE;
	p_StnCpsFlag SlipTx.STNCPSFLAG%TYPE;
	RS_SLIP SLIP%ROWTYPE;
	RS_ITEM ITEM%ROWTYPE;
BEGIN
	IF v_action = 'ADD' THEN
		SELECT * INTO RS_SLIP FROM SLIP WHERE SLPNO = v_slpno;
		SELECT * INTO RS_ITEM FROM ITEM WHERE ITMCODE = v_itmcode;

		p_usrid := i_usrid;
		p_ItmCat := RS_ITEM.ITMCAT;
		p_DpsCDate := SYSDATE;
		p_StnCDate := SYSDATE;
		p_StnTDate := to_date(v_StnTDate, 'dd/MM/yyyy');
		p_stndesc := RS_ITEM.ITMNAME;

		p_StnSts := '';
		p_GlcCode := '';
		p_StnXRef := '';
		p_DixRef := '';
		IF v_flagToDi = 'Y' THEN
			p_StnDiFlag := '-1';
		END IF;
		p_StnCpsFlag := '';

		IF RS_ITEM.ITMTYPE = 'H' THEN
			p_StnDisc := RS_SLIP.SLPHDISC;
		END IF;
		IF RS_ITEM.ITMTYPE = 'D' THEN
			p_StnDisc := RS_SLIP.SLPDDISC;
		END IF;
		IF RS_ITEM.ITMTYPE = 'S' THEN
			p_StnDisc := RS_SLIP.SLPSDISC;
		END IF;

		NHS_SYS_AddCharge(
			p_usrid,
			'ADD',
			v_itmcode,
			RS_ITEM.ITMTYPE,
			v_ItmCat,
			-- Deposit columns : begin
			v_amount,
			v_slpno,
			p_DpsCDate,
			p_stntdate,
			-- Deposit columns : end

			-- AddSlipTx : Begin
			v_StnType,
			v_StnOAmt,
			v_StnBAmt,
			v_doccode,
			v_pkgrlvl,
			v_acmcode,
			p_StnDisc,
			v_pkgcode,
			p_StnCDate,
			p_StnTDate,
			p_stndesc,
			p_StnSts,
			p_GlcCode,
			p_StnXRef,
			v_BedCode,
			p_DixRef,
			p_StnDiFlag,
			p_StnCpsFlag,
			v_cpsid,
			v_unit,
			v_stndesc1,
			v_ref_no
		);
	END IF;

	RETURN 0;
END NHS_ACT_ITEMCHG;
/
