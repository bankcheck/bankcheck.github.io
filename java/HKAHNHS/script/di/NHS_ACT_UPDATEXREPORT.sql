create or replace
FUNCTION "NHS_ACT_UPDATEXREPORT"
(v_action		IN VARCHAR2,
v_mode IN VARCHAR2,
v_xrgid		IN XReport.xrgid%TYPE,
v_value1 in varchar2,
v_value2 in varchar2,
v_value3 in varchar2,
o_errmsg		OUT VARCHAR2)
	RETURN NUMBER
AS
  v_seq number;
  o_errcode	NUMBER;
  v_noOfRec NUMBER;

BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  v_noOfRec := 0;
  
--  SELECT count(1) INTO v_noOfRec FROM XReport WHERE xrgid = v_xrgid;
	IF v_action = 'ADD' THEN
    IF v_mode = 'ADDXREG' THEN
    --new String[] { "ADDXREG", xrGrid, drCode, getUserInfo().getUserID(), null });
    --insert into XReport (XrpID, XrgID, XrpDate, XrpPrnCnt, XrpCombine, UsrID_P, UsrID_T, DocCode) values (0, 0, sysdate, 0, 0, 'twah2', 'twah2', 'C205');
      Select SEQ_XREPORT.nextval into v_seq from dual;
      insert into XReport (XrpID, XrgID, XrpDate, XrpPrnCnt, XrpCombine, UsrID_P, UsrID_T, DocCode) values
                          (v_seq, v_xrgid, sysdate, 0, v_seq, v_value2, v_value2, v_value1);
      o_errcode := 0;
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_mode = 'UPDXREG' THEN    
      update XREG set XRGECGFLAG = to_number(v_value1), xrgSndDate = null where xrgid = v_xrgid; 
      o_errcode := 0;
    ELSIF v_mode = 'UPDXREG2' THEN    
      update XREG set XRGECGFLAG = to_number(v_value1) where xrgid = v_xrgid; 
      o_errcode := 0;
    ELSIF v_mode = 'UPDXREG3' THEN    
      update XREG set XRGECGFLAG = to_number(v_value1), xrgSndDate = sysdate where xrgid = v_xrgid; 
      o_errcode := 0;      
    ELSIF v_mode = 'UPDXREPORT' THEN    
      update XReport set doccode = v_value1,  UsrID_P = v_value2, UsrID_T = v_value3 where xrgid = v_xrgid; 
      o_errcode := 0;    
    ELSIF v_mode = 'UPDDOCINCOME' THEN    
      update docincome set wofFlg = to_number(v_value1) where dixref = (select stnID from xReg where xrgID = v_xrgid); 
      o_errcode := 0;    
    ELSIF v_mode = 'UPDSLIPTX' THEN    
      update slipTx set stnDIDoc = null where dixref = (select stnID from xReg where xrgID = v_xrgid); 
      o_errcode := 0;          
    END IF;
  ELSIF v_action = 'DEL' THEN   
    IF v_mode = 'DELXReport' THEN    
      SELECT count(1) INTO v_noOfRec FROM XReport WHERE xrgid = v_xrgid;
      IF v_noOfRec > 0 THEN
        DELETE XReport WHERE xrgid = v_xrgid;
      ELSE
        o_errcode := 0;
        --o_errcode := -1;
        --o_errmsg := 'Fail to delete due to record not exist.';
      END IF;
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_UPDATEXREPORT;