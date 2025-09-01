create or replace
FUNCTION F_CHK_FINAL_APPROVAL (
as_reqNo VARCHAR2,
as_flowId VARCHAR2,
as_flowSeq VARCHAR2,
as_amtId VARCHAR2,
as_approver VARCHAR2
)
RETURN NUMBER 
IS
	ld_currCredit	NUMBER;
	ld_minCredit	NUMBER;
  ld_apprCredit NUMBER;
  ld_remainCredit NUMBER;
BEGIN
  BEGIN
    SELECT APPROVAL_CREDIT
    INTO ld_apprCredit
    FROM EPO_APPROVE_LIST
    WHERE FLOW_ID = as_flowId
    AND FLOW_SEQ = as_flowSeq 
    AND STAFF_ID = as_approver
    ;    
  EXCEPTION
  WHEN OTHERS THEN
    ld_apprCredit := 0;
  END;

  SELECT EAL.USE_CREDIT
  INTO ld_minCredit
  FROM EPO_APPROVE_LEVEL EAL
  WHERE EAL.AMOUNT_ID = as_amtId
  ;   

  SELECT CURR_CREDIT
  INTO ld_currCredit
  FROM EPO_REQUEST_M
  WHERE REQ_NO = as_reqNo
  ;

  ld_remainCredit := ld_apprCredit - (ld_minCredit - ld_currCredit);

RETURN ld_remainCredit;
END F_CHK_FINAL_APPROVAL;