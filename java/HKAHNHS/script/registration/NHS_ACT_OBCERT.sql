CREATE OR REPLACE FUNCTION NHS_ACT_OBCERT (
	v_action     IN VARCHAR2,
	v_currMode   IN VARCHAR2,
	v_certNo     IN VARCHAR2,
	v_bookingNo  IN VARCHAR2,
	v_patNo      IN VARCHAR2,
	v_patname    IN VARCHAR2,
	v_patcname   IN VARCHAR2,
	v_patDOB     IN VARCHAR2,
	v_patDocType IN VARCHAR2,
	v_patIDNo    IN VARCHAR2,
	v_isHKSpouse IN VARCHAR2,
	v_DrName     IN VARCHAR2,
	v_DrMCHNo    IN VARCHAR2,
	v_DrTel      IN VARCHAR2,
	v_antChkDt1  IN VARCHAR2,
	v_antChkDt2  IN VARCHAR2,
	v_antChkDt3  IN VARCHAR2,
	v_antChkDt4  IN VARCHAR2,
	v_antChkDt5  IN VARCHAR2,
	v_antChkDt6  IN VARCHAR2,
	v_patEDC     IN VARCHAR2,
	v_husName    IN VARCHAR2,
	v_husCname   IN VARCHAR2,
	v_husIDNo    IN VARCHAR2,
	v_isHusHKPm  IN VARCHAR2,
	v_husDOB     IN VARCHAR2,
	v_patMDate   IN VARCHAR2,
	v_patMCtNo   IN VARCHAR2,
	v_cIseDate   IN VARCHAR2,
	v_cIseBy     IN VARCHAR2,
	v_isValid    IN VARCHAR2,
	v_validDate  IN VARCHAR2,
	v_cancelDate IN VARCHAR2,
	v_repltRsn   IN VARCHAR2,
	v_remark     IN VARCHAR2,
	v_user       IN VARCHAR2,
	o_errmsg     OUT VARCHAR2
)
	RETURN NUMBER
as
	o_errcode NUMBER;
	v_Count NUMBER;
	v_certCount NUMBER;

begin
	o_errcode := 0;
	o_errmsg := 'OK';
	v_count :=0;
	v_certCount := 0;

	SELECT COUNT(1) INTO v_Count FROM OBCERT WHERE CERTNO = v_certNo;
	SELECT COUNT(1) + 1 into v_certCount FROM OBCERT WHERE BOOKINGNO = v_bookingNo;

  	IF v_currMode = 'newCert' AND v_Count = 0 THEN
	  	INSERT INTO OBCERT
		values (
			v_certNo,
			v_bookingNo,
			v_certCount,
			v_patname,
			v_patcname,
			v_patNo,
			TO_DATE(v_patDOB, 'DD/MM/YYYY'),
			v_patDocType,
			v_patIDNo,
			v_isHKSpouse,
			v_DrName,
			v_DrMCHNo,
			v_DrTel,
			TO_DATE( v_antChkDt1, 'DD/MM/YYYY'),
			TO_DATE(v_antChkDt2, 'DD/MM/YYYY'),
			TO_DATE(v_antChkDt3, 'DD/MM/YYYY'),
			TO_DATE(v_antChkDt4, 'DD/MM/YYYY'),
			TO_DATE(v_antChkDt5, 'DD/MM/YYYY'),
			TO_DATE(v_antChkDt6, 'DD/MM/YYYY'),
			TO_DATE(v_patEDC, 'DD/MM/YYYY'),
			v_husName,
			v_husCname,
			v_husIDNo,
			v_isHusHKPm,
			TO_DATE(v_husDOB, 'DD/MM/YYYY'),
			TO_DATE(v_patMDate, 'DD/MM/YYYY'),
			v_patMCtNo,
			TO_DATE(v_cIseDate, 'DD/MM/YYYY'),
			v_cIseBy,
			v_isValid,
			TO_DATE(v_validDate, 'DD/MM/YYYY'),
			'',
			TO_DATE(v_cancelDate, 'DD/MM/YYYY'),
			v_repltRsn,
			v_remark,
			v_user, sysdate, v_user, sysdate
		);
  	ELSIF v_currMode = 'searchCert' and v_count > 0 then
	  	UPDATE OBCert set
			BOOKINGNO    =  v_bookingNo,
			CERT_SEQ     =  0,
			PATNAME      =  v_patname,
			PATCNAME     =  v_patcname,
			PATNO        =  v_patNo,
			PATDOB       =  TO_DATE(v_patDOB, 'DD/MM/YYYY'),
			PATDOCTYPE   =  v_patDocType,
			PATIDNO      =  v_patIDNo,
			ISHKSPOUSE   =  v_isHKSpouse,
			DRNAME       =  v_DrName,
			DRMCHKNO     =  v_DrMCHNo,
			DRTEL        =  v_DrTel,
			ANTCHKDT1    =  TO_DATE( v_antChkDt1, 'DD/MM/YYYY'),
			ANTCHKDT2    =  TO_DATE(v_antChkDt2, 'DD/MM/YYYY'),
			ANTCHKDT3    =  TO_DATE(v_antChkDt3, 'DD/MM/YYYY'),
			ANTCHKDT4    =  TO_DATE(v_antChkDt4, 'DD/MM/YYYY'),
			ANTCHKDT5    =  TO_DATE(v_antChkDt5, 'DD/MM/YYYY'),
			ANTCHKDT6    =  TO_DATE(v_antChkDt6, 'DD/MM/YYYY'),
			PATEDC       =  TO_DATE(v_patEDC, 'DD/MM/YYYY'),
			CISEDATE     =  TO_DATE(v_cIseDate, 'DD/MM/YYYY'),
			CISSUEBY     =  v_cIseBy,
			ISVALID      =  v_isValid,
			VALIDTILDT   =  TO_DATE(v_validDate, 'DD/MM/YYYY'),
			INVALIDRSN   =  '',
			CANCELDATE   =  TO_DATE(v_cancelDate, 'DD/MM/YYYY'),
			REPLTRSN     =  v_repltRsn,
			REMARK       =  v_remark,
			MODIFY_USER =  v_user,
			MODIFY_DATE  =  sysdate
		WHERE certno = v_certno;
  	else
		o_errcode := -1;
		o_errmsg := 'Fail to add due to cert number used.';
  	end if;

	RETURN o_errcode;
end NHS_ACT_OBCERT;
/
