CREATE OR REPLACE FUNCTION NHS_ACT_ADDENTRY(
    v_action           IN VARCHAR2,
    i_SlipNo           IN VARCHAR2,
    i_ItemCode         IN VARCHAR2,
    i_ItemType         IN VARCHAR2,
    i_EntryType        IN VARCHAR2,
    i_StnOAmt          IN VARCHAR2,
    i_StnBAmt          IN VARCHAR2,
    i_DoctorCode       IN VARCHAR2,
    i_ReportLevel      IN VARCHAR2,
    i_AccomodationCode IN VARCHAR2,
    i_Discount         IN VARCHAR2,
    i_PackageCode      IN VARCHAR2,
    i_capturedate      IN VARCHAR2,
    i_TransactionDate  IN VARCHAR2,
    i_Description      IN VARCHAR2,
    i_Status           IN VARCHAR2,
    i_GlcCode          IN VARCHAR2,
    i_ReferenceID      IN VARCHAR2,
    i_CashierClosed    IN VARCHAR2,--1-true,0-false
    i_BedCode          IN VARCHAR2,
    i_dixref           IN VARCHAR2,
    i_flagToDi         IN VARCHAR2,--1-true,0-false
    i_ConPceSetFlag    IN VARCHAR2,
    i_Cpsid            IN VARCHAR2,
    i_as_unit          IN VARCHAR2,
    i_Stndesc1         IN VARCHAR2,
    i_IRefNo           IN VARCHAR2,
    i_usrid            IN VARCHAR2,
    o_errmsg           OUT VARCHAR2
)
	return NUMBER
AS
    o_errcode  NUMBER;
BEGIN
	o_errmsg := 'OK';
	o_errcode := 0;

	IF v_action ='ADD' THEN
		o_errcode := NHS_UTL_ADDENTRY(
			i_SlipNo,
			i_ItemCode,
			i_ItemType,
			i_EntryType,
			TO_NUMBER(i_StnOAmt),
			TO_NUMBER(i_StnBAmt),
			i_DoctorCode,
			TO_NUMBER(i_ReportLevel),
			i_AccomodationCode,
			TO_NUMBER(i_Discount),
			i_PackageCode,
			TO_DATE(i_capturedate, 'DD/MM/YYYY HH24:MI:SS'),
			TO_DATE(i_TransactionDate, 'DD/MM/YYYY HH24:MI:SS'),
			i_Description,
			i_Status,
			i_GlcCode,
			TO_NUMBER(i_ReferenceID),
			CASE WHEN i_CashierClosed = '-1' THEN TRUE ELSE FALSE END,
			i_BedCode,
			TO_NUMBER(i_dixref),
			CASE WHEN i_flagToDi = '-1' THEN TRUE ELSE FALSE END,
			i_ConPceSetFlag,
			TO_NUMBER(i_Cpsid),
			TO_NUMBER(i_as_unit),
			i_Stndesc1,
			i_IRefNo,
			NULL,
			i_usrid
		);

		IF o_errcode < 0 THEN
			ROLLBACK;
			o_errmsg := 'insert fail.';
			RETURN o_errcode;
		END IF;
	ELSE
		o_errmsg := 'parameter error.';
		o_errcode := -1;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ErrMsg := SQLERRM || o_ErrMsg;

	o_errcode := -999;
	return o_errcode;
END NHS_ACT_ADDENTRY;
/
