create or replace FUNCTION NHS_ACT_APPBILL_TRANSFER(
	v_action      IN VARCHAR2,
  v_billid    IN VARCHAR2,
  v_billstxid IN VARCHAR2,
  v_slpno     IN VARCHAR2,
  v_ref       IN VARCHAR2,
  v_user        IN VARCHAR2,
  v_cardtype     IN VARCHAR2,
	o_errmsg      OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	v_billtxID NUMBER;
  v_cashierCode CASHIER.CSHCODE%TYPE;
  v_pamt APPBILLSTX.BILLTXAMT%TYPE;
  v_txDate APPBILLSTX.TXDATE%TYPE;
  v_cardNo APPBILLSTX.CARDNO%TYPE;
  v_txID  APPBILLSTX.TXID%TYPE;
  v_refID APPBILLSTX.REFID%TYPE;
  v_payCode VARCHAR2(2);
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';


  
  SELECT COUNT(1) INTO v_noOfRec FROM Cashier WHERE UsrID = v_user;
	IF v_noOfRec > 0 THEN
			SELECT CshCode INTO v_cashierCode FROM Cashier WHERE UsrID = v_user;
      
      SELECT BILLTXAMT, TXDATE, CARDNO, TXID, REFID 
      INTO v_pamt, v_txDate,  v_cardNo, v_txID, v_refID
      FROM APPBILLSTX WHERE BILLTXID = v_billstxid;
      
      SELECT PAYCODE into v_payCode FROM CARDRATE WHERE CRANAME = v_cardtype;
      
      o_errcode:= NHS_ACT_PAYMENTCAPTURE('ADD',v_user,v_cashierCode,v_payCode, 
                                        NULL, v_txDate, v_pamt, v_slpno, 
                                        'N', NULL,
                                        NULL,v_ref,NULL, NULL,
                                        NULL,v_txDate, v_cardType, v_cardNo,NULL,NULL,
                                        NULL,NULL,NULL,NULL, NULL,NULL,v_txID, NULL,NULL,NULL,NULL,o_errmsg);
      IF o_errcode > -1 THEN                                  
        UPDATE APPBILLSTX SET BILLTXSTS =  'T' WHERE BILLTXID = v_billstxid;
      END IF;
 END IF;
  
	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
  	o_ERRCODE := -1;
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN o_errcode;
end NHS_ACT_APPBILL_TRANSFER;
/