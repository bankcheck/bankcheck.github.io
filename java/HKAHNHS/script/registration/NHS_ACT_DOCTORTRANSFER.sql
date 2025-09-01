CREATE OR REPLACE FUNCTION NHS_ACT_DOCTORTRANSFER (
	i_action     IN VARCHAR2,
	i_docHistID  IN VARCHAR2,
	i_RegID      IN VARCHAR2,
	i_PatNo      IN VARCHAR2,
	i_DoctorCode IN VARCHAR2,
	i_StartDate  IN VARCHAR2,
	i_EndDate    IN VARCHAR2,
	i_userId     IN VARCHAR2,
	o_errmsg     OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_docHistID NUMBER;
	v_DhsSts VARCHAR2(1);
	v_count	NUMBER;
	SQLSTR VARCHAR2(1000);

	DOCHIST_NOCHANGE VARCHAR2(1):= 'N';
	DOCHIST_CHANGED VARCHAR2(1):= 'C';
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	IF i_action = 'ADD' THEN
		SELECT seq_dochist.NEXTVAL INTO v_docHistID FROM DUAL;

		SELECT COUNT(1) INTO v_count FROM DocHist where RegID = i_RegID;

		IF v_count > 0 THEN
			v_DhsSts := DOCHIST_CHANGED;
		ELSE
			v_DhsSts := DOCHIST_NOCHANGE;
		END IF;

		INSERT INTO DocHist (
			DhsID, RegID, PatNo, DocCode, DhsDate, DhsEDate, DhsSts, UsrID
		) VALUES (
			v_docHistID,
			TO_NUMBER(i_RegID),
			i_PatNo,
			i_DoctorCode,
			TO_DATE(i_StartDate, 'DD/MM/YYYY HH24:MI:SS'),
			TO_DATE(i_EndDate, 'DD/MM/YYYY HH24:MI:SS'),
			v_DhsSts,
			i_userId
		);

		IF SQL%rowcount = 0 THEN
			o_errmsg := 'insert fail.';
	        o_errcode := -1;
		END IF;
	ELSIF i_action = 'MOD' THEN
		SQLSTR := 'UPDATE DocHist SET DocCode = ''' || i_DoctorCode || '''';

		IF i_StartDate IS NOT NULL THEN
			SQLSTR := SQLSTR || ', DhsDate = TO_DATE(''' || i_StartDate || ''', ''DD/MM/YYYY HH24:MI:SS'')';
		END IF;

		IF i_EndDate IS NOT NULL THEN
			SQLSTR := SQLSTR || ', DhsEDate = TO_DATE(''' || i_EndDate || ''', ''DD/MM/YYYY HH24:MI:SS'')';
		END IF;

		SQLSTR := SQLSTR || ' WHERE DhsID = ''' || i_docHistID || '''';

		EXECUTE IMMEDIATE SQLSTR;

		IF SQL%rowcount = 0 THEN
			o_errmsg := 'update fail.';
	        o_errcode := -1;
		END IF;
	ELSE
		o_errmsg := 'invalid action.';
        o_errcode := -1;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	o_errmsg := SQLERRM;
	o_errcode := -1;
	RETURN o_errcode;
END NHS_ACT_DOCTORTRANSFER;
/
