CREATE OR REPLACE FUNCTION "NHS_UTL_ADDTXENTRY" (
  a_RegType IN VARCHAR2,
  a_ID IN NUMBER,
  a_BAmt IN NUMBER,
  a_NAmt IN NUMBER,
  a_StnID IN NUMBER,
  a_TxDate IN DATE,
  a_CapDate IN DATE,
  a_sts IN VARCHAR2,
  a_Slpno IN VARCHAR2,
  a_refID IN NUMBER,
  a_PkgCode IN VARCHAR2,
  o_ret_id OUT NUMBER,
  o_errmsg OUT VARCHAR2)
RETURN NUMBER
AS
  v_REG_TYPE_OUTPATIENT VARCHAR2(1) := 'O';
  v_errmsg VARCHAR2(50);
BEGIN
  If a_RegType = v_REG_TYPE_OUTPATIENT Then
    v_errmsg := 'AddOPTXEntry';
    SELECT SEQ_OPTX.nextval INTO o_ret_id FROM dual;
    INSERT INTO OPTX (OTXID, REHID, OTXBAMT, OTXNAMT, STNID, OTXTDATE, OTXCDATE, OTXSTS, SLPNO, OTXREF, PKGCODE)
    VALUES (o_ret_id, a_ID, a_BAmt, a_NAmt, a_StnID, a_TxDate, a_CapDate, a_sts, a_Slpno, a_refID, a_PkgCode);
  Else
    v_errmsg := 'AddIPTXEntry';
    SELECT SEQ_IPTX.nextval INTO o_ret_id FROM dual;
    INSERT INTO IPTX (ITXID, PMRID, ITXBAMT, ITXNAMT, STNID, ITXTDATE, ITXCDATE, ITXSTS, SLPNO, ITXREF, PKGCODE)
    VALUES (o_ret_id, a_ID, a_BAmt, a_NAmt, a_StnID, a_TxDate, a_CapDate, a_sts, a_Slpno, a_refID, a_PkgCode);
  End If;
  RETURN o_ret_id;

  EXCEPTION
    WHEN OTHERS THEN
      o_errmsg := v_errmsg || ' ' || SQLERRM;
      RETURN -1;
END NHS_UTL_ADDTXENTRY;
/
