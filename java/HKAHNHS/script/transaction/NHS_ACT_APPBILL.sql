create or replace FUNCTION NHS_ACT_APPBILL(
	v_action      IN VARCHAR2,
  v_billType    IN VARCHAR2,
	v_patno       IN VARCHAR2,
	v_pamt        IN VARCHAR2,
	v_oamt        IN VARCHAR2,
  v_title       IN VARCHAR2,
	v_cdate       IN VARCHAR2,
	v_tdate       IN VARCHAR2,
  v_rmk         IN VARCHAR2,
  v_user        IN VARCHAR2,
  v_slpno       IN VARCHAR2,
  v_billno      IN VARCHAR2,
  v_isdisable   IN varchar2,
  v_stmtType    IN VARCHAR2,
	o_errmsg      OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	v_billID NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';
	if v_action = 'ADD' then
		select SEQ_APPBILLS.NEXTVAL into v_billID from dual;

		insert into APPBILLS(
			BILLID,
      BILLTYPE,
			PATNO,
			BILLPAMT,
			BILLOAMT,
			BILLTITLE,
			BILLREMARK,
			ISDISPAYMT,
			BILLDATE,
			BILLCUSER,
			BILLTDATE,
      BILLSTS,
      SLPNO,
      BILLSTMTTYPE
		) values(
			v_billID,
      v_billType,
			v_patno,
			0,
			to_number(v_oamt),
			v_title,
			v_rmk,
			v_isdisable,
			v_cdate,
			v_user,
			null,
     'N',
      v_slpno,
      v_stmtType
		);
  ELSIF v_action = 'DEL' then
      UPDATE APPBILLS SET BILLSTS = 'D' WHERE BILLID = v_billno;
  END IF;
	RETURN v_billID;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
  	o_ERRCODE := -1;
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN o_errcode;
end NHS_ACT_APPBILL;
/