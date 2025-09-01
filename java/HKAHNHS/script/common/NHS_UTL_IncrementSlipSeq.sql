create or replace FUNCTION NHS_UTL_IncrementSlipSeq(
	a_SlipNo IN VARCHAR2
)
	return number
IS
	v_seqno number;
BEGIN
	UPDATE slip SET slpseq = slpseq + 1 WHERE SlpNo = a_SlipNo;

	SELECT slpseq - 1 INTO v_seqno FROM slip WHERE slpno = a_SlipNo;
	RETURN v_seqno;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -999;
END NHS_UTL_IncrementSlipSeq;
/
