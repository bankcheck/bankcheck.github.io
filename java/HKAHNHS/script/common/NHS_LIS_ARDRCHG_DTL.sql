create or replace FUNCTION NHS_LIS_ARDRCHG_DTL(
	i_slpNo IN VARCHAR2,
	i_itmcode IN VARCHAR2,
	i_pkgcode IN VARCHAR2,
	i_acmcode IN VARCHAR2,
	i_doccode IN VARCHAR2,
	i_arccode IN VARCHAR2,
	i_transdate IN VARCHAR2,
	i_userID IN VARCHAR2
)
	RETURN types.cursor_type
AS
	o_outcur types.cursor_type;
	v_Count    NUMBER;
	v_stnamt ITEMCHG.ITCAMT1%TYPE;
	v_ardramt ARDRCHG.ARDCAMT%TYPE;
	v_ardrpct ARDRCHG.ARDCPCT%TYPE;
	o_errmsg VARCHAR2(200);
	v_CursorType 	TYPES.CURSOR_TYPE;
	v_arccode SLIP.ARCCODE%TYPE;
	v_ardctype SLIP.SLPTYPE%TYPE;

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
	r_docharge ItemChg_Rec;
BEGIN
	v_ardramt := null;
	v_ardrpct := null;
	v_stnamt := null;
	SELECT SLPTYPE INTO  V_ARDCTYPE FROM SLIP WHERE SLPNO = I_SLPNO;

	IF (I_PKGCODE IS NOT NULL AND I_ITMCODE IS NOT NULL) THEN
		o_outcur :=  NHS_UTL_ITMPKGCODEVALIDATE('ADD',i_transdate, i_slpNo, v_ardctype,
			'R', i_pkgcode, i_doccode, i_acmcode, 1,
			0, 0, 0, 0, i_userID,
			o_errmsg);
	ELSE
		o_outcur :=  NHS_UTL_ITMPKGCODEVALIDATE('ADD',i_transdate, i_slpNo, v_ardctype,
			'R', i_itmcode, i_doccode, i_acmcode, 1,
			0, 0, 0, 0, i_userID,
			o_errmsg);
	END IF;

	IF O_OUTCUR IS NOT NULL THEN
		LOOP
			FETCH o_outcur INTO r_docharge;
			EXIT WHEN o_outcur%notfound;
			if (r_docharge.itmcode = i_itmcode) THEN
				V_STNAMT := R_DOCHARGE.STNBAMT;
			END IF;
		END LOOP;
	END IF;
	DBMS_OUTPUT.PUT_LINE('NHS_UTL_ARDRCHG_EXIST1('||I_ITMCODE||', '||I_PKGCODE||', '||I_SLPNO||', '||I_ACMCODE||', '
		||I_DOCCODE||', '||I_TRANSDATE||', '||I_ARCCODE||')');

	IF NHS_UTL_ARDRCHG_EXIST1(I_ITMCODE, I_PKGCODE, I_SLPNO, I_ACMCODE, I_DOCCODE, I_TRANSDATE, I_ARCCODE) > 0 THEN
		select ARDCAMT, ARDCPCT INTO v_ardramt,v_ardrpct from ardrchg
		where itmcode= i_itmcode
		and ARCCODE = i_arccode
		AND ARDCTYPE = v_ardctype
		AND ((i_pkgcode IS NULL AND PKGCODE IS NULL) OR PKGCODE = i_pkgcode)
		AND ((i_acmcode IS NULL AND ACMCODE IS NULL) OR ACMCODE = i_acmcode)
		AND DOCCODE = i_doccode
		AND ( i_transdate IS NULL OR ARDCSDT <= TO_DATE(i_transdate,'dd/mm/yyyy') OR ARDCSDT IS NULL)
		AND ( i_transdate IS NULL OR ARDCEDT >= TO_DATE(i_transdate,'dd/mm/yyyy') OR ARDCEDT IS NULL);
	END IF;
	DBMS_OUTPUT.PUT_LINE('v_ardramt = ' || v_ardramt||'v_ardrpct='||v_ardrpct||'v_stnamt:'||v_stnamt||'r_docharge.stnbamt='||r_docharge.stnbamt);

	OPEN o_outcur FOR
		SELECT v_ardramt,v_ardrpct,v_stnamt from dual;
	RETURN o_outcur;
END NHS_LIS_ARDRCHG_DTL;
/
