create or replace
FUNCTION NHS_ACT_TXNSLIPTX_MODIFY (
	i_action         IN VARCHAR2,
	i_btnaction      IN VARCHAR2,
	i_slpno          IN VARCHAR2,
	i_StnID          IN VARCHAR2,
	i_amount         IN VARCHAR2,
	i_description    IN VARCHAR2,
	i_txdate         IN VARCHAR2,
	i_doccode        IN VARCHAR2,
	i_withdi         IN VARCHAR2,
	i_enhancement_01 IN VARCHAR2,
	i_scm            IN VARCHAR2,
	i_stnsts         IN VARCHAR2,
	i_usrid          IN VARCHAR2,
	o_errmsg         OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_errcode NUMBER;
	v_errmsg VARCHAR2(1000);
	v_noOfRec NUMBER;
	v_Stnid NUMBER;
	v_nextStnSeq NUMBER;
	v_expiryDate VARCHAR2(50);
  
  v_oldDoctor SLIPTX.DOCCODE%TYPE;
  v_itmcode SLIPTX.ITMCODE%TYPE;
  v_pkgcode SLIPTX.PKGCODE%TYPE;
  v_acmcode SLIPTX.ACMCODE%TYPE;
  v_stntdate SLIPTX.STNTDATE%TYPE;
  v_arccode SLIP.ARCCODE%TYPE;

	DOCTOR_STATUS_ACTIVE NUMBER := -1;
	MSG_DOCTOR_CODE VARCHAR2(20) := 'Invalid doctor code.';
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT COUNT(1) INTO v_noOfRec FROM SlipTx where StnID = i_StnID;

	IF i_action = 'MOD' AND v_noOfRec > 0 THEN
		IF i_btnaction = 'UPDATE' THEN
			SELECT COUNT(1) INTO v_noOfRec FROM Doctor WHERE UPPER(DocCode) = UPPER(i_docCode) AND DocSts = DOCTOR_STATUS_ACTIVE;
			IF v_noOfRec = 1 THEN
      
        SELECT DOCCODE, ITMCODE, PKGCODE,ACMCODE, STNTDATE INTO v_oldDoctor, v_itmcode, v_pkgcode, v_acmcode, v_stntdate FROM SLIPTX WHERE STNID = i_StnID;
        SELECT ARCCODE INTO v_arccode FROM SLIP WHERE slpno = i_slpno;
        
				o_errcode := NHS_ACT_SLPPAYALLDOCCODERVS(i_action, i_StnID, i_docCode, o_errmsg);
        
        IF (NHS_UTL_ARDRCHG_EXIST1(v_itmcode, v_pkgcode, i_slpno, v_acmcode, i_docCode, v_stntdate,v_arccode) > 0 OR 
              NHS_UTL_ARDRCHG_EXIST1(v_itmcode, v_pkgcode, i_slpno, v_acmcode, v_oldDoctor, v_stntdate,v_arccode) > 0) Then
                  --create new NCR entry, will update the C entry back to original doctor
          				o_errcode := NHS_ACT_ADJUSTARDRCHGENTRY('ADD', i_SlpNo, i_stnid,i_docCode,v_arccode, i_UsrId, o_errmsg);

        END IF;

				IF o_errcode = 0 AND i_txdate IS NOT NULL THEN
					UPDATE SlipTx SET StnTDate = TO_DATE(i_txdate, 'dd/mm/yyyy') WHERE StnID = i_StnID AND StnADoc IS NULL;
					v_errcode := NHS_ACT_SYSLOG('ADD', 'SlipTxLog', 'Modify StnTDate to ' || i_txdate || ' @ StnID ' || i_StnID, i_slpno, i_usrid, 'USER_PC', v_errmsg);
				END IF;
			ELSE
				SELECT TO_CHAR(DOCTDATE, 'DD/MM/YYYY') INTO v_expiryDate
				FROM Doctor
				WHERE UPPER(DocCode) = UPPER(i_docCode);

				o_errcode := -1;
				o_errmsg := MSG_DOCTOR_CODE||'<br/>Admission Expiry Date: '||v_expiryDate;
			END IF;
		ELSIF i_btnaction = 'ADJUST' THEN
			o_errcode := NHS_UTL_ADJUSTENTRY(
				i_slpno,
				i_StnID,
				i_amount,
				i_description,
				TO_DATE(i_txdate, 'dd/mm/yyyy'),
				SYSDATE,
				i_usrid,
				o_errmsg
			);

			IF o_errcode > 0 THEN
				NHS_UTL_UPDATESLIP(i_slpno);
			ELSE
				ROLLBACK;
			END IF;
		END IF;
	ELSE
		o_errcode := -1;
		o_errmsg := 'Fail to update due to record not exist.';
	END IF;

	RETURN o_errcode;

EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('SQL Error: '||SQLCODE||' - '||SQLERRM);
	o_ERRMSG := 'SQL Error: '||SQLCODE||' - '||SQLERRM;
	ROLLBACK;
	RETURN -999;

END NHS_ACT_TXNSLIPTX_MODIFY;
/
