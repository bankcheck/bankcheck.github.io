CREATE OR REPLACE FUNCTION NHS_ACT_DOCFEE_UPDCHKPT (
v_ACTION			IN VARCHAR2,
v_DATEEND 			IN VARCHAR2,
v_SPHID				IN VARCHAR2,
v_STATUS			IN VARCHAR2,
v_NEXTNO			IN VARCHAR2,
v_PCYID				IN VARCHAR2,
v_REPORT_NAME		IN VARCHAR2,
v_UserID			IN VARCHAR2,
v_MACHINE_NAME		IN VARCHAR2,
o_ERRMSG			OUT VARCHAR2)
	RETURN NUMBER
AS
	o_ERRCODE  NUMBER;
	v_Count    NUMBER;
BEGIN
	o_ERRMSG  := 'OK';
	o_ERRCODE := -1;
	
	IF v_DATEEND IS NOT NULL THEN
		INSERT INTO df_chkpt(dateend, SPHID, status, pcyid, report, usrid, machine)
		VALUES (
			TO_DATE(v_DATEEND, 'DD/MM/YYYY'),
			v_SPHID,
			v_STATUS,
			v_PCYID,
			v_REPORT_NAME,
			v_UserID,
			v_MACHINE_NAME
		);
		
		o_ERRCODE := 0;
		--DocFeeLog "Start"
	ELSE
		o_ERRCODE := 1;
        If v_NEXTNO IS NOT NULL Then
        	UPDATE df_chkpt set nextNo = v_NEXTNO;
        	o_ERRCODE := 2;
            --DocFeeLog nextNo
        ELSIF v_STATUS IS NOT NULL Then
        	UPDATE df_chkpt set status = v_STATUS, nextNo = null;
        	o_ERRCODE := 3;
            -- DocFeeLog Status
        End If;
	END IF;
	RETURN o_ERRCODE;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ERRMSG := SQLERRM;

	RETURN -999;
END NHS_ACT_DOCFEE_UPDCHKPT;
/
